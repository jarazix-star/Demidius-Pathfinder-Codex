param(
    [string]$WikiRoot = (Join-Path $PSScriptRoot '..\Demidius-Pathfinder-Codex.wiki'),
    [string]$JsonOutputPath,
    [switch]$FailOnIssues,
    [string[]]$ArtExclusions = @(
        'Boons.md',
        'Campaign-Rules.md',
        'Changelog.md',
        'Editorial Standards.md',
        'Getting Started.md',
        'Mocha-Frapachino.md',
        'Option-Index.md',
        'Peppermint-Mocha.md',
        'Repository-Architecture.md',
        'Scope & Design Philosophy.md',
        'Source-Processing-Log.md'
    )
)

$ErrorActionPreference = 'Stop'
$WikiRoot = (Resolve-Path -LiteralPath $WikiRoot).Path

function Get-WikiKey {
    param([string]$Value)

    $leaf = [IO.Path]::GetFileNameWithoutExtension(($Value -replace '\\', '/'))
    return (($leaf.Trim().ToLowerInvariant() -replace '[\s_-]+', '-') -replace '[’‘]', "'")
}

function Remove-MarkdownCode {
    param([string]$Text)

    $withoutFences = [regex]::Replace($Text, '(?ms)^[ \t]*```[^\r\n]*\r?\n.*?^[ \t]*```[ \t]*\r?$', '')
    $withoutFences = [regex]::Replace($withoutFences, '(?ms)^[ \t]*~~~[^\r\n]*\r?\n.*?^[ \t]*~~~[ \t]*\r?$', '')
    return [regex]::Replace($withoutFences, '`[^`\r\n]*`', '')
}

function Get-MarkdownTarget {
    param([string]$RawTarget)

    $target = $RawTarget.Trim()
    if ($target.StartsWith('<') -and $target.Contains('>')) {
        return $target.Substring(1, $target.IndexOf('>') - 1)
    }

    # Remove an optional Markdown title: (Page "title") or (Page 'title').
    return ($target -replace '\s+["''].*$', '').Trim()
}

function Resolve-LocalTarget {
    param(
        [string]$SourceDirectory,
        [string]$Target
    )

    $relative = $Target -replace '/', [IO.Path]::DirectorySeparatorChar
    return [IO.Path]::GetFullPath((Join-Path $SourceDirectory $relative))
}

$pageFiles = @(Get-ChildItem -LiteralPath $WikiRoot -File -Filter '*.md')
$pages = @{}
foreach ($file in $pageFiles) {
    $pages[(Get-WikiKey $file.Name)] = $file.Name
}

$broken = [System.Collections.Generic.List[object]]::new()
$backlinks = @{}
$markdownLinkCount = 0
$legacyWikiLinkCount = 0
$imageLinkCount = 0

function Register-WikiTarget {
    param(
        [string]$Kind,
        [System.IO.FileInfo]$SourceFile,
        [string]$Target,
        [string]$Raw
    )

    $cleanTarget = ($Target -split '[?#]', 2)[0].Trim()
    if ([string]::IsNullOrWhiteSpace($cleanTarget)) {
        return
    }

    try {
        $cleanTarget = [uri]::UnescapeDataString($cleanTarget)
    } catch {
        # Retain the original target when URI decoding is not applicable.
    }

    $cleanTarget = $cleanTarget -replace '^\./', ''
    $extension = [IO.Path]::GetExtension($cleanTarget)
    $isWikiPage = [string]::IsNullOrWhiteSpace($extension) -or $extension -ieq '.md'

    if ($isWikiPage) {
        $key = Get-WikiKey $cleanTarget
        if (-not $pages.ContainsKey($key)) {
            $broken.Add([pscustomobject]@{
                Kind   = $Kind
                Source = $SourceFile.Name
                Target = $cleanTarget
                Raw    = $Raw
            })
            return
        }

        if (-not $backlinks.ContainsKey($key)) {
            $backlinks[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $backlinks[$key].Add($SourceFile.Name)
        return
    }

    $resolved = Resolve-LocalTarget $SourceFile.DirectoryName $cleanTarget
    if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
        $broken.Add([pscustomobject]@{
            Kind   = 'File'
            Source = $SourceFile.Name
            Target = $cleanTarget
            Raw    = $Raw
        })
    }
}

foreach ($file in $pageFiles) {
    $text = Remove-MarkdownCode (Get-Content -Raw -LiteralPath $file.FullName)

    foreach ($match in [regex]::Matches($text, '\[\[([^\]]+)\]\]')) {
        $legacyWikiLinkCount++
        $inner = $match.Groups[1].Value
        $parts = $inner -split '\|', 2
        $target = if ($parts.Count -eq 2) { $parts[1] } else { $parts[0] }
        Register-WikiTarget 'LegacyWiki' $file $target $match.Value
    }

    foreach ($match in [regex]::Matches($text, '(?<!!)\[[^\]]*\]\((?<target>[^)\r\n]+)\)')) {
        $target = Get-MarkdownTarget $match.Groups['target'].Value
        if ($target -match '^(?:[a-z][a-z0-9+.-]*:|//|#)') {
            continue
        }
        $markdownLinkCount++
        Register-WikiTarget 'Markdown' $file $target $match.Value
    }

    foreach ($match in [regex]::Matches($text, '!\[[^\]]*\]\((?<target>[^)\r\n]+)\)')) {
        $target = Get-MarkdownTarget $match.Groups['target'].Value
        if ($target -match '^(?:https?:|data:|//)') {
            continue
        }

        $imageLinkCount++
        $cleanTarget = ($target -split '[?#]', 2)[0].Trim()
        try {
            $cleanTarget = [uri]::UnescapeDataString($cleanTarget)
        } catch {
            # Retain the original target when URI decoding is not applicable.
        }
        $resolved = Resolve-LocalTarget $file.DirectoryName $cleanTarget
        if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
            $broken.Add([pscustomobject]@{
                Kind   = 'Image'
                Source = $file.Name
                Target = $cleanTarget
                Raw    = $match.Value
            })
        }
    }
}

$withoutArt = $pageFiles |
    Where-Object {
        $_.Name -notin @('_Sidebar.md', '_Footer.md') -and
        $_.Name -notin $ArtExclusions -and
        (Remove-MarkdownCode (Get-Content -Raw -LiteralPath $_.FullName)) -notmatch '(!\[[^\]]*\]\(|<img\s)'
    } |
    Select-Object -ExpandProperty Name |
    Sort-Object

$orphanExclusions = @('_Sidebar.md', '_Footer.md', 'Home.md', 'Changelog.md') + $ArtExclusions
$orphans = $pageFiles |
    Where-Object {
        $_.Name -notin $orphanExclusions -and
        -not $backlinks.ContainsKey((Get-WikiKey $_.Name))
    } |
    Select-Object -ExpandProperty Name |
    Sort-Object

$result = [pscustomobject]@{
    WikiRoot             = $WikiRoot
    PageCount            = $pages.Count
    MarkdownLinkCount    = $markdownLinkCount
    LegacyWikiLinkCount  = $legacyWikiLinkCount
    ImageLinkCount       = $imageLinkCount
    BrokenCount          = $broken.Count
    BrokenLinks          = @($broken | Sort-Object Kind, Source, Target)
    PagesWithoutArt      = @($withoutArt)
    PagesWithoutArtCount = $withoutArt.Count
    OrphanPages          = @($orphans)
    OrphanPageCount      = $orphans.Count
}

$json = $result | ConvertTo-Json -Depth 6
if ($JsonOutputPath) {
    $resolvedOutput = if ([IO.Path]::IsPathRooted($JsonOutputPath)) {
        $JsonOutputPath
    } else {
        Join-Path (Get-Location) $JsonOutputPath
    }
    Set-Content -LiteralPath $resolvedOutput -Value $json -Encoding UTF8
}

$json
if ($FailOnIssues -and ($result.BrokenCount -gt 0 -or $result.PagesWithoutArtCount -gt 0)) {
    exit 1
}

param(
    [string]$WikiRoot = (Join-Path $PSScriptRoot '..\Demidius-Pathfinder-Codex.wiki'),
    [string]$JsonOutputPath,
    [string[]]$ArtExclusions = @(
        'Boons.md',
        'Campaign-Rules.md',
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

    return (($Value.Trim().ToLowerInvariant() -replace '[\s_-]+', '-') -replace '[’‘]', "'")
}

$pages = @{}
Get-ChildItem -LiteralPath $WikiRoot -File -Filter '*.md' | ForEach-Object {
    $pages[(Get-WikiKey $_.BaseName)] = $_.Name
}

$broken = [System.Collections.Generic.List[object]]::new()
$backlinks = @{}

foreach ($file in Get-ChildItem -LiteralPath $WikiRoot -File -Filter '*.md') {
    $text = Get-Content -Raw -LiteralPath $file.FullName

    foreach ($match in [regex]::Matches($text, '\[\[([^\]]+)\]\]')) {
        $inner = $match.Groups[1].Value
        $parts = $inner -split '\|', 2
        $target = if ($parts.Count -eq 2) { $parts[1] } else { $parts[0] }
        $target = ($target -split '#', 2)[0].Trim()
        if ([string]::IsNullOrWhiteSpace($target)) {
            continue
        }

        try {
            $target = [uri]::UnescapeDataString($target)
        } catch {
            # Retain the original target when URI decoding is not applicable.
        }

        $key = Get-WikiKey $target
        if (-not $pages.ContainsKey($key)) {
            $broken.Add([pscustomobject]@{
                Kind   = 'Wiki'
                Source = $file.Name
                Target = $target
                Raw    = $match.Value
            })
            continue
        }

        if (-not $backlinks.ContainsKey($key)) {
            $backlinks[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $backlinks[$key].Add($file.Name)
    }

    foreach ($match in [regex]::Matches($text, '!\[[^\]]*\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value.Trim()
        if ($target -match '^(https?:|data:)') {
            continue
        }

        $relative = $target -replace '/', [IO.Path]::DirectorySeparatorChar
        $resolved = Join-Path $WikiRoot $relative
        if (-not (Test-Path -LiteralPath $resolved)) {
            $broken.Add([pscustomobject]@{
                Kind   = 'Image'
                Source = $file.Name
                Target = $target
                Raw    = $match.Value
            })
        }
    }
}

$withoutArt = Get-ChildItem -LiteralPath $WikiRoot -File -Filter '*.md' |
    Where-Object {
        $_.Name -notin @('_Sidebar.md', '_Footer.md') -and
        $_.Name -notin $ArtExclusions -and
        (Get-Content -Raw -LiteralPath $_.FullName) -notmatch '(!\[[^\]]*\]\(|<img\s)'
    } |
    Select-Object -ExpandProperty Name |
    Sort-Object

$result = [pscustomobject]@{
    WikiRoot         = $WikiRoot
    PageCount        = $pages.Count
    BrokenCount      = $broken.Count
    BrokenLinks      = @($broken | Sort-Object Kind, Source, Target)
    PagesWithoutArt  = @($withoutArt)
    PagesWithoutArtCount = $withoutArt.Count
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

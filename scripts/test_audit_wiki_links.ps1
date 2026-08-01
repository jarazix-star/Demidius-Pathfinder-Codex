$ErrorActionPreference = 'Stop'

$auditScript = Join-Path $PSScriptRoot 'audit_wiki_links.ps1'
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ("demidius-wiki-audit-" + [guid]::NewGuid())

function Assert-Equal {
    param(
        [object]$Actual,
        [object]$Expected,
        [string]$Label
    )

    if ($Actual -ne $Expected) {
        throw "$Label expected '$Expected' but received '$Actual'."
    }
}

try {
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
    @'
# Home

<img src="cover.png">

[Valid page](Page-One)
[Broken page](Missing-Page)
![Broken image](missing.png)

`[[Inline-Code-False-Positive]]`

```text
[[Fenced-Code-False-Positive]]
[Also ignored](Missing-In-Code)
```
'@ | Set-Content -LiteralPath (Join-Path $fixtureRoot 'Home.md') -Encoding UTF8

    @'
# Page One

<img src="page-one.png">

[Home](Home#top)
'@ | Set-Content -LiteralPath (Join-Path $fixtureRoot 'Page-One.md') -Encoding UTF8

    @'
# Change Log

Metadata pages are intentionally exempt from the art requirement.
'@ | Set-Content -LiteralPath (Join-Path $fixtureRoot 'Changelog.md') -Encoding UTF8

    $result = (& $auditScript -WikiRoot $fixtureRoot) | ConvertFrom-Json

    Assert-Equal $result.PageCount 3 'Page count'
    Assert-Equal $result.MarkdownLinkCount 3 'Markdown link count'
    Assert-Equal $result.LegacyWikiLinkCount 0 'Legacy wiki link count'
    Assert-Equal $result.ImageLinkCount 1 'Image link count'
    Assert-Equal $result.BrokenCount 2 'Broken target count'
    Assert-Equal $result.PagesWithoutArtCount 0 'Art-gap count'
    Assert-Equal $result.OrphanPageCount 0 'Orphan-page count'

    $brokenKinds = @($result.BrokenLinks | Select-Object -ExpandProperty Kind | Sort-Object)
    Assert-Equal ($brokenKinds -join ',') 'Image,Markdown' 'Broken target kinds'

    Write-Output 'Wiki audit regression test passed.'
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}

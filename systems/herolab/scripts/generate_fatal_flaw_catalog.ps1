param(
    [string]$CatalogPath = (Join-Path $PSScriptRoot '..\..\..\Demidius-Pathfinder-Codex.wiki\Fatal-Flaw-Catalog.md'),
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\data\pathfinder\Codex_Fatal_Flaw_Catalog.user')
)

$CatalogPath = [System.IO.Path]::GetFullPath($CatalogPath)
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)

$rows = foreach ($line in [System.IO.File]::ReadAllLines($CatalogPath, [System.Text.Encoding]::UTF8)) {
    if ($line -match '^\|\s*(\d+)\s*\|\s*([^|]+?)\s*\|\s*(.*?)\s*\|$') {
        $number = [int]$matches[1]
        if ($number -le 100) {
            [pscustomobject]@{
                Number = $number
                Name = $matches[2].Trim()
                Effect = $matches[3].Trim()
            }
        }
    }
}

if ($rows.Count -ne 100 -or $rows[0].Number -ne 1 -or $rows[-1].Number -ne 100) {
    throw "Expected the canonical 100-entry Fatal Flaw table; found $($rows.Count) rows."
}

# Campaign-specific choices live outside the authoritative workbook table.
# Keeping them in this generator ensures that regeneration does not discard
# choices already used by live portfolios.
$rows = @($rows) + @(
    [pscustomobject]@{
        Number = 101
        Name = 'Paranoia'
        Effect = 'On a failed Fatal Flaw save, must act on paranoid impulses, such as spying on people or taking excessive precautions.'
    }
    [pscustomobject]@{
        Number = 102
        Name = 'Misjudging Intentions'
        Effect = '-20 to Sense Motive checks when the subject is a woman.'
    }
)

$settings = [System.Xml.XmlWriterSettings]::new()
$settings.Encoding = [System.Text.UTF8Encoding]::new($false)
$settings.Indent = $true
$settings.IndentChars = '  '
$settings.NewLineChars = "`r`n"
$settings.NewLineHandling = [System.Xml.NewLineHandling]::Replace

$writer = [System.Xml.XmlWriter]::Create($OutputPath, $settings)
try {
    $writer.WriteStartDocument()
    $writer.WriteStartElement('document')
    $writer.WriteAttributeString('signature', 'Hero Lab Data')

    $writer.WriteStartElement('fileinfo')
    $writer.WriteElementString('info_author', 'Demidius Pathfinder Codex')
    $writer.WriteElementString('info_history', '2026-08-03 - Generated the 100 canonical Fatal Flaw choices, added campaign-specific Paranoia and Misjudging Intentions, and retained six persistent selection slots.')
    $writer.WriteEndElement()

    foreach ($row in $rows) {
        $writer.WriteStartElement('thing')
        $writer.WriteAttributeString('id', ('xCFF{0:000}' -f $row.Number))
        $writer.WriteAttributeString('name', ('{0}. {1}' -f $row.Number, $row.Name))
        $writer.WriteAttributeString('description', $row.Effect)
        $writer.WriteAttributeString('compset', 'Ability')
        $writer.WriteAttributeString('uniqueness', 'unique')

        $writer.WriteStartElement('tag')
        $writer.WriteAttributeString('group', 'Custom')
        $writer.WriteAttributeString('tag', 'CdxFatal')
        $writer.WriteEndElement()
        $writer.WriteStartElement('tag')
        $writer.WriteAttributeString('group', 'Helper')
        $writer.WriteAttributeString('tag', 'Helper')
        $writer.WriteEndElement()
        $writer.WriteEndElement()
    }

    foreach ($slot in 1..6) {
        $writer.WriteStartElement('thing')
        $writer.WriteAttributeString('id', ('xCdxFlw{0}' -f $slot))
        $writer.WriteAttributeString('name', ('Fatal Flaw Slot {0}' -f $slot))
        $writer.WriteAttributeString('description', 'Choose one Fatal Flaw from the canonical campaign catalog.')
        $writer.WriteAttributeString('compset', 'Ability')
        $writer.WriteAttributeString('uniqueness', 'unique')
        $writer.WriteStartElement('fieldval')
        $writer.WriteAttributeString('field', 'usrCandid1')
        $writer.WriteAttributeString('value', 'Custom.CdxFatal')
        $writer.WriteEndElement()
        $writer.WriteStartElement('fieldval')
        $writer.WriteAttributeString('field', 'abValue')
        $writer.WriteAttributeString('value', [string]$slot)
        $writer.WriteEndElement()
        $writer.WriteStartElement('tag')
        $writer.WriteAttributeString('group', 'Helper')
        $writer.WriteAttributeString('tag', 'ShowSpec')
        $writer.WriteEndElement()
        $writer.WriteStartElement('eval')
        $writer.WriteAttributeString('phase', 'Render')
        $writer.WriteAttributeString('priority', '50000')
        $evalScript = @(
            '      if (field[usrChosen1].ischosen = 0) then'
            '        perform delete[Helper.ShowSpec]'
            '      else'
            ('        field[sbName].text = "Godling Fatal Flaw|Slot={0}|Name=" & field[usrChosen1].chosen.field[name].text & "|DC=" & hero.child[xCdxGodCfg].field[abValue].value' -f $slot)
            '        endif'
            '    '
        ) -join "`r`n"
        $writer.WriteCData($evalScript)
        $writer.WriteEndElement()
        $writer.WriteEndElement()
    }

    $writer.WriteEndElement()
    $writer.WriteEndDocument()
}
finally {
    $writer.Dispose()
}

Write-Output "Generated $($rows.Count) Fatal Flaws and 6 slots at $OutputPath"

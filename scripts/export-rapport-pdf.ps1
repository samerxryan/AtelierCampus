$ErrorActionPreference='Stop'
$word=New-Object -ComObject Word.Application
$word.Visible=$false
$doc=$word.Documents.Open((Resolve-Path 'rapport\Rapport_Partie_2_AtelierCampus.docx').Path,$false,$true)
$output=Join-Path (Resolve-Path rapport).Path 'Rapport_Partie_2_AtelierCampus.pdf'
$doc.ExportAsFixedFormat($output,17)
$doc.Close($false)
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc)|Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)|Out-Null
Write-Output $output

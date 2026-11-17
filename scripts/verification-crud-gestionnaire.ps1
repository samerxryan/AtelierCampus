$ErrorActionPreference = 'Stop'
$base = 'http://localhost:8080/AtelierCampus'
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
function Get-Page($path) { Invoke-WebRequest -Uri ($base + $path) -WebSession $session -UseBasicParsing }
function Get-Token($html) {
    if ($html -match 'name="csrf" value="([^"]+)"') { return $Matches[1] }
    throw 'Jeton CSRF absent.'
}
$login = Get-Page '/connexion'
$null = Invoke-WebRequest -Uri ($base + '/connexion') -Method Post -Body @{
    csrf = (Get-Token $login.Content)
    email = 'gestionnaire@ateliercampus.local'
    mot_de_passe = 'Gestionnaire2026!'
} -WebSession $session -UseBasicParsing
$existing = Get-Page '/gestion/ateliers'
foreach ($block in [regex]::Matches($existing.Content, '(?s)<article[^>]*>.*?</article>')) {
    $idMatch = [regex]::Match($block.Value, '/gestion/modifier\?id=(\d+)')
    $csrfMatch = [regex]::Match($block.Value, 'name="csrf" value="([^"]+)"')
    if ($block.Value -match 'Audit CRUD [a-f0-9]{8} modifié' -and $idMatch.Success -and $csrfMatch.Success) {
        $null = Invoke-WebRequest -Uri ($base + '/gestion/supprimer') -Method Post -Body @{ csrf=$csrfMatch.Groups[1].Value; id=$idMatch.Groups[1].Value } -WebSession $session -UseBasicParsing
    }
}
$new = Get-Page '/gestion/nouveau'
$token = Get-Token $new.Content
$title = 'Audit CRUD ' + [guid]::NewGuid().ToString('N').Substring(0, 8)
$body = @{ csrf=$token; titre=$title; description='Atelier temporaire pour audit CRUD.'; dateHeure=(Get-Date).AddDays(45).ToString('yyyy-MM-ddTHH:mm'); capacite='2' }
$null = Invoke-WebRequest -Uri ($base + '/gestion/enregistrer') -Method Post -Body $body -WebSession $session -UseBasicParsing
$list = Get-Page '/gestion/ateliers'
if ($list.Content -notmatch [regex]::Escape($title)) { throw 'Création non visible dans la liste.' }
$escapedTitle = [regex]::Escape($title)
$match = [regex]::Match($list.Content, '(?s)<article[^>]*>.*?' + $escapedTitle + '.*?href="[^"]*/gestion/modifier\?id=(\d+)"')
if (!$match.Success) { throw "Identifiant de l’atelier créé absent." }
$id = $match.Groups[1].Value
$edit = Get-Page ("/gestion/modifier?id=" + $id)
$updatedTitle = $title + ' modifié'
$body = @{ csrf=(Get-Token $edit.Content); id=$id; titre=$updatedTitle; description='Description mise à jour par le test CRUD.'; dateHeure=(Get-Date).AddDays(50).ToString('yyyy-MM-ddTHH:mm'); capacite='3' }
$null = Invoke-WebRequest -Uri ($base + '/gestion/enregistrer') -Method Post -Body $body -WebSession $session -UseBasicParsing
$list = Get-Page '/gestion/ateliers'
if ($list.Content -notmatch [regex]::Escape($updatedTitle) -or $list.Content -match ('<h2>' + [regex]::Escape($title) + '</h2>')) { throw 'Modification non persistée.' }
$token = Get-Token $list.Content
$null = Invoke-WebRequest -Uri ($base + '/gestion/supprimer') -Method Post -Body @{csrf=$token;id=$id} -WebSession $session -UseBasicParsing
$list = Get-Page '/gestion/ateliers'
if ($list.Content -match [regex]::Escape($updatedTitle)) { throw 'Suppression non persistée.' }
Write-Output "RÉUSSI : CRUD gestionnaire par HTTP réel; atelier temporaire $id créé, modifié puis supprimé."

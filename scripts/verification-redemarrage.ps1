$ErrorActionPreference = 'Stop'
$tomcat = 'C:\Users\samer\AppData\Local\Temp\AtelierCampus-Verification\apache-tomcat-10.1.61'
$env:CATALINA_HOME=$tomcat
$env:CATALINA_BASE=$tomcat
& "$tomcat\bin\catalina.bat" stop
Start-Sleep -Seconds 3
$stopped=$false
for($i=0;$i -lt 10;$i++){try{$null=Invoke-WebRequest 'http://localhost:8080/AtelierCampus/catalogue' -UseBasicParsing;Start-Sleep -Seconds 1}catch{$stopped=$true;break}}
if(!$stopped){throw "Le serveur Tomcat ne s'est pas arrêté."}
Start-Process -FilePath "$tomcat\bin\catalina.bat" -ArgumentList 'run' -WindowStyle Hidden | Out-Null
$ready = $false
for ($i=0; $i -lt 20; $i++) {
    Start-Sleep -Seconds 2
    try { $r=Invoke-WebRequest 'http://localhost:8080/AtelierCampus/catalogue' -UseBasicParsing; if($r.StatusCode -eq 200){$ready=$true;break} } catch {}
}
if (!$ready) { throw "Tomcat ne s'est pas relancé." }
$session=New-Object Microsoft.PowerShell.Commands.WebRequestSession
$login=Invoke-WebRequest 'http://localhost:8080/AtelierCampus/connexion' -WebSession $session -UseBasicParsing
$csrf=[regex]::Match($login.Content,'name="csrf" value="([^"]+)"').Groups[1].Value
$null=Invoke-WebRequest 'http://localhost:8080/AtelierCampus/connexion' -Method Post -Body @{csrf=$csrf;email='sami@gmail.com';mot_de_passe='Etudiant2026!'} -WebSession $session -UseBasicParsing
$list=Invoke-WebRequest 'http://localhost:8080/AtelierCampus/mes-inscriptions' -WebSession $session -UseBasicParsing
if($list.Content -notmatch 'Analyse Forensique' -or $list.Content -notmatch 'ANNULEE'){throw 'Inscription absente après redémarrage.'}
Write-Output 'RÉUSSI : Tomcat relancé; inscription et statut ANNULEE retrouvés dans la base fichier.'

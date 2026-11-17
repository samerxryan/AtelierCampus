$ErrorActionPreference = 'Stop'
$base = 'http://localhost:8080/AtelierCampus'
function Page($path,$session) { Invoke-WebRequest -Uri ($base+$path) -WebSession $session -UseBasicParsing }
function Token($html) { if($html -match 'name="csrf" value="([^"]+)"'){return $Matches[1]} throw 'Jeton CSRF absent' }
function Login($email,$password) {
  $s=New-Object Microsoft.PowerShell.Commands.WebRequestSession
  $p=Page '/connexion' $s; $t=Token $p.Content
  $null=Invoke-WebRequest -Uri ($base+'/connexion') -Method Post -Body @{csrf=$t;email=$email;mot_de_passe=$password} -WebSession $s -UseBasicParsing
  $protected=if($email -match 'gestionnaire'){'/gestion/ateliers'}else{'/mes-inscriptions'}
  $expected=if($email -match 'gestionnaire'){'Gestion des ateliers'}else{'Mes inscriptions'}
  if((Page $protected $s).Content -notmatch $expected) { throw "Connexion échouée pour $email" }
  return $s
}
function ExpectStatus($path,$session,$body,$expected) {
  try { $null=Invoke-WebRequest -Uri ($base+$path) -Method Post -Body $body -WebSession $session -UseBasicParsing; throw "POST inattendu accepté ($path)" }
  catch { if($_.Exception.Message -match 'inattendu accepté'){throw}; if($_.Exception.Message -notmatch $expected){throw} }
}
$s=New-Object Microsoft.PowerShell.Commands.WebRequestSession
$p=Page '/catalogue' $s
if($p.StatusCode -ne 200 -or $p.Content -notmatch 'Catalogue des ateliers'){throw 'Catalogue public invalide'}
$search=Page '/catalogue?q=Forensique' $s
if($search.Content -notmatch 'Analyse Forensique' -or $search.Content -match 'Cryptographie Appliquée'){throw 'Recherche invalide'}
$sql=Page '/catalogue?q=%27%20OR%201%3D1--' $s
if($sql.StatusCode -ne 200 -or $sql.Content -match 'Cryptographie Appliquée'){throw 'Recherche paramétrée invalide'}
$xss=Page '/catalogue?q=%3Cscript%3Ealert%281%29%3C%2Fscript%3E' $s
if($xss.Content -match '<script>alert\(1\)</script>'){throw 'XSS non échappé'}
$anon=Page '/mes-inscriptions' $s
if($anon.Content -notmatch '<h1>Connexion</h1>'){throw 'Accès anonyme non redirigé'}
$loginPage=Page '/connexion' $s; $token=Token $loginPage.Content
ExpectStatus '/connexion' $s @{email='x';mot_de_passe='x'} '403'
ExpectStatus '/connexion' $s @{csrf='jeton-invalide';email='x';mot_de_passe='x'} '403'
$badLogin=Invoke-WebRequest -Uri ($base+'/connexion') -Method Post -Body @{csrf=$token;email='absent@example.com';mot_de_passe='incorrect'} -WebSession $s -UseBasicParsing
if($badLogin.Content -notmatch 'invalide'){throw 'Échec de connexion non signalé'}
$student=Login 'sami@gmail.com' 'Etudiant2026!'
$d=Page '/atelier?id=2' $student
$csrf=Token $d.Content
$null=Invoke-WebRequest -Uri ($base+'/inscription/action') -Method Post -Body @{csrf=$csrf;atelierId='2'} -WebSession $student -UseBasicParsing
$list=Page '/mes-inscriptions' $student
if($list.Content -notmatch 'Analyse Forensique'){throw 'Inscription/réactivation non visible'}
$id=[regex]::Match($list.Content,'name="id" value="(\d+)"').Groups[1].Value
if(!$id){throw 'Identifiant inscription absent'}
$csrf=Token $list.Content
ExpectStatus '/inscription/action' $student @{csrf=$csrf;action='annuler';id='1'} '400'
try{$null=Page '/inscription/action?atelierId=2' $student;throw 'GET de modification accepté'}catch{if($_.Exception.Message -match 'GET de modification accepté'){throw}; if($_.Exception.Message -notmatch '404|405'){throw}}
$null=Invoke-WebRequest -Uri ($base+'/inscription/action') -Method Post -Body @{csrf=$csrf;action='annuler';id=$id} -WebSession $student -UseBasicParsing
$list2=Page '/mes-inscriptions' $student
if($list2.Content -notmatch 'ANNULEE'){throw 'Annulation non visible'}
$manager=Login 'gestionnaire@ateliercampus.local' 'Gestionnaire2026!'
$dash=Page '/gestion/ateliers' $manager
if($dash.Content -notmatch 'Gestion des ateliers'){throw 'Connexion gestionnaire invalide'}
$denied=$false
try{$null=Page '/gestion/ateliers' $student}catch{if($_.Exception.Message -match '403'){$denied=$true}else{throw}}
if(!$denied){throw 'Un étudiant accède au gestionnaire'}
Write-Output 'RÉUSSI : catalogue, recherche paramétrée, XSS, accès anonyme, connexion invalide, CSRF absent/invalide, inscription, annulation, propriété étudiant, GET sans mutation, rôles.'

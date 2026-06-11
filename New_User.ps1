<#
.SYNOPSIS
    création de l'environnement utilisateur

.DESCRIPTION
    Le script parcourt les dossiers présents puis crée le dossier utilisateur s'il n'existe pas
    il crée les sous-dossiers, copie les templates présents dans le répertoire source
    et génère un texte de bienvenue

.PARAMETER nom
    nom de l'utilisateur (pas d'espace ou de charactères spéciaux)

.PARAMETER prenom
    prénom de l'utilisateur (pas d'espace ou de charactères spéciaux)

.PARAMETER dest
    dossier cible dans lequel sera créé le dossier utilisateur

.PARAMETER source
    dossier contenant les templates de base de l'entreprise

.EXAMPLE
    .\New_User.ps1 -nom "Chavagnat" -prenom "Adrien" -source "C:\Templates" -dest "C:\Users\Compta"

.OUTPUTS
    Fichier de log dans le dossier utilisateur créé

.AUTHOR
    Chavagnat Adrien

.CREATED
    15.05.2026
#>

param (
    [Parameter(Mandatory)] [String]$nom,
    [Parameter(Mandatory)] [String]$prenom,
    [Parameter(Mandatory)] [String]$dest,
    [Parameter(Mandatory)] [string]$source
)

$date    = Get-Date -Format "dd.MM.yyyy"
$dir     = "$dest\${nom}_${prenom}"
$logfile = New-Item -ItemType File -Path "C:\" -Name "${date}_${nom}.txt"

try {
    if (-not (Test-Path "$dest\${nom}_${prenom}")) {
        New-Item -ItemType Directory -Path $dir
        Write-Host "création dossier parent"
    }
} catch {
    #Write-Host "erreur création dossier parent"
    $_ >> $logfile
}

$newLogFile = Copy-Item $logfile -Destination $dir -PassThru
Remove-Item $logfile

try {
    New-Item -ItemType Directory -Path $dir -Name "Documents"
    #Write-Host "création dossier Documents"
    "création dossier Documents" >> $newLogFile
    New-Item -ItemType Directory -Path $dir -Name "Projets"
    #Write-Host "création dossier Projets"
    "création dossier Projets" >> $newLogFile
    New-Item -ItemType Directory -Path $dir -Name "Archives"
    #Write-Host "création dossier Archives"
    "création dossier Archives" >> $newLogFile
} catch {
    #Write-Host "erreur création sous-dossiers"
    $_ >> $newLogFile
}

try {
    foreach ($fichier in (Get-ChildItem -Path $source)) {
        Copy-Item $fichier.FullName -Destination "$dir\Documents"
        #Write-Host "copie $($fichier.Name)"
        "copie $($fichier.Name)" >> $newLogFile
    }
} catch {
    #Write-Host "erreur copie fichiers"
    $_ >> $newLogFile
}

$bienvenue = "$dir\Bienvenue.txt"
"Bonjour $prenom $nom,">> $bienvenue 
"">> $bienvenue 
"Bienvenue dans l'entreprise.">> $bienvenue 
"">> $bienvenue 
"Ce dossier a été créé automatiquement le $date.">> $bienvenue 

Write-Host "Script terminé. $dir créé"
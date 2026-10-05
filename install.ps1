# ==============================================================================
#  Xmonify CLI - One-Line Windows Installer
#  Developer & Maintainer: XMON4U
#  GitHub: https://github.com/Xmon4u/Xmonify
# ==============================================================================

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#region Banner
Write-Host ''
Write-Host '  ================================================================' -ForegroundColor Cyan
Write-Host '                     __  __             _  __                     ' -ForegroundColor Green
Write-Host '                     \ \/ /_ __  ___   (_)/ _| _   _              ' -ForegroundColor Green
Write-Host '                      \  /| ''_ ` _ \ / _ \| | |_ | | | |             ' -ForegroundColor Green
Write-Host '                      /  \| | | | | | (_) | |  _|| |_| |             ' -ForegroundColor Green
Write-Host '                     /_/\_\_| |_| |_|\___/|_|_|   \__, |             ' -ForegroundColor Green
Write-Host '                                                  |___/              ' -ForegroundColor Green
Write-Host '                 Spotify Customizer Command-Line Tool             ' -ForegroundColor Yellow
Write-Host '                        Developed by XMON4U                       ' -ForegroundColor White
Write-Host '  ================================================================' -ForegroundColor Cyan
Write-Host ''
#endregion Banner

#region Variables
$xmonifyFolder = "$env:LOCALAPPDATA\xmonify"
$spicetifyFolder = "$env:LOCALAPPDATA\spicetify"
$repoOwner = 'Xmon4u'
$repoName = 'Xmonify'
$releaseUrl = "https://github.com/$repoOwner/$repoName/releases/latest/download"
$archiveUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/main.zip"
#endregion Variables

#region Helper Functions
function Write-Step {
    param ([string]$Message)
    Write-Host " [*] $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param ([string]$Message)
    Write-Host " [OK] $Message" -ForegroundColor Green
}

function Write-Fail {
    param ([string]$Message)
    Write-Host " [ERROR] $Message" -ForegroundColor Red
}

function Test-AdminPrivileges {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
#endregion Helper Functions

#region Pre-checks
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Fail 'PowerShell 5.1 or higher is required.'
    exit 1
}

if (Test-AdminPrivileges) {
    Write-Host ' [!] Warning: Running as Administrator is not recommended for Spotify user styling.' -ForegroundColor Yellow
}
#endregion Pre-checks

#region Installation
Write-Step 'Setting up Xmonify installation directories...'
if (-not (Test-Path -Path $xmonifyFolder)) {
    New-Item -ItemType Directory -Path $xmonifyFolder -Force | Out-Null
}
if (-not (Test-Path -Path $spicetifyFolder)) {
    New-Item -ItemType Directory -Path $spicetifyFolder -Force | Out-Null
}

$xmonifyExe = Join-Path -Path $xmonifyFolder -ChildPath 'xmonify.exe'
$spicetifyExe = Join-Path -Path $xmonifyFolder -ChildPath 'spicetify.exe'
$installed = $false

# 1. Check if running from local repository
$currentScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue
if ($currentScriptDir -and (Test-Path (Join-Path $currentScriptDir 'spicetify.go'))) {
    Write-Step "Installing from local source directory ($currentScriptDir)..."
    Copy-Item -Path "$currentScriptDir\Themes" -Destination $xmonifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\Extensions" -Destination $xmonifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\CustomApps" -Destination $xmonifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\jsHelper" -Destination $xmonifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\css-map.json" -Destination $xmonifyFolder -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\globals.d.ts" -Destination $xmonifyFolder -Force -ErrorAction SilentlyContinue
    
    # Also sync to spicetify folder for seamless Spotify client integration
    Copy-Item -Path "$currentScriptDir\Themes" -Destination $spicetifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\Extensions" -Destination $spicetifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\CustomApps" -Destination $spicetifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\jsHelper" -Destination $spicetifyFolder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\css-map.json" -Destination $spicetifyFolder -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$currentScriptDir\globals.d.ts" -Destination $spicetifyFolder -Force -ErrorAction SilentlyContinue
    
    if (Test-Path "$currentScriptDir\xmonify.exe") {
        Copy-Item -Path "$currentScriptDir\xmonify.exe" -Destination $xmonifyExe -Force
        Copy-Item -Path "$currentScriptDir\xmonify.exe" -Destination $spicetifyExe -Force
        $installed = $true
    }
}

# 2. If not installed from local, download from GitHub release or repository archive
if (-not $installed) {
    $tempZip = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'xmonify.zip'
    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } elseif ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') { 'x64' } else { 'x32' }
    $binaryZipUrl = "$releaseUrl/xmonify-2.45.3-windows-$arch.zip"
    
    $downloadSuccess = $false
    try {
        Write-Step 'Downloading Xmonify release binary...'
        Invoke-WebRequest -Uri $binaryZipUrl -OutFile $tempZip -UseBasicParsing -TimeoutSec 30
        $downloadSuccess = $true
    }
    catch {
        Write-Host ' [i] Pre-compiled release not yet available. Downloading repository assets...' -ForegroundColor Yellow
        try {
            Invoke-WebRequest -Uri $archiveUrl -OutFile $tempZip -UseBasicParsing -TimeoutSec 45
            $downloadSuccess = $true
        } catch {
            Write-Fail 'Could not download Xmonify assets from GitHub.'
        }
    }

    if ($downloadSuccess -and (Test-Path $tempZip)) {
        Write-Step 'Extracting Xmonify packages...'
        $extractDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'xmonify_extract'
        if (Test-Path $extractDir) { Remove-Item -Path $extractDir -Recurse -Force }
        Expand-Archive -Path $tempZip -DestinationPath $extractDir -Force
        
        # Check if archive was branch zip (contains Xmonify-main subfolder)
        $subFolder = Join-Path -Path $extractDir -ChildPath "$repoName-main"
        $sourcePath = if (Test-Path $subFolder) { $subFolder } else { $extractDir }

        Copy-Item -Path "$sourcePath\*" -Destination $xmonifyFolder -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item -Path "$sourcePath\*" -Destination $spicetifyFolder -Recurse -Force -ErrorAction SilentlyContinue

        # Clean up temp
        Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $extractDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. Ensure xmonify.exe exists
if (-not (Test-Path $xmonifyExe)) {
    # Check if an existing binary is present in spicetify folder
    $existing = Join-Path -Path $spicetifyFolder -ChildPath 'spicetify.exe'
    if (Test-Path $existing) {
        Copy-Item -Path $existing -Destination $xmonifyExe -Force
        Copy-Item -Path $existing -Destination $spicetifyExe -Force
    }
}

# 4. Add Xmonify to user environment PATH
Write-Step 'Configuring System PATH...'
$userTarget = [EnvironmentVariableTarget]::User
$currentPath = [Environment]::GetEnvironmentVariable('PATH', $userTarget)
if ($currentPath -notlike "*$xmonifyFolder*") {
    $newPath = "$currentPath;$xmonifyFolder"
    [Environment]::SetEnvironmentVariable('PATH', $newPath, $userTarget)
}
if (($env:PATH -split ';') -notcontains $xmonifyFolder) {
    $env:PATH = "$env:PATH;$xmonifyFolder"
}

Write-Ok 'Xmonify CLI is installed and configured in PATH.'
#endregion Installation

#region Automatically Apply to Spotify
Write-Step 'Applying customizations to Spotify client...'
try {
    if (Test-Path $xmonifyExe) {
        & $xmonifyExe backup apply
    } elseif (Test-Path $spicetifyExe) {
        & $spicetifyExe backup apply
    }
    Write-Ok 'Customizations applied successfully!'
}
catch {
    Write-Host ' [i] Note: Open Spotify or run ''xmonify backup apply'' anytime to re-apply.' -ForegroundColor Yellow
}
#endregion Automatically Apply to Spotify

#region Final Summary
Write-Host ''
Write-Host '  ================================================================' -ForegroundColor Green
Write-Host '   [OK] Xmonify Installation & Setup Completed Successfully!' -ForegroundColor Green
Write-Host '   [OK] Developer / Author: XMON4U' -ForegroundColor White
Write-Host '   [OK] Project Repository: https://github.com/Xmon4u/Xmonify' -ForegroundColor Cyan
Write-Host ''
Write-Host '   Usage:' -ForegroundColor Yellow
Write-Host '     xmonify -h            # Display help and commands' -ForegroundColor White
Write-Host '     xmonify backup apply  # Apply latest themes & extensions' -ForegroundColor White
Write-Host '     xmonify refresh       # Hot-reload modifications' -ForegroundColor White
Write-Host '     xmonify restore       # Restore Spotify to original state' -ForegroundColor White
Write-Host '  ================================================================' -ForegroundColor Green
Write-Host ''
#endregion Final Summary

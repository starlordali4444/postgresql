$env:PGCLIENTENCODING = "UTF8"   # ensure psql uses UTF-8 (loads RetailMart data without errors)
# ---------------------------------------------------------------
# Complete Dev Environment Installer for Windows (PowerShell)
# Installs: PostgreSQL, pgAdmin 4, VS Code, Git
# Creates:  postgres superuser + accio practice DB
# Author:   Sayyed Siraj Ali
#
# USAGE (run in an ELEVATED PowerShell window):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\install_windows.ps1
#
# Optional overrides (set BEFORE running):
#   $env:PG_USER     = "postgres"
#   $env:PG_PASSWORD = "postgres"
#   $env:BATCH       = "26"
# ---------------------------------------------------------------

$ErrorActionPreference = "Stop"

# -- Defaults - override via env vars ----------------------------
$PG_USER     = if ($env:PG_USER)     { $env:PG_USER }     else { "postgres" }
$PG_PASSWORD = if ($env:PG_PASSWORD) { $env:PG_PASSWORD } else { "postgres" }
$BATCH       = if ($env:BATCH)       { $env:BATCH }       else { "26" }
$PRACTICE_DB = "accio_$BATCH"

Write-Host ""
Write-Host "AccioJob SQL - Windows Setup Installer" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  User:        $PG_USER"
Write-Host "  Password:    $PG_PASSWORD"
Write-Host "  Practice DB: $PRACTICE_DB"
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# -- Step 0: Elevation check -------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERROR] This script must be run as Administrator." -ForegroundColor Red
    Write-Host "  Right-click PowerShell -> 'Run as Administrator', then re-run this script."
    exit 1
}

# -- Step 1: winget (Windows Package Manager) --------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] winget not found." -ForegroundColor Red
    Write-Host "  Install 'App Installer' from the Microsoft Store, then re-run."
    Write-Host "  (winget ships pre-installed on Windows 11; on Windows 10, update via Microsoft Store.)"
    exit 1
}
Write-Host "[OK]   winget is available." -ForegroundColor Green

# Helper: install a winget package if not already installed
function Install-IfMissing {
    param(
        [string]$Id,
        [string]$DisplayName,
        [string]$VersionCheckCmd = $null
    )

    if ($VersionCheckCmd -and (Get-Command $VersionCheckCmd -ErrorAction SilentlyContinue)) {
        Write-Host "[OK]   $DisplayName already on PATH." -ForegroundColor Green
        return
    }

    $listed = winget list --id $Id --exact 2>$null | Select-String $Id
    if ($listed) {
        Write-Host "[OK]   $DisplayName already installed (winget)." -ForegroundColor Green
        return
    }

    Write-Host "[..]   Installing $DisplayName..." -ForegroundColor Yellow
    winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements
}

# -- Step 2: PostgreSQL ------------------------------------------
# PostgreSQL official installer also bundles pgAdmin 4 + Stack Builder.
# Setting POSTGRES_PASSWORD via environment honours the official EDB installer.
$env:POSTGRES_PASSWORD = $PG_PASSWORD

Install-IfMissing -Id "PostgreSQL.PostgreSQL.17" `
                  -DisplayName "PostgreSQL 17" `
                  -VersionCheckCmd "psql"

# Add PostgreSQL bin to PATH (current session + persisted)
$pgBinCandidates = @(
    "C:\Program Files\PostgreSQL\17\bin",
    "C:\Program Files\PostgreSQL\16\bin",
    "C:\Program Files\PostgreSQL\15\bin"
)
$pgBin = $pgBinCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($pgBin) {
    if ($env:Path -notlike "*$pgBin*") {
        Write-Host "[..]   Adding $pgBin to PATH..." -ForegroundColor Yellow
        $env:Path = "$env:Path;$pgBin"
        [Environment]::SetEnvironmentVariable("Path",
            [Environment]::GetEnvironmentVariable("Path", "Machine") + ";$pgBin",
            "Machine")
    }
    Write-Host "[OK]   PostgreSQL bin on PATH: $pgBin" -ForegroundColor Green
} else {
    Write-Host "[WARN] Could not auto-detect PostgreSQL bin directory." -ForegroundColor Yellow
    Write-Host "       Add C:\Program Files\PostgreSQL\<version>\bin to PATH manually."
}

# -- Step 3: Wait for PostgreSQL service to be up ----------------
Write-Host "[..]   Waiting for PostgreSQL service..." -ForegroundColor Yellow
$pgService = Get-Service -Name "postgresql-x64-*" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($pgService -and $pgService.Status -ne "Running") {
    Start-Service $pgService.Name
}

# Use the password we just set during install
$env:PGPASSWORD = $PG_PASSWORD
$pgReady = $false
for ($i = 1; $i -le 30; $i++) {
    try {
        & psql -h localhost -U $PG_USER -d postgres -c "SELECT 1" *> $null
        if ($LASTEXITCODE -eq 0) { $pgReady = $true; break }
    } catch {}
    Start-Sleep -Seconds 1
}

if (-not $pgReady) {
    Write-Host "[ERROR] PostgreSQL didn't accept connections in 30 seconds." -ForegroundColor Red
    Write-Host "        Check the service: Get-Service postgresql-x64-*"
    exit 1
}
Write-Host "[OK]   PostgreSQL is up." -ForegroundColor Green

# -- Step 4: Create user role + practice DB ----------------------
Write-Host ""
Write-Host "[..]   Setting up '$PG_USER' superuser and '$PRACTICE_DB' practice DB..." -ForegroundColor Yellow

# Ensure role exists (idempotent)
$ensureRoleSql = @"
DO `$`$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$PG_USER') THEN
    CREATE ROLE "$PG_USER" WITH LOGIN SUPERUSER PASSWORD '$PG_PASSWORD';
  ELSE
    ALTER ROLE "$PG_USER" WITH LOGIN SUPERUSER PASSWORD '$PG_PASSWORD';
  END IF;
END
`$`$;
"@

$tempSql = [System.IO.Path]::GetTempFileName() + ".sql"
$ensureRoleSql | Out-File -FilePath $tempSql -Encoding ASCII
& psql -h localhost -U $PG_USER -d postgres -f $tempSql
Remove-Item $tempSql -ErrorAction SilentlyContinue
Write-Host "  [OK] Role '$PG_USER' ready (password set)." -ForegroundColor Green

# Create practice DB if missing
$dbExists = (& psql -h localhost -U $PG_USER -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$PRACTICE_DB'") -replace '\s', ''
if ($dbExists -ne "1") {
    & psql -h localhost -U $PG_USER -d postgres -c "CREATE DATABASE `"$PRACTICE_DB`" OWNER `"$PG_USER`";"
    Write-Host "  [OK] Database '$PRACTICE_DB' created." -ForegroundColor Green
} else {
    Write-Host "  [OK] Database '$PRACTICE_DB' already exists." -ForegroundColor Green
}

# -- Step 5: pgAdmin 4 -------------------------------------------
# pgAdmin 4 usually ships with the PostgreSQL installer above, but ensure it's there.
$pgAdminPath = "C:\Program Files\pgAdmin 4"
if (Test-Path $pgAdminPath) {
    Write-Host "[OK]   pgAdmin 4 already installed." -ForegroundColor Green
} else {
    Install-IfMissing -Id "PostgreSQL.pgAdmin" -DisplayName "pgAdmin 4"
}

# -- Step 6: VS Code ---------------------------------------------
Install-IfMissing -Id "Microsoft.VisualStudioCode" `
                  -DisplayName "Visual Studio Code" `
                  -VersionCheckCmd "code"

# -- Step 7: Git -------------------------------------------------
Install-IfMissing -Id "Git.Git" `
                  -DisplayName "Git" `
                  -VersionCheckCmd "git"

# Refresh current session PATH so subsequent commands see new binaries
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

# -- Summary -----------------------------------------------------
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Installation Complete! Here's your setup:" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

function Show-Version {
    param([string]$Label, [string]$Cmd, [string]$Args = "--version")
    if (Get-Command $Cmd -ErrorAction SilentlyContinue) {
        try {
            $v = & $Cmd $Args.Split(' ') 2>$null | Select-Object -First 1
            Write-Host ("  {0} : {1}" -f $Label, $v)
        } catch {
            Write-Host ("  {0} : installed (version check failed)" -f $Label)
        }
    } else {
        Write-Host ("  {0} : not on PATH (open a NEW terminal)" -f $Label) -ForegroundColor Yellow
    }
}

Show-Version "PostgreSQL" "psql"
Show-Version "VS Code"    "code"
Show-Version "Git"        "git"
if (Test-Path $pgAdminPath) {
    Write-Host "  pgAdmin 4  : Installed ($pgAdminPath)"
} else {
    Write-Host "  pgAdmin 4  : Check Start Menu" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Database Connection Details:" -ForegroundColor Cyan
Write-Host "   Host     : localhost"
Write-Host "   Port     : 5432"
Write-Host "   User     : $PG_USER"
Write-Host "   Password : $PG_PASSWORD"
Write-Host "   Database : $PRACTICE_DB"
Write-Host ""
Write-Host "   Test connection:  psql -h localhost -U $PG_USER -d $PRACTICE_DB"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Close this PowerShell and open a NEW one (so PATH updates take effect)"
Write-Host "   2. Open pgAdmin 4 -> Create Server -> use the credentials above"
Write-Host "   3. Open VS Code -> Install SQLTools + SQLTools PostgreSQL extensions"
Write-Host "   4. Import RetailMart: psql -U $PG_USER -d $PRACTICE_DB -f setup_accio_retailmart.sql"
Write-Host ""

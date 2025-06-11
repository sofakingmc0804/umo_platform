Write-Host "Running UMO environment check..."

# Refresh environment variables to pick up any recent PATH changes
Write-Host "Refreshing environment variables..." -ForegroundColor Cyan
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

$ErrorActionPreference = 'Stop'

function Show-InstallHint {
    param ([string]$cmd)
    
    switch ($cmd) {
        'flutter'  { Write-Host "Install Flutter SDK: https://docs.flutter.dev/get-started" -ForegroundColor Yellow }
        'dart'     { Write-Host "Dart comes with Flutter. Ensure flutter/bin is in your PATH." -ForegroundColor Yellow }
        'git'      { Write-Host "Install Git: https://git-scm.com/downloads" -ForegroundColor Yellow }
        'firebase' { Write-Host "Install Firebase CLI with: npm install -g firebase-tools" -ForegroundColor Yellow }
        'npm'      { Write-Host "Install Node.js which includes npm: https://nodejs.org/" -ForegroundColor Yellow }
        default    { Write-Host "Check installation steps for: $cmd" -ForegroundColor Yellow }
    }
}

function Assert-Command {
    param ([string]$cmd)
    
    # Try normal PATH lookup first
    $command = Get-Command $cmd -ErrorAction SilentlyContinue
    
    # If not found, try common installation paths for Flutter/Dart
    if (-not $command) {
        $searchPaths = @()
        
        if ($cmd -eq "flutter") {
            $searchPaths = @(
                "C:\flutter\bin\flutter.exe",
                "C:\flutter\bin\flutter.bat",
                "$env:USERPROFILE\flutter\bin\flutter.exe",
                "$env:USERPROFILE\flutter\bin\flutter.bat"
            )
        } elseif ($cmd -eq "dart") {
            $searchPaths = @(
                "C:\flutter\bin\dart.exe",
                "C:\flutter\bin\dart.bat",
                "$env:USERPROFILE\flutter\bin\dart.exe",
                "$env:USERPROFILE\flutter\bin\dart.bat"
            )
        }
        
        foreach ($path in $searchPaths) {
            if (Test-Path $path) {
                Write-Host "$cmd found at $path" -ForegroundColor Green
                return
            }
        }
    }
    
    if (-not $command) {
        Write-Host "$cmd not found in PATH." -ForegroundColor Red
        Show-InstallHint $cmd
        throw "$cmd is missing"
    } else {
        Write-Host "$cmd found" -ForegroundColor Green
    }
}

function Install-Command {
    param ([string]$cmd)
    
    switch ($cmd) {
        'flutter' {
            if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
                Write-Host "winget not found. Required to install Flutter automatically." -ForegroundColor Red
                Show-InstallHint 'flutter'
                throw "winget not available"
            }
            winget install --id Flutter.Flutter -e -h
        }
        'dart' {
            Write-Host "Dart comes with Flutter and should be available in the same directory." -ForegroundColor Yellow
            Write-Host "If Dart is missing, reinstall Flutter or check your Flutter installation." -ForegroundColor Yellow
            return
        }
        'git' {
            if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
                Write-Host "winget not found. Required to install Git automatically." -ForegroundColor Red
                Show-InstallHint 'git'
                throw "winget not available"
            }
            winget install --id Git.Git -e -h
        }
        'firebase' {
            npm install -g firebase-tools
        }
        'npm' {
            Write-Host "Node.js must be installed manually." -ForegroundColor Yellow
            Show-InstallHint 'npm'
            throw "npm not found"
        }
        default {
            Write-Host "Unknown command: $cmd" -ForegroundColor Yellow
        }
    }
}

function Ensure-Command {
    param ([string]$cmd)
    
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "Attempting to install $cmd..." -ForegroundColor Cyan
        Install-Command $cmd
    }
    Assert-Command $cmd
}

# Run environment checks
Ensure-Command flutter
Ensure-Command dart
Ensure-Command git
Ensure-Command npm
Ensure-Command firebase

Write-Host "All required tools found. Running flutter doctor..." -ForegroundColor Green

try {
    flutter doctor -v | Out-Host
} catch {
    Write-Host "flutter doctor returned errors. Please fix them before continuing." -ForegroundColor Yellow
    exit 1
}

Write-Host "Environment check passed. You are ready to start developing!" -ForegroundColor Green

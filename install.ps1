param([switch]$Uninstall)
$userProfile = $env:USERPROFILE
$askPy = "$userProfile\ask.py"
$askBat = "$userProfile\ask.bat"
$askBak = "$userProfile\ask.bak"
$configFile = "$userProfile\.ask_setting.json"

function Install-Ask {
    Write-Host "=== ask Installer ===" -ForegroundColor Cyan
    try {
        $pythonVersion = python --version 2>&1
        Write-Host "[OK] Python found: $pythonVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Python not found" -ForegroundColor Red
        exit 1
    }
    Write-Host "`n[1/5] Installing dependencies..." -ForegroundColor Cyan
    try {
        python -m pip install requests --quiet
        Write-Host "[OK] Dependencies installed" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
    Write-Host "`n[2/5] Downloading ask..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile $askPy -ErrorAction Stop
        Write-Host "[OK] Downloaded" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Download failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "[3/5] Creating ask command..." -ForegroundColor Cyan
    $batContent = "@python `"%USERPROFILE%\ask.py`" %*"
    Set-Content -Path $askBat -Value $batContent -Encoding ASCII
    Write-Host "[OK] Created" -ForegroundColor Green
    Write-Host "[4/5] Adding to PATH..." -ForegroundColor Cyan
    # Always add to current session PATH if not present
    if ($env:PATH -notlike "*$userProfile*") {
        $env:PATH = "$env:PATH;$userProfile"
        # Also update system PATH for future sessions
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($currentPath -notlike "*$userProfile*") {
            [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$userProfile", "User")
        }
        Write-Host "[OK] Added to PATH" -ForegroundColor Green
    } else {
        Write-Host "[OK] Already in PATH" -ForegroundColor Green
    }
    Write-Host "[5/5] Creating config..." -ForegroundColor Cyan
    $needConfigEdit = $false
    if (-not (Test-Path $configFile)) {
        $config = @{base_url="https://cloud.infini-ai.com/maas/v1";api_key="YOUR_API_KEY";model="kimi-k2.5"}
        $config | ConvertTo-Json | Set-Content -Path $configFile -Encoding UTF8
        Write-Host "[OK] Config created" -ForegroundColor Green
        $needConfigEdit = $true
    } else {
        try {
            $existingConfig = Get-Content $configFile | ConvertFrom-Json
            if ($existingConfig.api_key -eq "YOUR_API_KEY" -or $existingConfig.api_key -eq "") {
                $needConfigEdit = $true
            }
        } catch {}
        if ($needConfigEdit) {
            Write-Host "[OK] Config exists, please update API key" -ForegroundColor Yellow
        } else {
            Write-Host "[OK] Config already exists" -ForegroundColor Green
        }
    }
    Write-Host "`n=== Install Complete ===" -ForegroundColor Cyan
    Write-Host "Testing ask command..."
    & "$askBat" --version 2>&1 | ForEach-Object { Write-Host $_ }
}

function Uninstall-Ask {
    Write-Host "=== ask Uninstaller ===" -ForegroundColor Cyan
    $files = @($askPy, $askBat, $askBak, $configFile)
    $filesToDelete = @()
    foreach ($f in $files) {
        if (Test-Path $f) { $filesToDelete += $f }
    }
    if ($filesToDelete.Count -eq 0) {
        Write-Host "No ask files found" -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Will delete:" -ForegroundColor Cyan
    foreach ($f in $filesToDelete) { Write-Host "  - $f" -ForegroundColor White }
    $confirm = Read-Host "`nConfirm delete? [y/N]"
    if ($confirm -ne "y") { Write-Host "Cancelled" -ForegroundColor Yellow; exit 0 }
    foreach ($f in $filesToDelete) {
        try { Remove-Item $f -Force; Write-Host "[OK] Deleted: $f" -ForegroundColor Green } catch { Write-Host "[ERROR] Failed: $f" -ForegroundColor Red }
    }
    Write-Host "`n=== Uninstall Complete ===" -ForegroundColor Cyan
}

if ($Uninstall) { Uninstall-Ask } else { Install-Ask }

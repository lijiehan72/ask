param(
    [switch]$Uninstall
)

# ask install/uninstall script

$userProfile = $env:USERPROFILE
$askPy = "$userProfile\ask.py"
$askBat = "$userProfile\ask.bat"
$askBak = "$userProfile\ask.bak"
$configFile = "$userProfile\.ask_setting.json"

function Install-Ask {
    Write-Host "=== ask Installer ===" -ForegroundColor Cyan

    # Check Python
    try {
        $pythonVersion = python --version 2>&1
        Write-Host "[OK] Python found: $pythonVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Python not found. Please install Python first." -ForegroundColor Red
        exit 1
    }

    # Install dependencies
    Write-Host "`n[1/5] Installing dependencies..." -ForegroundColor Cyan
    try {
        python -m pip install requests --quiet
        Write-Host "[OK] Dependencies installed" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to install dependencies: $_" -ForegroundColor Red
        exit 1
    }

    # 2. Download main script
    Write-Host "`n[2/5] Downloading ask..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile $askPy -ErrorAction Stop
        Write-Host "[OK] Downloaded" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Download failed: $_" -ForegroundColor Red
        exit 1
    }

    # 3. Create batch wrapper (always recreate to fix potential issues)
    Write-Host "[3/5] Creating ask command..." -ForegroundColor Cyan
    $batContent = '@python "%USERPROFILE%\ask.py" %*'
    Set-Content -Path $askBat -Value $batContent -Encoding ASCII
    Write-Host "[OK] Created" -ForegroundColor Green

    # 4. Add to PATH
    Write-Host "[4/5] Adding to PATH..." -ForegroundColor Cyan
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$userProfile*") {
        $newPath = "$currentPath;$userProfile"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "[OK] Added" -ForegroundColor Green
    } else {
        Write-Host "[OK] Already in PATH" -ForegroundColor Green
    }
    # 更新当前会话的 PATH
    $env:PATH = "$env:PATH;$userProfile"

    # 5. Create config (only if not exists)
    Write-Host "[5/5] Creating config..." -ForegroundColor Cyan
    $needConfigEdit = $false
    if (-not (Test-Path $configFile)) {
        $config = @{
            base_url = "https://cloud.infini-ai.com/maas/v1"
            api_key = "YOUR_API_KEY"
            model = "kimi-k2.5"
        }
        $config | ConvertTo-Json | Set-Content -Path $configFile -Encoding UTF8
        Write-Host "[OK] Config created: $configFile" -ForegroundColor Green
        $needConfigEdit = $true
    } else {
        # 检查是否需要更新
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
    if ($needConfigEdit) {
        Write-Host "Please update your API key in config file, then use:" -ForegroundColor White
    } else {
        Write-Host "You can now use:" -ForegroundColor White
    }
    Write-Host "  ask -y `"pwd`"" -ForegroundColor Green
}

function Uninstall-Ask {
    Write-Host "=== ask Uninstaller ===" -ForegroundColor Cyan

    $files = @($askPy, $askBat, $askBak, $configFile)
    $filesToDelete = @()

    foreach ($f in $files) {
        if (Test-Path $f) {
            $filesToDelete += $f
        }
    }

    if ($filesToDelete.Count -eq 0) {
        Write-Host "No ask files found" -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Will delete:" -ForegroundColor Cyan
    foreach ($f in $filesToDelete) {
        Write-Host "  - $f" -ForegroundColor White
    }

    $confirm = Read-Host "`nConfirm delete? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Cancelled" -ForegroundColor Yellow
        exit 0
    }

    foreach ($f in $filesToDelete) {
        try {
            Remove-Item $f -Force
            Write-Host "[OK] Deleted: $f" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed: $f" -ForegroundColor Red
        }
    }

    Write-Host "`n=== Uninstall Complete ===" -ForegroundColor Cyan
    Write-Host "To fully clean, remove $userProfile from PATH manually" -ForegroundColor Yellow
}

# Run
if ($Uninstall) {
    Uninstall-Ask
} else {
    Install-Ask
}

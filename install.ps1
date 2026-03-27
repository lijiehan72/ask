param(
    [switch]$Uninstall
)

# ask 安装/卸载脚本

$userProfile = $env:USERPROFILE
$askPy = "$userProfile\ask.py"
$askBat = "$userProfile\ask.bat"
$askBak = "$userProfile\ask.bak"
$configFile = "$userProfile\.ask_setting.json"

function Install-Ask {
    Write-Host "=== ask 安装程序 ===" -ForegroundColor Cyan

    # 检查 Python
    try {
        $pythonVersion = python --version 2>&1
        Write-Host "✓ 检测到 Python: $pythonVersion" -ForegroundColor Green
    } catch {
        Write-Host "✗ 未检测到 Python，请先安装 Python" -ForegroundColor Red
        Write-Host "  下载地址: https://www.python.org/downloads/" -ForegroundColor Yellow
        exit 1
    }

    # 1. 下载主脚本
    Write-Host "`n[1/4] 下载 ask 主脚本..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile $askPy -ErrorAction Stop
        Write-Host "✓ 下载完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ 下载失败: $_" -ForegroundColor Red
        exit 1
    }

    # 2. 创建批处理包装器
    Write-Host "[2/4] 创建 ask 命令..." -ForegroundColor Cyan
    $batContent = "@python `"%$userProfile%\ask.py`" %*"
    Set-Content -Path $askBat -Value $batContent -Encoding ASCII
    Write-Host "✓ 创建完成" -ForegroundColor Green

    # 3. 添加到 PATH
    Write-Host "[3/4] 添加到系统 PATH..." -ForegroundColor Cyan
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$userProfile*") {
        $newPath = "$currentPath;$userProfile"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "✓ 添加成功（需要重启终端生效）" -ForegroundColor Green
    } else {
        Write-Host "✓ 已存在 PATH 中" -ForegroundColor Green
    }

    # 4. 创建配置文件
    Write-Host "[4/4] 创建配置文件..." -ForegroundColor Cyan
    if (-not (Test-Path $configFile)) {
        $config = @{
            base_url = "https://cloud.infini-ai.com/maas/v1"
            api_key = "你的API密钥"
            model = "kimi-k2.5"
        }
        $config | ConvertTo-Json | Set-Content -Path $configFile -Encoding UTF8
        Write-Host "✓ 配置文件已创建: $configFile" -ForegroundColor Green
        Write-Host "  请编辑配置文件，填入你的 API Key" -ForegroundColor Yellow
    } else {
        Write-Host "✓ 配置文件已存在" -ForegroundColor Green
    }

    Write-Host "`n=== 安装完成 ===" -ForegroundColor Cyan
    Write-Host "请重启 PowerShell 后使用以下命令:" -ForegroundColor White
    Write-Host "  ask -y `"查看当前目录`"" -ForegroundColor Green
}

function Uninstall-Ask {
    Write-Host "=== ask 卸载程序 ===" -ForegroundColor Cyan

    $files = @($askPy, $askBat, $askBak, $configFile)
    $filesToDelete = @()

    foreach ($f in $files) {
        if (Test-Path $f) {
            $filesToDelete += $f
        }
    }

    if ($filesToDelete.Count -eq 0) {
        Write-Host "未找到 ask 相关文件" -ForegroundColor Yellow
        exit 0
    }

    Write-Host "将删除以下文件:" -ForegroundColor Cyan
    foreach ($f in $filesToDelete) {
        Write-Host "  - $f" -ForegroundColor White
    }

    $confirm = Read-Host "`n确认删除? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "已取消" -ForegroundColor Yellow
        exit 0
    }

    foreach ($f in $filesToDelete) {
        try {
            Remove-Item $f -Force
            Write-Host "✓ 已删除: $f" -ForegroundColor Green
        } catch {
            Write-Host "✗ 删除失败: $f" -ForegroundColor Red
        }
    }

    Write-Host "`n=== 卸载完成 ===" -ForegroundColor Cyan
    Write-Host "如需彻底清理，请手动从 PATH 中移除 $userProfile" -ForegroundColor Yellow
}

# 执行
if ($Uninstall) {
    Uninstall-Ask
} else {
    Install-Ask
}

#!/usr/bin/env pwsh
# Windows 安装脚本

$ErrorActionPreference = "Stop"

# 获取最新版本
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/fagao-ai/cte/releases/latest"
$version = $latestRelease.tag_name
Write-Host "Installing cte $version for Windows..."

# 下载
$downloadUrl = "https://github.com/fagao-ai/cte/releases/download/$version/cte-windows-amd64.zip"
$zipPath = "$env:TEMP\cte.zip"
$extractPath = "$env:TEMP\cte"

Write-Host "Downloading from $downloadUrl..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# 解压
Write-Host "Extracting..."
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# 安装
$binDir = "$env:USERPROFILE\.local\bin"
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

Write-Host "Installing to $binDir..."
Move-Item -Path "$extractPath\cte.exe" -Destination "$binDir\cte.exe" -Force

# 清理
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Write-Host "✓ cte has been installed to $binDir\cte.exe"
Write-Host ""
Write-Host "Add to PATH if needed:"
Write-Host "  [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';$binDir', 'User')"
Write-Host ""
Write-Host "Then restart your terminal and verify installation:"
Write-Host "  cte --version"

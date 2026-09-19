$version = "0.165.0"
$expectedSha256 = "c0259eb25d11b7d1ee7cd2f86da84f17323a36a90dee0ac0f7a93b635ec837f9"

$projectRoot = Split-Path -Parent $PSScriptRoot
$installDir = Join-Path $projectRoot ".tools\hugo"
$hugoExe = Join-Path $installDir "hugo.exe"
$archivePath = Join-Path ([System.IO.Path]::GetTempPath()) "hugo_extended_${version}_windows-amd64.zip"
$downloadUrl = "https://github.com/gohugoio/hugo/releases/download/v${version}/hugo_extended_${version}_windows-amd64.zip"

if (Test-Path -LiteralPath $hugoExe) {
    $installedVersion = & $hugoExe version
    if ($installedVersion -match "hugo v$([regex]::Escape($version))") {
        Write-Output $installedVersion
        exit 0
    }
}

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath

$actualSha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $archivePath).Hash.ToLowerInvariant()
if ($actualSha256 -ne $expectedSha256) {
    throw "Hugo 安装包校验失败。实际 SHA256：$actualSha256"
}

Expand-Archive -LiteralPath $archivePath -DestinationPath $installDir -Force
& $hugoExe version

$projectRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = Join-Path $projectRoot ".tools\hugo\hugo.exe"
$cacheDir = Join-Path $projectRoot ".hugo_cache"

if (-not (Test-Path -LiteralPath $hugoExe)) {
    throw "Hugo 未安装。预期位置：$hugoExe"
}

Push-Location $projectRoot
try {
    & $hugoExe --cacheDir $cacheDir --gc --minify --cleanDestinationDir
}
finally {
    Pop-Location
}

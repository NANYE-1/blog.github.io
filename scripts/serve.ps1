param(
    [switch]$IncludeDrafts
)

$projectRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = Join-Path $projectRoot ".tools\hugo\hugo.exe"
$cacheDir = Join-Path $projectRoot ".hugo_cache"

if (-not (Test-Path -LiteralPath $hugoExe)) {
    throw "Hugo 未安装。预期位置：$hugoExe"
}

$arguments = @(
    "server"
    "--cacheDir", $cacheDir
    "--bind", "127.0.0.1"
    "--port", "1313"
)

if ($IncludeDrafts) {
    $arguments += "--buildDrafts"
}

Push-Location $projectRoot
try {
    & $hugoExe @arguments
}
finally {
    Pop-Location
}

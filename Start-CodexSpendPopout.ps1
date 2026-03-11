param(
    [switch]$Build
)

$ErrorActionPreference = "Stop"
$project = Join-Path $PSScriptRoot "CodexSpendMonitor\CodexSpendMonitor.csproj"
$publishDir = Join-Path $PSScriptRoot "dist\CodexSpendMonitor"
$exePath = Join-Path $publishDir "CodexSpendMonitor.exe"
$releaseOutputDir = Join-Path $PSScriptRoot "CodexSpendMonitor\bin\Release\net9.0-windows10.0.19041.0\win-x64"

function Copy-WinUiPublishArtifacts {
    $artifacts = @(
        "App.xbf",
        "CodexSpendMonitor.pri"
    )

    foreach ($artifact in $artifacts) {
        $source = Join-Path $releaseOutputDir $artifact
        $destination = Join-Path $publishDir $artifact
        if (Test-Path $source) {
            Copy-Item $source $destination -Force
        }
    }
}

if ($Build -or -not (Test-Path $exePath)) {
    dotnet publish $project -c Release -o $publishDir
}

Copy-WinUiPublishArtifacts
Start-Process -FilePath $exePath

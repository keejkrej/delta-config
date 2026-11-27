$ErrorActionPreference = 'Stop'

$fallback = $null
if ($env:DELTA_CONFIG_DIR) {
    $dest = $env:DELTA_CONFIG_DIR
} else {
    $dest = Join-Path $env:APPDATA 'delta'
    $fallback = Join-Path $env:USERPROFILE '.config\delta'
}

$source = Join-Path $PSScriptRoot 'AGENTS.md'
$target = Join-Path $dest 'AGENTS.md'
foreach ($folder in @($dest, $fallback)) {
    if (-not $folder) { continue }
    foreach ($filename in @('AGENT.md', 'AGENTS.md')) {
        $path = Join-Path $folder $filename
        if (Test-Path -LiteralPath $path) {
            if ($path -eq $target -and (Test-Path -LiteralPath $path -PathType Leaf) -and
                (Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $path).Hash) {
                continue
            }
            throw "Existing rules at $path; merge the prompt manually to preserve them."
        }
    }
}

if (Test-Path -LiteralPath $target -PathType Leaf) {
    Write-Host "Already installed: $target"
} else {
    $null = [System.IO.Directory]::CreateDirectory($dest)
    [System.IO.File]::Copy($source, $target, $false)
    Write-Host "Installed: $target"
}

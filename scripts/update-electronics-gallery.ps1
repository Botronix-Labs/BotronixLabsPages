$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$imageDir = Join-Path $repoRoot 'assets\Images\program images\electronics images'
$output = Join-Path $repoRoot 'programs\electronics-gallery.json'

function Titleize([string]$name) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($name)
    $base = $base -replace '[-_]+', ' '
    $base = ($base -replace '\s+', ' ').Trim()
    if (-not $base) { return $base }
    return ($base.ToLowerInvariant() -split ' ' | ForEach-Object {
        if ($_ -eq '') { return $_ }
        $_.Substring(0,1).ToUpperInvariant() + $_.Substring(1)
    }) -join ' '
}

$items = Get-ChildItem -LiteralPath $imageDir -File |
    Where-Object { $_.Extension -match '^\.(png|jpe?g|gif|webp)$' } |
    Sort-Object Name |
    ForEach-Object {
        [pscustomobject]@{
            src = "../assets/Images/program images/electronics images/$($_.Name)"
            alt = Titleize $_.Name
        }
    }

$items | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $output

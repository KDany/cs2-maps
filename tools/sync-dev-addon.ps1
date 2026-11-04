<#
.SYNOPSIS
    Syncs a map between this repository and its "<map>_dev" playtest addon.

.DESCRIPTION
    The repository only contains the release version of each map (e.g. de_dust2_long/).
    Playtest builds are made in a separate CS2 addon whose map name has a "_dev" suffix
    (e.g. csgo_addons\de_dust2_long_dev\maps\de_dust2_long_dev.vmap).

    Default direction (repo -> dev addon):
      - mirrors <repo>\<map>\ into <csgo_addons>\<map>_dev\
      - copies maps\<map>.vmap as maps\<map>_dev.vmap
      - files named after the map (radar, .vpdi, ...) are NOT copied: the build
        regenerates them with the _dev name ("Create minimap on build").

    With -ToRepo (dev addon -> repo):
      - copies the dev addon back into the repository (no deletions)
      - copies maps\<map>_dev.vmap back as maps\<map>.vmap
      - files named after the _dev map are NOT copied into the repository

    If the target .vmap is newer than the source .vmap, the script stops so that
    unsaved work is not overwritten. Use -Force to overwrite anyway.

.EXAMPLE
    .\tools\sync-dev-addon.ps1 -Map de_dust2_long

.EXAMPLE
    .\tools\sync-dev-addon.ps1 -Map de_dust2_long -ToRepo

.NOTES
    Run from anywhere; the repository root is the parent folder of this script.
    If PowerShell blocks the script, run it with:
      powershell -ExecutionPolicy Bypass -File .\tools\sync-dev-addon.ps1 -Map de_dust2_long
#>
param(
    [Parameter(Mandatory = $true)] [string] $Map,
    [string] $AddonsDir = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\content\csgo_addons",
    [switch] $ToRepo,
    [switch] $Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$devName  = "${Map}_dev"
$repoMap  = Join-Path $repoRoot $Map
$devMap   = Join-Path $AddonsDir $devName

if ($ToRepo) {
    $src = $devMap;  $dst = $repoMap
    $srcVmap = Join-Path $devMap  "maps\$devName.vmap"
    $dstVmap = Join-Path $repoMap "maps\$Map.vmap"
    $exclude = "*$devName*"
    $mode    = "/E"      # copy, never delete in the repository
} else {
    $src = $repoMap; $dst = $devMap
    $srcVmap = Join-Path $repoMap "maps\$Map.vmap"
    $dstVmap = Join-Path $devMap  "maps\$devName.vmap"
    $exclude = "*$Map*"  # also protects the _dev files in the addon from being purged
    $mode    = "/MIR"    # the dev addon is an exact copy of the repository
}

if (-not (Test-Path -LiteralPath $srcVmap)) {
    throw "Source map not found: $srcVmap"
}

if ((Test-Path -LiteralPath $dstVmap) -and -not $Force) {
    $srcTime = (Get-Item -LiteralPath $srcVmap).LastWriteTime
    $dstTime = (Get-Item -LiteralPath $dstVmap).LastWriteTime
    if ($dstTime -gt $srcTime) {
        throw "Target map is newer than the source:`n  source: $srcVmap ($srcTime)`n  target: $dstVmap ($dstTime)`nNothing was copied. Use -Force to overwrite the target anyway."
    }
}

Write-Host "Syncing $src -> $dst"

# Copy everything except files named after the map
robocopy $src $dst $mode /XF $exclude /NFL /NDL /NJH /NP | Out-Host
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}

# Copy the map file under the target map name
New-Item -ItemType Directory -Path (Split-Path -Parent $dstVmap) -Force | Out-Null
Copy-Item -LiteralPath $srcVmap -Destination $dstVmap -Force

Write-Host "Copied map: $srcVmap -> $dstVmap"
Write-Host "Done."

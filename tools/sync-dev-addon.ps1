<#
.SYNOPSIS
    Syncs a map between this repository and its "<map>_dev" playtest addon,
    renaming everything that carries the map name.

.DESCRIPTION
    The repository only contains the release version of each map (e.g. de_dust2_long/).
    Playtest builds are made in a separate CS2 addon whose map name has a "_dev" suffix
    (e.g. csgo_addons\de_dust2_long_dev\maps\de_dust2_long_dev.vmap).

    What the script does:
      1. Copies the whole map folder (repo -> addon: exact mirror, addon -> repo:
         copy only, nothing is deleted in the repository).
      2. Every file or folder whose name contains the map name is copied under the
         target map name, e.g.
           maps\de_dust2_long.vmap                     -> maps\de_dust2_long_dev.vmap
           ...\overheadmaps\de_dust2_long_radar.tga    -> ...\de_dust2_long_dev_radar.tga
           panorama\dynamic_image_de_dust2_long.vpdi   -> ...\dynamic_image_de_dust2_long_dev.vpdi
           postprocess\de_dust2_long.vpost             -> postprocess\de_dust2_long_dev.vpost
      3. In text files (.vpdi, .txt, .vpost, .vsndevts, .vmat, .vmdl, ...) every
         occurrence of the map name inside the file is replaced as well, e.g. the
         radar image path inside the .vpdi. Binary files (.vmap, .tga, .dmx, ...)
         are never edited, only copied/renamed.

    Not handled: the radar overview file the minimap generator writes into the GAME
    folder (game\csgo_addons\<addon>\resource\overviews\<map>.txt). It is created
    once with "Create minimap on load" and is not part of the repository.

    Safety: if the target .vmap is newer than the source .vmap, the script stops so
    that unsaved work is not overwritten. Use -Force to overwrite anyway.
    Use -DryRun to only print what would be copied, renamed or edited.

.EXAMPLE
    .\tools\sync-dev-addon.ps1 -Map de_dust2_long -DryRun

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
    [string] $Suffix = "_dev",
    [string] $AddonsDir = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\content\csgo_addons",
    [switch] $ToRepo,
    [switch] $Force,
    [switch] $DryRun
)

$ErrorActionPreference = "Stop"

if (-not $Suffix) { throw "-Suffix must not be empty." }

$repoRoot = Split-Path -Parent $PSScriptRoot
$devName  = "$Map$Suffix"
$repoMap  = Join-Path $repoRoot $Map
$devMap   = Join-Path $AddonsDir $devName

if ($ToRepo) {
    $src = $devMap;  $dst = $repoMap; $fromName = $devName; $toName = $Map
    $mode = "/E"      # copy only, never delete in the repository
    # "de_dust2_long_dev" -> "de_dust2_long"
    $pattern = [regex]::Escape($devName)
} else {
    $src = $repoMap; $dst = $devMap;  $fromName = $Map;     $toName = $devName
    $mode = "/MIR"    # the dev addon is an exact copy of the repository
    # "de_dust2_long" -> "de_dust2_long_dev", but leave existing "de_dust2_long_dev" alone
    $pattern = [regex]::Escape($Map) + "(?!" + [regex]::Escape($Suffix) + ")"
}
$rx = New-Object System.Text.RegularExpressions.Regex($pattern)

# Text formats whose content may reference the map name
$textExt = @(".txt", ".vpdi", ".vpost", ".vsndevts", ".vmat", ".vmdl", ".vdata",
             ".kv3", ".cfg", ".json", ".vpcf", ".vts", ".vjs", ".js", ".ts", ".css",
             ".xml", ".vxml", ".vcss", ".vrr", ".vsmart", ".vsurf", ".res")
# ISO-8859-1 maps every byte to one char and back, so files are rewritten byte-for-byte
# (encoding, BOM and line endings are preserved); only the ASCII map name changes.
$latin1 = [System.Text.Encoding]::GetEncoding(28591)

$srcVmap = Join-Path $src "maps\$fromName.vmap"
$dstVmap = Join-Path $dst "maps\$toName.vmap"

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

$prefix = if ($DryRun) { "[dry run] " } else { "" }
Write-Host "${prefix}Syncing $src -> $dst  ($fromName -> $toName)"

# 1) Bulk copy of everything that does not carry the map name.
#    Files/folders named after the map are excluded here (and therefore also protected
#    from being purged in the target); they are handled in step 2.
$rcArgs = @($src, $dst, $mode, "/XF", "*$Map*", "/XD", "*$Map*", "/NFL", "/NDL", "/NJH", "/NJS", "/NP")
if ($DryRun) { $rcArgs += "/L" }
robocopy @rcArgs | Out-Host
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}

# 2) Files named after the map, and text files that mention it: rename and/or rewrite.
function Convert-RelativePath([string] $rel) {
    return (($rel -split '\\') | ForEach-Object { $rx.Replace($_, $toName) }) -join '\'
}

$renamed = 0; $edited = 0
$srcFull = (Resolve-Path -LiteralPath $src).Path.TrimEnd('\')

Get-ChildItem -LiteralPath $srcFull -Recurse -File | ForEach-Object {
    $rel     = $_.FullName.Substring($srcFull.Length).TrimStart('\')
    $nameHit = $rx.IsMatch($rel)

    $newBytes = $null
    if (($textExt -contains $_.Extension.ToLowerInvariant()) -and $_.Length -lt 50MB) {
        $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
        if ([Array]::IndexOf($bytes, [byte]0) -lt 0) {          # skip binary content
            $text = $latin1.GetString($bytes)
            if ($rx.IsMatch($text)) {
                $newBytes = $latin1.GetBytes($rx.Replace($text, $toName))
            }
        }
    }

    if (-not $nameHit -and $null -eq $newBytes) { return }

    $relTarget = Convert-RelativePath $rel
    $target    = Join-Path $dst $relTarget

    $what = @()
    if ($nameHit)            { $what += "rename"; $renamed++ }
    if ($null -ne $newBytes) { $what += "edit";   $edited++ }
    Write-Host ("{0}{1,-12} {2} -> {3}" -f $prefix, ($what -join "+"), $rel, $relTarget)

    if ($DryRun) { return }
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    if ($null -ne $newBytes) {
        [System.IO.File]::WriteAllBytes($target, $newBytes)
    } else {
        Copy-Item -LiteralPath $_.FullName -Destination $target -Force
    }
}

Write-Host "${prefix}Done. Renamed: $renamed file(s), content edited: $edited file(s)."
if (-not $ToRepo) {
    Write-Host "Note: files in the target that are named after the map but no longer exist in the source are not deleted."
}

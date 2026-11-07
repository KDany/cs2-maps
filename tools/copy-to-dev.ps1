<#
.SYNOPSIS
    Copies a map addon to its "<map>_dev" playtest addon, renaming everything that
    carries the map name. One way only: the release addon is never written to.

.DESCRIPTION
    Playtest builds are uploaded to a separate Workshop item whose map name has a
    "_dev" suffix (e.g. de_dust2_long_dev), so they can be installed next to the
    release version. This script creates or refreshes that addon from the release
    addon you are working in:

      1. CONTENT addon (content\csgo_addons\<map> -> content\csgo_addons\<map>_dev)
         - Every file is copied. Files and folders named after the map are copied
           under the dev name, e.g.
             maps\de_dust2_long.vmap                    -> maps\de_dust2_long_dev.vmap
             ...\overheadmaps\de_dust2_long_radar.tga   -> ...\de_dust2_long_dev_radar.tga
             panorama\dynamic_image_de_dust2_long.vpdi  -> ...\dynamic_image_de_dust2_long_dev.vpdi
         - In text files (.vpdi, .txt, .vpost, .vmat, .vmdl, ...) the map name inside
           the file is replaced as well (e.g. the radar path in the .vpdi). Binary
           files (.vmap, .tga, .dmx, ...) are only copied/renamed, never edited.
         - The dev addon becomes an exact copy: files in it that do not come from
           the release addon are deleted (except its own compile output).
         - Not copied: the release map's compile output folder (maps\<map>\),
           Hammer autosaves and .bak files.

      2. GAME addon (game\csgo_addons\<map> -> game\csgo_addons\<map>_dev)
         Only the hand-made text files named after the map are copied, renamed and
         edited, e.g.
             maps\de_dust2_long_retake.txt          -> maps\de_dust2_long_dev_retake.txt
             resource\overviews\de_dust2_long.txt   -> resource\overviews\de_dust2_long_dev.txt
         Compiled files are not touched: the dev map has to be built in Hammer.

    Safety:
      - The target must be the "<map><suffix>" addon; the script refuses to write to
        any other folder, and there is no option to copy in the other direction.
      - If the dev .vmap is newer than the release .vmap, the dev map was probably
        edited by hand and those edits would be lost, so the script stops.
        Use -Force to overwrite it anyway.
      - -DryRun only prints what would be copied, renamed, edited or deleted.

.EXAMPLE
    .\tools\copy-to-dev.ps1 -Map de_dust2_long -DryRun

.EXAMPLE
    .\tools\copy-to-dev.ps1 -Map de_dust2_long

.NOTES
    -InstallDir is the CS2 install folder (the one that contains "content" and "game").
    If PowerShell blocks the script, run it with:
      powershell -ExecutionPolicy Bypass -File .\tools\copy-to-dev.ps1 -Map de_dust2_long
#>
param(
    [Parameter(Mandatory = $true)] [string] $Map,
    [string] $Suffix = "_dev",
    [string] $InstallDir = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive",
    [switch] $Force,
    [switch] $DryRun
)

$ErrorActionPreference = "Stop"

if (-not $Suffix) { throw "-Suffix must not be empty." }
if ($Map.EndsWith($Suffix, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "'$Map' already ends with '$Suffix'. Pass the release map name; this script only copies release -> dev."
}

$devName = "$Map$Suffix"
$srcContent = Join-Path $InstallDir "content\csgo_addons\$Map"
$dstContent = Join-Path $InstallDir "content\csgo_addons\$devName"
$srcGame    = Join-Path $InstallDir "game\csgo_addons\$Map"
$dstGame    = Join-Path $InstallDir "game\csgo_addons\$devName"

# --- Guards ------------------------------------------------------------------
if (-not (Test-Path -LiteralPath $srcContent)) { throw "Release addon not found: $srcContent" }
$srcContent = (Resolve-Path -LiteralPath $srcContent).Path.TrimEnd('\')
$dstContent = [System.IO.Path]::GetFullPath($dstContent).TrimEnd('\')
if ((Split-Path -Leaf $dstContent) -ne $devName -or $dstContent -ieq $srcContent -or
    $dstContent.StartsWith("$srcContent\", [System.StringComparison]::OrdinalIgnoreCase) -or
    $srcContent.StartsWith("$dstContent\", [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to write to '$dstContent': the target must be the separate '$devName' addon."
}

$srcVmap = Join-Path $srcContent "maps\$Map.vmap"
$dstVmap = Join-Path $dstContent "maps\$devName.vmap"
if (-not (Test-Path -LiteralPath $srcVmap)) { throw "Release map not found: $srcVmap" }
if ((Test-Path -LiteralPath $dstVmap) -and -not $Force) {
    $srcTime = (Get-Item -LiteralPath $srcVmap).LastWriteTime
    $dstTime = (Get-Item -LiteralPath $dstVmap).LastWriteTime
    if ($dstTime -gt $srcTime) {
        throw "The dev map is newer than the release map (edited by hand?):`n  release: $srcVmap ($srcTime)`n  dev:     $dstVmap ($dstTime)`nNothing was copied. Use -Force to overwrite the dev addon anyway."
    }
}

# --- Helpers -----------------------------------------------------------------
# "de_dust2_long" -> "de_dust2_long_dev", but leave an existing "de_dust2_long_dev" alone
$rx = New-Object System.Text.RegularExpressions.Regex(
    ([regex]::Escape($Map) + "(?!" + [regex]::Escape($Suffix) + ")"),
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

# Text formats whose content may reference the map name
$textExt = @(".txt", ".vpdi", ".vpost", ".vsndevts", ".vmat", ".vmdl", ".vdata",
             ".kv3", ".cfg", ".json", ".vpcf", ".vts", ".vjs", ".js", ".ts", ".css",
             ".xml", ".vxml", ".vcss", ".vrr", ".vsmart", ".vsurf", ".res")
# ISO-8859-1 maps every byte to one char and back, so files are rewritten byte-for-byte
# (encoding, BOM and line endings are preserved); only the ASCII map name changes.
$latin1 = [System.Text.Encoding]::GetEncoding(28591)
$prefix = if ($DryRun) { "[dry run] " } else { "" }

function Convert-RelativePath([string] $rel) {
    return (($rel -split '\\') | ForEach-Object { $rx.Replace($_, $devName) }) -join '\'
}

function Get-EditedBytes([System.IO.FileInfo] $file) {
    if (-not ($textExt -contains $file.Extension.ToLowerInvariant()) -or $file.Length -ge 50MB) { return $null }
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ([Array]::IndexOf($bytes, [byte]0) -ge 0) { return $null }    # binary content
    $text = $latin1.GetString($bytes)
    if (-not $rx.IsMatch($text)) { return $null }
    return $latin1.GetBytes($rx.Replace($text, $devName))
}

# Copies one file, renaming and editing it if needed. Returns the target path.
function Copy-One([System.IO.FileInfo] $file, [string] $srcRoot, [string] $dstRoot, [switch] $Quiet) {
    $rel       = $file.FullName.Substring($srcRoot.Length).TrimStart('\')
    $relTarget = Convert-RelativePath $rel
    $target    = Join-Path $dstRoot $relTarget
    $newBytes  = Get-EditedBytes $file

    $what = @()
    if ($relTarget -ne $rel)  { $what += "rename"; $script:renamed++ }
    if ($null -ne $newBytes)  { $what += "edit";   $script:edited++ }
    if ($what.Count -gt 0 -or -not $Quiet) {
        $label = if ($what.Count -gt 0) { $what -join "+" } else { "copy" }
        Write-Host ("{0}{1,-12} {2} -> {3}" -f $prefix, $label, $rel, $relTarget)
    }
    $script:copied++

    if (-not $DryRun) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
        if ($null -ne $newBytes) {
            [System.IO.File]::WriteAllBytes($target, $newBytes)
        } else {
            Copy-Item -LiteralPath $file.FullName -Destination $target -Force
        }
    }
    return $target
}

$script:copied = 0; $script:renamed = 0; $script:edited = 0; $deleted = 0

# --- 1) Content addon: exact copy --------------------------------------------
Write-Host "${prefix}Content: $srcContent -> $dstContent"

$skipSrc = @("maps\$Map\", "maps\autosave\")          # compile output, Hammer autosaves
$keepDst = @("maps\$devName\", "maps\autosave\")      # the dev map's own compile output / autosaves
function Test-Under([string] $rel, [string[]] $dirs) {
    foreach ($d in $dirs) { if ($rel.StartsWith($d, [System.StringComparison]::OrdinalIgnoreCase)) { return $true } }
    return $false
}

$written = New-Object 'System.Collections.Generic.HashSet[string]' -ArgumentList ([System.StringComparer]::OrdinalIgnoreCase)
Get-ChildItem -LiteralPath $srcContent -Recurse -File -Force | ForEach-Object {
    $rel = $_.FullName.Substring($srcContent.Length).TrimStart('\')
    if ((Test-Under $rel $skipSrc) -or $_.Name -like "*.bak" -or $_.Name -like "*.bak[0-9]") { return }
    [void] $written.Add((Copy-One $_ $srcContent $dstContent -Quiet))
}

# Delete files in the dev addon that no longer come from the release addon
if (Test-Path -LiteralPath $dstContent) {
    Get-ChildItem -LiteralPath $dstContent -Recurse -File -Force | ForEach-Object {
        $rel = $_.FullName.Substring($dstContent.Length).TrimStart('\')
        if ((Test-Under $rel $keepDst) -or $written.Contains($_.FullName)) { return }
        Write-Host ("{0}{1,-12} {2}" -f $prefix, "delete", $rel)
        $deleted++
        if (-not $DryRun) { Remove-Item -LiteralPath $_.FullName -Force }
    }
    if (-not $DryRun) {
        # Remove folders left empty, deepest first
        Get-ChildItem -LiteralPath $dstContent -Recurse -Directory -Force |
            Sort-Object { $_.FullName.Length } -Descending |
            Where-Object { -not (Get-ChildItem -LiteralPath $_.FullName -Force) } |
            ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force }
    }
}

# --- 2) Game addon: hand-made text files named after the map -----------------
if (Test-Path -LiteralPath $srcGame) {
    $srcGame = (Resolve-Path -LiteralPath $srcGame).Path.TrimEnd('\')
    $dstGame = [System.IO.Path]::GetFullPath($dstGame).TrimEnd('\')
    Write-Host "${prefix}Game:    $srcGame -> $dstGame"
    Get-ChildItem -LiteralPath $srcGame -Recurse -File -Force -Filter "*.txt" |
        Where-Object { $rx.IsMatch($_.Name) } |
        ForEach-Object { [void] (Copy-One $_ $srcGame $dstGame) }
} else {
    Write-Host "${prefix}Game addon not found, skipped: $srcGame"
}

Write-Host ("{0}Done. Copied: {1} file(s), renamed: {2}, content edited: {3}, deleted from dev: {4}." -f `
    $prefix, $script:copied, $script:renamed, $script:edited, $deleted)
Write-Host "Next: open maps\$devName.vmap in Hammer and build it before uploading the playtest."

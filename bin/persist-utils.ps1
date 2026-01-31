. "$PSScriptRoot\fs-utils.ps1"

# Set-PersistLinks: batch-create folder links and generate a restore script.
# $LinkMap: hashtable mapping persist subdirectory name to original path,
#   e.g. @{ "appdata" = "$env:APPDATA\MyApp"; "cache" = "$env:USERPROFILE\.cache\myapp" }
Function Set-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        Set-FolderLink -TargetDir "$PersistDir\$($entry.Key)" -JunctionDir $entry.Value
    }

    # Generate restore script for migrating back to official (non-portable) layout
    $lines = @(
        '# Restore persist data back to original directories.'
        '# Run this AFTER scoop uninstall to migrate from portable back to official install.'
        ''
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $src = "`"$PersistDir\$($entry.Key)`""
        $dst = "`"$($entry.Value)`""
        $parent = "`"$(Split-Path $entry.Value -Parent)`""
        $lines += "if (Test-Path $src) {"
        $lines += "    if (-not (Test-Path $parent)) { New-Item -Path $parent -ItemType Directory -Force | Out-Null }"
        $lines += "    Copy-Item -Path $src -Destination $dst -Recurse -Force"
        $lines += "}"
    }
    Set-Content -Path "$PersistDir\restore-official-data.ps1" -Value ($lines -join "`r`n") -Encoding UTF8
}

# Remove-PersistLinks: batch-remove folder links and remind user about the restore script.
Function Remove-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        Remove-FolderLink -JunctionDir $entry.Value -TargetDir "$PersistDir\$($entry.Key)"
    }
    if (Test-Path "$PersistDir\restore-official-data.ps1") {
        Write-Host "To restore data back to original directories, run:" -ForegroundColor Yellow
        Write-Host "  powershell -File `"$PersistDir\restore-official-data.ps1`"" -ForegroundColor Cyan
    }
}

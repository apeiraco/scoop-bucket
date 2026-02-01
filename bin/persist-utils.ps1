. "$PSScriptRoot\fs-utils.ps1"

# Set-PersistLinks: batch-create folder links and generate a restore script.
# $LinkMap: hashtable mapping persist subdirectory name to original path,
#   use single-quoted delayed expressions, e.g.
#   @{ "appdata" = '$env:APPDATA\MyApp'; "cache" = '$env:USERPROFILE\.cache\myapp' }
Function Resolve-LinkPathExpression {
    param(
        [string]$PathExpression
    )
    return $ExecutionContext.InvokeCommand.ExpandString($PathExpression)
}

Function Set-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $resolvedPath = Resolve-LinkPathExpression -PathExpression ([string]$entry.Value)
        Set-FolderLink -TargetDir "$PersistDir\$($entry.Key)" -JunctionDir $resolvedPath
    }

    # Generate restore script for migrating back to official (non-portable) layout
    $lines = @(
        '# Restore persist data back to original directories.'
        '# Run this AFTER scoop uninstall to migrate from portable back to official install.'
        ''
        '$linkMap = @{'
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $key = ([string]$entry.Key) -replace "'", "''"
        $value = ([string]$entry.Value) -replace "'", "''"
        $lines += "    '$key' = '$value'"
    }
    $lines += '}'
    $lines += ''
    $lines += 'foreach ($entry in $linkMap.GetEnumerator()) {'
    $lines += '    $src = Join-Path $PSScriptRoot $entry.Key'
    $lines += '    $dst = $ExecutionContext.InvokeCommand.ExpandString($entry.Value)'
    $lines += '    $parent = Split-Path $dst -Parent'
    $lines += '    if (Test-Path $src) {'
    $lines += '        if (-not (Test-Path $parent)) { New-Item -Path $parent -ItemType Directory -Force | Out-Null }'
    $lines += '        Copy-Item -Path $src -Destination $dst -Recurse -Force'
    $lines += '    }'
    $lines += '}'
    Set-Content -Path "$PersistDir\restore-official-data.ps1" -Value ($lines -join "`r`n") -Encoding UTF8
}

# Remove-PersistLinks: batch-remove folder links and remind user about the restore script.
Function Remove-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $resolvedPath = Resolve-LinkPathExpression -PathExpression ([string]$entry.Value)
        Remove-FolderLink -JunctionDir $resolvedPath -TargetDir "$PersistDir\$($entry.Key)"
    }
    if (Test-Path "$PersistDir\restore-official-data.ps1") {
        Write-Host "To restore data back to original directories, run:" -ForegroundColor Yellow
        Write-Host "  powershell -File `"$PersistDir\restore-official-data.ps1`"" -ForegroundColor Cyan
    }
}

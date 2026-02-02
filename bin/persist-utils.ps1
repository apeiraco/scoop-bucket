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

Function Write-PortableLog {
    param(
        [string]$Message,
        [ConsoleColor]$Color = [ConsoleColor]::Cyan,
        [switch]$LeadingNewline
    )
    if ($LeadingNewline) {
        Write-Host ''
    }
    Write-Host "[Portable Mode] $Message" -ForegroundColor $Color
}

Function Set-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap,
        [bool]$Verbose = $true
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $resolvedPath = Resolve-LinkPathExpression -PathExpression ([string]$entry.Value)
        $targetDir = "$PersistDir\$($entry.Key)"
        Set-FolderLink -TargetDir $targetDir -JunctionDir $resolvedPath -Verbose:$Verbose
    }

    # Generate restore script for migrating back to official (non-portable) layout
    $lines = @(
        '# Restore persist data back to original directories.'
        '# Run this AFTER scoop uninstall to migrate from portable back to official install.'
        ''
        'function Write-RestoreLog {'
        '    param('
        '        [string]$Message,'
        '        [ConsoleColor]$Color = [ConsoleColor]::Cyan,'
        '        [switch]$LeadingNewline'
        '    )'
        '    if ($LeadingNewline) {'
        '        Write-Host ""'
        '    }'
        '    Write-Host "[Portable Mode] $Message" -ForegroundColor $Color'
        '}'
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
    $lines += '        Write-RestoreLog -LeadingNewline -Message "Copy user data ''$src'' -> ''$dst''."'
    $lines += '        if (-not (Test-Path $parent)) { New-Item -Path $parent -ItemType Directory -Force | Out-Null }'
    $lines += '        Copy-Item -Path $src -Destination $dst -Recurse -Force'
    $lines += '    } else {'
    $lines += '        Write-RestoreLog -LeadingNewline -Color DarkGray -Message "Skip ''$src'' (not found)."'
    $lines += '    }'
    $lines += '}'
    $restoreScriptPath = "$PersistDir\restore-official-data.ps1"
    Set-Content -Path $restoreScriptPath -Value ($lines -join "`r`n") -Encoding UTF8
    if ($Verbose) {
        Write-PortableLog -LeadingNewline -Message "Create restore script: '$restoreScriptPath'."
    }
}

# Remove-PersistLinks: batch-remove folder links and remind user about the restore script.
Function Remove-PersistLinks {
    param(
        [string]$PersistDir,
        [hashtable]$LinkMap,
        [bool]$Verbose = $true
    )
    foreach ($entry in $LinkMap.GetEnumerator()) {
        $resolvedPath = Resolve-LinkPathExpression -PathExpression ([string]$entry.Value)
        $targetDir = "$PersistDir\$($entry.Key)"
        Remove-FolderLink -JunctionDir $resolvedPath -TargetDir $targetDir -Verbose:$Verbose
    }
    if (Test-Path "$PersistDir\restore-official-data.ps1") {
        Write-PortableLog -LeadingNewline -Color Yellow -Message "To restore user data back to original directories, run:"
        Write-PortableLog -Color Cyan -Message "powershell -File `"$PersistDir\restore-official-data.ps1`""
    }
}

Function Set-FolderLinked {
    param(
        [string]$TargetDir,
        [string]$JunctionDir
    )
    if (-not (Test-Path $TargetDir)) {
        New-Item -Path $TargetDir -ItemType Directory | Out-Null
    }
    $linkType = (Get-Item -Path $JunctionDir -ErrorAction SilentlyContinue).LinkType
    if (Test-Path $JunctionDir) {
        if ($linkType -eq 'Junction' -or $linkType -eq 'SymbolicLink') {
            # if target equals to $TargetDir, skip to remove
            if ((Get-Item -Path $JunctionDir).Target -eq $TargetDir) {
                return
            }
            Remove-Item -Path $JunctionDir -Force
        } else {
            Get-ChildItem -Path $JunctionDir -Force | Move-Item -Destination $TargetDir -Force
            Remove-Item -Path $JunctionDir -Force -Recurse
        }
    }
    try {
        New-Item "$JunctionDir" -ItemType Junction -Target "$TargetDir" -ErrorAction Stop | Out-Null
    } catch {
        New-Item "$JunctionDir" -ItemType SymbolicLink -Target "$TargetDir" | Out-Null
    }
}

Function Set-FolderUnlinked {
    param(
        [string]$JunctionDir,
        [string]$TargetDir
    )
    $linkType = (Get-Item -Path $JunctionDir -ErrorAction SilentlyContinue).LinkType
    if (Test-Path $JunctionDir) {
        # only remove junction to $TargetDir
        if ($linkType -eq 'Junction' -or $linkType -eq 'SymbolicLink') {
            if ((Get-Item -Path $JunctionDir).Target -eq $TargetDir) {
                Remove-Item -Path $JunctionDir -Force
            }
        }
    }
}

Function Set-FolderLink {
    param(
        [string]$TargetDir,
        [string]$JunctionDir,
        [bool]$Verbose = $false
    )
    if ($Verbose) {
        Write-Host ''
        Write-Host "[Portable Mode] Prepare link '$JunctionDir' -> '$TargetDir'." -ForegroundColor Cyan
    }
    if (-not (Test-Path $TargetDir)) {
        New-Item -Path $TargetDir -ItemType Directory -Force | Out-Null
        if ($Verbose) {
            Write-Host "[Portable Mode] Created persist directory '$TargetDir'." -ForegroundColor DarkGray
        }
    }
    $linkType = (Get-Item -Path $JunctionDir -ErrorAction SilentlyContinue).LinkType
    if (Test-Path $JunctionDir) {
        if ($linkType -eq 'Junction' -or $linkType -eq 'SymbolicLink') {
            # if target equals to $TargetDir, skip to remove
            if ((Get-Item -Path $JunctionDir).Target -eq $TargetDir) {
                if ($Verbose) {
                    Write-Host "[Portable Mode] Skip '$JunctionDir' (already linked)." -ForegroundColor DarkGray
                }
                return
            }
            if ($Verbose) {
                Write-Host "[Portable Mode] Replace existing link '$JunctionDir'." -ForegroundColor Yellow
            }
            Remove-Item -Path $JunctionDir -Force
        } else {
            if ($Verbose) {
                Write-Host "[Portable Mode] Move user data '$JunctionDir' -> '$TargetDir'." -ForegroundColor Yellow
            }
            Get-ChildItem -Path $JunctionDir -Force | Move-Item -Destination $TargetDir -Force
            Remove-Item -Path $JunctionDir -Force -Recurse
        }
    }
    $ParentDir = Split-Path $JunctionDir -Parent
    if (-not (Test-Path $ParentDir)) {
        New-Item -Path $ParentDir -ItemType Directory -Force | Out-Null
        if ($Verbose) {
            Write-Host "[Portable Mode] Created parent directory '$ParentDir'." -ForegroundColor DarkGray
        }
    }
    try {
        New-Item "$JunctionDir" -ItemType Junction -Target "$TargetDir" -ErrorAction Stop | Out-Null
        if ($Verbose) {
            Write-Host "[Portable Mode] Created junction '$JunctionDir' -> '$TargetDir'." -ForegroundColor Green
        }
    } catch {
        New-Item "$JunctionDir" -ItemType SymbolicLink -Target "$TargetDir" -ErrorAction Stop | Out-Null
        if ($Verbose) {
            Write-Host "[Portable Mode] Created symbolic link '$JunctionDir' -> '$TargetDir'." -ForegroundColor Green
        }
    }
}

Function Remove-FolderLink {
    param(
        [string]$JunctionDir,
        [string]$TargetDir,
        [bool]$Verbose = $false
    )
    if ($Verbose) {
        Write-Host ''
        Write-Host "[Portable Mode] Check link '$JunctionDir' -> '$TargetDir'." -ForegroundColor Cyan
    }
    $linkType = (Get-Item -Path $JunctionDir -ErrorAction SilentlyContinue).LinkType
    if (Test-Path $JunctionDir) {
        # only remove junction to $TargetDir
        if ($linkType -eq 'Junction' -or $linkType -eq 'SymbolicLink') {
            if ((Get-Item -Path $JunctionDir).Target -eq $TargetDir) {
                Remove-Item -Path $JunctionDir -Force
                if ($Verbose) {
                    Write-Host "[Portable Mode] Removed link '$JunctionDir'." -ForegroundColor Green
                }
            } elseif ($Verbose) {
                Write-Host "[Portable Mode] Skip '$JunctionDir' (target mismatch)." -ForegroundColor DarkGray
            }
        } elseif ($Verbose) {
            Write-Host "[Portable Mode] Skip '$JunctionDir' (not a link)." -ForegroundColor DarkGray
        }
    } elseif ($Verbose) {
        Write-Host "[Portable Mode] Skip '$JunctionDir' (path not found)." -ForegroundColor DarkGray
    }
}

Function Set-FilesPresent {
    param(
        [string]$BaseDir,
        # array of relative paths,
        [Array]$RelativePaths
    )
    if (-not (Test-Path $BaseDir)) {
        New-Item -Path $BaseDir -ItemType Directory -Force | Out-Null
    }
    foreach ($relativePath in $RelativePaths) {
        $targetPath = Join-Path $BaseDir $relativePath
        $parentDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
        }
        if (-not (Test-Path $targetPath)) {
            New-Item -Path $targetPath -ItemType File | Out-Null
        }
    }
}

Function Set-FoldersPresent {
    param(
        [string]$BaseDir,
        # array of relative paths,
        [Array]$RelativePaths
    )
    foreach ($relativePath in $RelativePaths) {
        $targetPath = Join-Path $BaseDir $relativePath
        if (-not (Test-Path $targetPath)) {
            New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
        }
    }
}

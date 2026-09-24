BeforeAll {
    . "$PSScriptRoot\fs-utils.ps1"
}

Describe 'Folder junction lifecycle' {
    It 'removes a non-empty junction without prompting or deleting persisted data' {
        $target = Join-Path $TestDrive 'persist'
        $link = Join-Path $TestDrive 'appdata'
        New-Item -Path "$target\WebKit\LocalStorage" -ItemType Directory -Force | Out-Null
        Set-Content -LiteralPath "$target\WebKit\LocalStorage\keep.txt" -Value 'profile data'
        New-Item -Path $link -ItemType Junction -Target $target | Out-Null

        Remove-FolderLink -JunctionDir $link -TargetDir $target

        Test-Path -LiteralPath $link | Should -BeFalse
        Get-Content -LiteralPath "$target\WebKit\LocalStorage\keep.txt" | Should -Be 'profile data'
    }

    It 'replaces a non-empty junction without prompting or deleting its old target' {
        $oldTarget = Join-Path $TestDrive 'old-persist'
        $newTarget = Join-Path $TestDrive 'new-persist'
        $link = Join-Path $TestDrive 'relinked-appdata'
        New-Item -Path "$oldTarget\WebKit" -ItemType Directory -Force | Out-Null
        Set-Content -LiteralPath "$oldTarget\WebKit\keep.txt" -Value 'old profile data'
        New-Item -Path $link -ItemType Junction -Target $oldTarget | Out-Null

        Set-FolderLink -JunctionDir $link -TargetDir $newTarget

        (Get-Item -LiteralPath $link).Target | Should -Be $newTarget
        Get-Content -LiteralPath "$oldTarget\WebKit\keep.txt" | Should -Be 'old profile data'
    }
}

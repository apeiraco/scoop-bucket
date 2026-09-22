BeforeAll {
    $manifest = Get-Content "$PSScriptRoot\..\bucket\moonlight-web.json" -Raw | ConvertFrom-Json
    $uninstallScript = [scriptblock]::Create($manifest.uninstaller.script -join "`n")
    # Persistence is exercised by the shared helper; these cases isolate native installation failures.
    $installScript = [scriptblock]::Create(($manifest.installer.script | Select-Object -Skip 3) -join "`n")

    function Invoke-ExternalCommand {
        param([string]$FilePath, [string[]]$ArgumentList, [switch]$RunAs, [hashtable]$ContinueExitCodes)
        throw 'Unexpected native installer invocation'
    }
}

Describe 'MoonlightWeb native installation lifecycle' {
    It 'detaches the native junction during updates without prompting or deleting the native installation' {
        $dir = Join-Path $TestDrive 'update'
        $target = Join-Path $TestDrive 'protected-install'
        New-Item -Path $dir, $target -ItemType Directory -Force | Out-Null
        Set-Content -LiteralPath "$target\keep.txt" -Value 'native installation'
        New-Item -Path "$target\assets" -ItemType Directory | Out-Null
        Set-Content -LiteralPath "$target\assets\keep.txt" -Value 'native assets'
        New-Item -Path "$dir\native" -ItemType Junction -Target $target | Out-Null
        $cmd = 'update'

        & $uninstallScript

        Test-Path -LiteralPath "$dir\native" | Should -BeFalse
        Get-Content -LiteralPath "$target\keep.txt" | Should -Be 'native installation'
        Get-Content -LiteralPath "$target\assets\keep.txt" | Should -Be 'native assets'
    }

    It 'refuses to delete a regular directory in place of the native junction' {
        $dir = Join-Path $TestDrive 'unexpected-layout'
        New-Item -Path "$dir\native" -ItemType Directory -Force | Out-Null
        Set-Content -LiteralPath "$dir\native\keep.txt" -Value 'user data'
        $cmd = 'update'

        { & $uninstallScript } | Should -Throw '*unexpected native path*'

        Get-Content -LiteralPath "$dir\native\keep.txt" | Should -Be 'user data'
    }

    It 'fails before creating a junction and restores USERDOMAIN when native setup fails' {
        $dir = Join-Path $TestDrive 'failed-install'
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
        $originalDomain = $env:USERDOMAIN
        Mock Invoke-ExternalCommand { $false }

        { & $installScript } | Should -Throw '*native installation failed*'

        Test-Path -LiteralPath "$dir\native" | Should -BeFalse
        $env:USERDOMAIN | Should -Be $originalDomain
        Should -Invoke Invoke-ExternalCommand -Exactly 1 -ParameterFilter {
            $RunAs -and ($ArgumentList -contains '/NORESTART')
        }
    }
}

Describe 'MoonlightWeb persistence helper lookup' {
    BeforeAll {
        $fullInstallScript = [scriptblock]::Create($manifest.installer.script -join "`n")
    }

    BeforeEach {
        $bucketsdir = Join-Path $TestDrive 'buckets'
        $helperDir = Join-Path $bucketsdir "$SourceBucket\bin"
        New-Item -Path $helperDir -ItemType Directory -Force | Out-Null
        Set-Content -LiteralPath "$helperDir\persist-utils.ps1" -Value "throw 'Expected persistence helper loaded'"
        $dir = Join-Path $TestDrive 'app'
        $bucket = $BucketName
    }

    It 'loads the installer helper from <SourceBucket> for bucket <BucketName>' -TestCases @(
        @{ BucketName = 'apeiraco'; SourceBucket = 'apeiraco' }
        @{ BucketName = 'dumtruck'; SourceBucket = 'dumtruck' }
        @{ BucketName = $null; SourceBucket = 'apeiraco' }
    ) {
        param($BucketName, $SourceBucket)

        { & $fullInstallScript } | Should -Throw '*Expected persistence helper loaded*'
    }

    It 'loads the uninstaller helper from <SourceBucket> for bucket <BucketName>' -TestCases @(
        @{ BucketName = 'apeiraco'; SourceBucket = 'apeiraco' }
        @{ BucketName = 'dumtruck'; SourceBucket = 'dumtruck' }
        @{ BucketName = $null; SourceBucket = 'apeiraco' }
    ) {
        param($BucketName, $SourceBucket)
        $cmd = 'uninstall'
        Mock Invoke-ExternalCommand { throw 'Unexpected native uninstaller invocation' }
        Mock Test-Path { $false } -ParameterFilter {
            $LiteralPath -eq (Join-Path $env:ProgramFiles 'MoonlightWeb\unins000.exe')
        }

        { & $uninstallScript } | Should -Throw '*Expected persistence helper loaded*'
        Should -Invoke Invoke-ExternalCommand -Exactly 0
    }
}

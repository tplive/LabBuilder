$Global:InvokeTestRoot = $PSScriptRoot

# Check Pester Installed
if (-not (Get-Module -Name Pester -ListAvailable))
{
    Install-Module -Name Pester -Force
}
Import-Module -Name Pester -Force

# Check Cidney Installed
if (-not (Get-Module -Name Cidney -ListAvailable))
{
    Install-Module -Name Cidney -Force
}
Import-Module -Name Cidney -Force

pipeline: CidneyBuild {
    Stage: UnitTests {
        $TestFiles = Get-ChildItem -Path $Global:InvokeTestRoot -Filter "*.tests.ps1" -Recurse
        foreach ($TestFile in $TestFiles)
        {
            Do: {
                $TestFilePath = $TestFile.FullName
                Write-Verbose -Verbose "Running Unit tests from '$TestFilePath'"
                $TestResults = Invoke-Pester `
                    -Script $TestFilePath `
                    -ExcludeTag Incomplete `
                    -PassThru
                Write-Verbose -Verbose "Completed Unit tests from '$TestFilePath'"
            } -MaxThreads 2
        }
    }
} -Invoke -Verbose

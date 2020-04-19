1..4 | % {
    if (!$isCoreCLR -or $isWindows) {
        rm -Force "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\mod$_" -Recurse -EA SilentlyContinue
        cp "$PSScriptRoot\assets\mod$_" -Recurse C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\ -Force
    }
    else {
        sudo rm -rf "/opt/microsoft/powershell/7-preview/Modules/mod$_"
        sudo cp -rf "/mnt/c/Windows/system32/WindowsPowerShell/v1.0/Modules/mod$_"  /opt/microsoft/powershell/7-preview/Modules/
    }
}

break
if (!$isCoreCLR) {
    # forcing 1.1 version when on Windows PowerShell
    Import-Module -Force PSDesiredStateConfiguration -RequiredVersion 1.1
}

$uname = if (Get-Command -ErrorAction SilentlyContinue uname) { uname } else { "Windows"; $Error.Remove($Error[0]) }

# Gather data from modules (DSC resources available, error raised when doing get-dscresource)
$results = 1..4 | Foreach-Object {
    $MyModuleName = "mod$_"
    $resources = get-DscResource -Module $MyModuleName -ev err -ea 0
    [PSCustomObject]@{
        test      = $MyModuleName
        OS        = $uname
        PSVersion = $PSVersionTable.PSVersion
        PSDSC     = (Get-Module PSDesiredStateConfiguration).Version
        Resources = $resources.Name -join ', '
        Error     = $err.Exception.Message
        Count     = $resources.count
    }
    $err.Clear()
}

# Display results
$results | FT -AutoSize

## Try the Invoke-DscResource (windows only for now)
# if (!$isCoreCLR -or $isWindows) {

    if (!$isCoreCLR) {
        remove-module PSDesiredStateConfiguration
        Import-Module PSDesiredStateConfiguration -RequiredVersion 1.1 -Force
    }
    else {
        remove-module PSDesiredStateConfiguration
        Import-Module PSDesiredStateConfiguration -Force
    }

    # CimCmdlets only on Windows
    # $cimInstance = New-CimInstance -ClassName ClassSubType `
    #     -Namespace root/microsoft/Windows/DesiredStateConfiguration `
    #     -Property @{Property1 = 'test' } `
    #     -ClientOnly
    $cimInstance = [Microsoft.Management.Infrastructure.CimInstance]::new("ClassSubType",'root/microsoft/Windows/DesiredStateConfiguration')
    $cimProperty1 = [Microsoft.Management.Infrastructure.CimProperty]::Create('Property1','test', [cimtype]::String, [Microsoft.Management.Infrastructure.CimFlags]::none)
    $cimInstance.CimInstanceProperties.Add($cimProperty1)

    $InvokeDscrParam = @{
        Name     = 'ClassRsrcWithSubType'
        Property = @{
            Ensure          = 'present'
            Name            = 'present'
            SubTypeProperty = $cimInstance
        }
    }

    BREAK
    # NOT TRUE ANYMORE I THINK
    # other version has moduleName param and not Module (5.1) <- my bad :)
    if ($isCoreCLR) {
        $InvokeDscrParam.Add('Module', 'mod1')
    }
    else {
        $InvokeDscrParam.Add('ModuleName', 'mod1')
    }

    $GetResult = Invoke-DscResource @InvokeDscrParam `
        -Method Get -ev ErrGet -EA SilentlyContinue
    # $GetResult.SubTypeProperty.property1 | Should -be 'plop'

    $SetResult = Invoke-DscResource @InvokeDscrParam `
        -Method Set -ev ErrSet -EA SilentlyContinue

    # $SetResult.RebootRequired | Should -be $false

    $TestResult = Invoke-DscResource @InvokeDscrParam `
        -Method test -ev ErrTest -EA SilentlyContinue

    # $TestResult.InDesiredState | Should -be $true

    [PSCustomObject]@{
        OS        = $uname
        PSVersion = $PSVersionTable.PSVersion
        PSDSC     = (Get-Module PSDesiredStateConfiguration).Version
        Get_Worked  = ($GetResult.SubTypeProperty.Property1 -eq 'plop')
        Set_worked  = ($SetResult.RebootRequired -eq $false)
        Test_Worked = ($TestResult.InDesiredState -eq $true)
    } | FT -AutoSize

# }

if (!$isCoreCLR) {
    pwsh-preview -file $PSScriptRoot\quick_test.ps1
}
elseif ($isWindows -and $isCoreCLR -and (get-command wsl)) {
    wsl pwsh-preview -file "/mnt/c/$($PSScriptRoot -replace 'C:\\' -replace '\\','/')/quick_test.ps1"
}

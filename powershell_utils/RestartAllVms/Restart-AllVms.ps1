#
#
# Utility Script that removes all the virtual machines asynchronosouly
#
#

Set-Location -Path $PSScriptRoot
# Login-AzureRmAccount

$SkipList = $null, $null, "devVm0", "devVm1", "devVm2", "devVm3"
Write-Host ("Geting list of virtual machines in subscription...`n")

$VirtualMachines = Get-AzureRmVM | Where-Object {$SkipList -notcontains $_} 

if ($VirtualMachines.Count -gt 0) {
    $VmRgNames = @()
    $caption = ("`tRestarting these virtual machines:")

    foreach ($VirtualMachine in $VirtualMachines) {
        $caption += ("`n`t`t{0} ({1})" -f $VirtualMachine.Name, $VirtualMachine.ResourceGroupName)
        $VmRgNames += ("{0}" -f $VirtualMachine.Id)
    }

    $message = "Are you Sure You Want To Proceed:"
    [int]$defaultChoice = 0
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Start all listed virtual machines."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Cancel."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $choiceRTN = $host.ui.PromptForChoice($caption, $message, $options, $defaultChoice)
    if ( $choiceRTN -ne 1 ) {
        .\Run-CommandMultiThreaded.ps1 -Command Restart-Vm.ps1 -ObjectList $VmRgNames
    }
    else {
        Write-Host ("`nCancelled`n`tNothing restarted.")
    }
}
else {
    Write-Host ("`tThere are not virtual machines except those in SkipList:")
    foreach ($Skip in $SkipList) {
        if ($Skip -ne $null) {
            Write-Host ("`t`t{0}" -f $Skip)
        }
    }
}
Write-Host ("`nExitting.`n")
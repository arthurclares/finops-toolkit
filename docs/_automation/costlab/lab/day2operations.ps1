# Install the Azure PowerShell module if it's not already installed
# Install-Module -Name Az -AllowClobber -Scope CurrentUser

# Import the Azure PowerShell module
#Import-Module Az

# Connect to your Azure account (this will prompt you to log in)
#Connect-AzAccount

# Define the resource group and disk name
$resourceGroupName = "yourResourceGroupName"
$diskName = "yourDiskName"

# Define the tag to search for
$VMtagName = "Status"
$VMtagValue = "PowerOff"
$DiskTagName = "Job"
$DiskTagValue= "TakeSnapshot"


# Perform the ARG query to find the VM with the specified tag
$queryVM = "Resources | where type =~ 'microsoft.compute/virtualmachines' | where tags['$VMtagName'] == '$VMtagValue' | project id, name, resourceGroup"
# Perform the ARG query to find Disks to take snapshot
$queryDisk =  "Resources | where type =~ 'microsoft.compute/disks' | where tags['$DiskTagName'] == '$DiskTagValue' | project id, name, resourceGroup,location,subscriptionId"
# Run VM query
$vms = Search-AzGraph -Query $queryVM 
# Run Disk query
$disks = Search-AzGraph -Query $queryDisk

# Check if VM is found
foreach ($vm in $vms) {
    if ($vm) {
        # Stop the VM without deallocating it
        Stop-AzVM -ResourceGroupName $vm.resourceGroup -Name $vm.name -StayProvisioned -Force
        Write-Output "VM $($vm.name) in resource group $($vm.resourceGroup) is powered off."
    } else {
        Write-Output "No VM with the tag $tagName = $tagValue found."
    }
}



# Check if VM is found
foreach ($disk in $disks) {
    if ($disk) {
        $diskResourceGroupName=$disk.resourceGroup
        $diskName=$disk.name
        $diskLocation=$disk.location
        $sourceUri =$disk.ResourceId
        # Create a snapshot configuration
        $snapshotConfig = New-AzSnapshotConfig -SourceUri $sourceUri -Location $diskLocation -CreateOption Copy -SkuName Premium_LRS
        # Write-Output "Snapshot configuration created $snapshotConfig created successfully."
        # Take a snapshot 
        New-AzSnapshot -ResourceGroupName $diskResourceGroupName -SnapshotName "$($diskName)-snapshot2" -Snapshot $snapshotConfig
        Write-Output "Snapshot created successfully."
    } else {
        Write-Output "No Disk with the tag $tagName = $tagValue found."
    }
}
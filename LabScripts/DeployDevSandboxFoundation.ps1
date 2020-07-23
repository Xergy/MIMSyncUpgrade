$instance = "02" #<2 Char
$Prefix = "md" #<2 Char
$Env = "dev" # <4 Char
$EnvShortNane = "d" # <1 Char
$location = "usgovtexas"
$LocationShortName = "tx" # <2 Char 
$Purpose = "msu" # Design Sandbox
$resourceGroup = "$($Prefix)-$($Env)-$($LocationShortName)-$($Purpose)-$($instance)-rg"

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location 

# Network pieces
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "$($Purpose)-01-subnet" -AddressPrefix 192.168.1.0/24 
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name "$($Prefix)-$($Env)-$($LocationShortName)-$($Purpose)-$($instance)-vnet" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig 

# Storage Account and container
New-AzStorageAccount  -ResourceGroupName $resourceGroup -Location $location -Name "$($Prefix)$($EnvShortName)$($LocationShortName)$($Purpose)$($instance)diag"  -SkuName Standard_LRS
$Sa = Get-AzStorageAccount  -ResourceGroupName $resourceGroup -Name "$($Prefix)$($EnvShortName)$($LocationShortName)$($Purpose)$($instance)diag"
$Sa | New-AzStorageContainer "vhds"
$Container = $Sa | Get-AzStorageContainer -Name "vhds"

# Deploy Recover Vault for backup
Register-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"

New-AzRecoveryServicesVault -Name "$($Prefix)-$($Env)-$($LocationShortName)-$($Purpose)-rsv" -ResourceGroupName $resourceGroup -Location $location 
$Vault = Get-AzRecoveryServicesVault –Name "$($Prefix)-$($Env)-$($LocationShortName)-$($Purpose)-rsv"
Set-AzRecoveryServicesBackupProperties -Vault $Vault -BackupStorageRedundancy LocallyRedundant










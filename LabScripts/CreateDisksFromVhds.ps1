$Sub = Get-AzSubscription | Out-GridView -Title "Select Sub" -OutputMode Single
If ($Null -eq $Sub) {Write-Host "Exiting - No Subs..."; exit }
If( (Get-AzContext).Subscription.Id -ne $Sub.SubscriptionId  ) { Set-Azcontext -SubscriptionId $Sub.SubscriptionId | Out-Null}

$SourceStorageAccount = $Sub | ForEach-Object { 
      $_ | Set-AzContext | Out-Null      
      Get-AzStorageAccount    
   } | Out-GridView -Title "Select Source Storage Account" -OutputMode Multiple 
If ($Null -eq $SourceStorageAccount ) {Write-Host "Exiting - No SA..."; exit }

$SourceSAContainer =  $SourceStorageAccount | Get-AzStorageContainer | Out-GridView -Title "Select Source Container to search for Vhds" -OutputMode Single
If ($Null -eq $SourceSAContainer ) {Write-Host "Exiting - No Container..."; exit }

$SourceStorageAccountId = $SourceStorageAccount.id

$Location = $SourceStorageAccount.Location

$Vhds = $SourceSAContainer  | Get-AzStorageBlob | Out-GridView -Title "Select Source VHDs" -OutputMode Multiple
If ($Null -eq $Vhds) {Write-Host "Exiting - No Vhds..."; exit }

$TargetResourceGroup = Get-AzResourceGroup | Out-GridView -Title "Select Target Resource Group" -OutputMode Single
If ($TargetResourceGroup -eq $Vhds) {Write-Host "Exiting - No Target RG..."; exit }
$TargetResourceGroupName = $TargetResourceGroup.ResourceGroupName

$Jobs  = $Vhds | ForEach-Object {
   $CurrentVhd = $_
   $SourceVhdURI = $CurrentVhd.ICloudBlob | ForEach-Object { $_.Uri.AbsoluteUri }
   $StorageType = 'Standard_LRS'
   $DiskConfig = New-AzDiskConfig -AccountType $StorageType -Location $Location -CreateOption Import -StorageAccountId $SourceStorageAccountId  -SourceUri $SourceVhdURI
   $TargetDiskName = $CurrentVhd.Name | ForEach-Object {     
         If ($_ -like "*.vhd*") { ($_ -split '.vhd')[0]
         }  Else { 
            $_ 
         }
      }
   New-AzDisk -Disk $DiskConfig -ResourceGroupName $TargetResourceGroupName -DiskName $TargetDiskName -AsJob 
} 

Write-Host "Waiting on Copy Jobs to finish up..."
$Jobs | Wait-Job | Out-Null
$Results = $Jobs | Receive-Job -Keep
$Jobs = $Jobs | Remove-Job
$Results 
Write-Host "Done!"

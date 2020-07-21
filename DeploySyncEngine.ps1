
$MIMDeployPath = 'C:\AzMIMDeployStage\Files'

#Deploy MIM Sync
$ArgumentListString = $Null
$ArgumentListString +=  "/q /i ""$MIMDeployPath\MIM\Install\Synchronization Service\Synchronization Service.msi"" "
$ArgumentListString += "ACCEPT_EULA=1 " 
$ArgumentListString += "SQLServerStore=RemoteMachine "
$ArgumentListString += "STORESERVER=SQLMIMSync "
$ArgumentListString += "SQLDB=SQLMIMSync "
#$ArgumentListString += "SQLINSTANCE=MIMINSTANCE "
$ArgumentListString += "SERVICEACCOUNT=MIMSync "
$ArgumentListString += 'SERVICEPASSWORD=<ReplaceWithPassword> '
$ArgumentListString += "SERVICEDOMAIN=CORP "
$ArgumentListString += "GROUPADMINS=CORP\MIMSyncAdmins "
$ArgumentListString += "GROUPOPERATORS=CORP\MIMSyncOperators "
$ArgumentListString += "GROUPACCOUNTJOINERS=CORP\MIMSyncJoiners "
$ArgumentListString += "GROUPBROWSE=CORP\MIMSyncBrowse "
$ArgumentListString += "GROUPPASSWORDSET=CORP\MIMSyncPasswordSet "
$ArgumentListString += "FIREWALL_CONF=1 "
$ArgumentListString += "/L*v ""C:\DeployMIMSync.txt"" /qf"

$ArgumentListString

$InstallExitCode = $null
$InstallExitCode = (Start-Process "msiexec" -ArgumentList $ArgumentListString -wait -PassThru).ExitCode

if ($InstallExitCode -eq 0){
    “Installation Successful”
} else {
    “Installation Failed with code $InstallExitCode – check Windows Event Viewer for errors”
}
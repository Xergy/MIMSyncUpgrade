# Deployment Overview and Quick Notes

## Upgrade Summary:

### Phase 1: Prepare Staging Servers

1. Quickly stand up a Marketplace SQL Server (Let's not worry too much on VM Config) 
   > We used the below script:  
   > ```Install-WindowsFeature Net-Framework-Features,Xps-Viewer,Telnet-Client,RSAT-Clustering,RSAT-AD-Tools,rsat-ad-powershell,RSAT-ADCS-Mgmt,RSAT-DNS-Server,RSAT-ADCS-Mgmt -includeallsubfeature```
2. Deploy MIM Sync Pre-reqs <- Rocky
3. Deploy MIM Greenfield 
4. Patch MIM
5. Uninstall MIM Sync
6. Copy over Existing DBs
7. Reinstall using existing DBs for Upgrade
8. Patch
9. Perform any Post install tasks
   > - Add Updated DLLs - when ready
   > - Copy over MAData and review Extensions folder
10. Remove Export Run profiles
11. Test no export Syncs

### Phase 2: Visual Studio Efforts

1. Install VS 2017, 2019?
2. Attempt to open and re-compile old projects <- Rocky
3. Explore creating a project directly from the Sync Engine
4. Compare default project to upgraded project, references etc...
5. Add new DLLs to Staging server for Sync testing

### Phase 3: Prepare Production Server

1. Keep rebuilding and tweaking automation until VMs results are good.
2. Deploy MIM Sync Pre-reqs
3. Deploy MIM Greenfield 
4. Patch MIM
5. Uninstall MIM Sync
6. Perform Upgrade
7. Patch
8. Perform any post upgrade tasks
   > - Add Updated DLLs - when ready
   > - Copy over MAData and review Extensions folder
10. Remove Export Run profiles <- Important
10. Test no export Syncs

### Phase 4: Go Live - Cut Over Testing

1. Backup recent Production DBs
2. Upgrade/Patch on Staging server
3. Backup Staging Server
4. Stop Any MIM Services on New Prod
4. Restore Staging Server Backups to our "NProd" Server
5. Test No-Export Syncs

## Additional Helpful Notes and Tips

### Code Snips

#### Install Windows Server Pre-Reqs
```
Install-WindowsFeature Net-Framework-Features,Xps-Viewer,Telnet-Client,RSAT-Clustering,RSAT-AD-Tools,rsat-ad-powershell,RSAT-ADCS-Mgmt,RSAT-DNS-Server,RSAT-ADCS-Mgmt -includeallsubfeature
```

#### Check for Readonly on install files
```
get-childitem *.cs -Recurse -File | Select-Object Name,IsReadOnly | fT *
```

#### Set MIM Sync to start after SQL
```
sc config FIMSynchronizationService depend= winmgmt/MSSQLSERVER
```

#### MiisActivate Syntax
```
miisactivate C:\samplepath oir\fimSA *
```

### Steps to deploy Oracle Client:

1. Download the x64 Oracle 12c client (if not present)
2. Extract the zip file
3. Run setup.exe
4. Choose "Runtime" as the install option.
5. Built-in Account
6. Set the base install path to C:\Oracle
7. Complete the installation
8. Copy the tnsnames.ora and sqlnet.ora files to:\Oracle\product\12.2.0\client_1\network\admin\

## Important Links:

#### Xergy/MIMSyncUpgrade
https://github.com/Xergy/MIMSyncUpgrade/

#### Set up an identity management server: Windows Server 2016 or 2019
https://docs.microsoft.com/en-us/microsoft-identity-manager/prepare-server-ws2016

#### Identity Manager version release history
https://docs.microsoft.com/en-us/microsoft-identity-manager/reference/version-history

#### lithnet/miis-powershell
https://github.com/lithnet/miis-powershell

#### FIM 2010 R2: How to Make a Connection to Oracle Database 11g
https://social.technet.microsoft.com/wiki/contents/articles/18548.fim-2010-r2-how-to-make-a-connection-to-oracle-database-11g.aspx

#### FIM/MIM Troubleshooting: synchronization service does not start and "computer_id in the database does not match this computer" error
https://social.technet.microsoft.com/wiki/contents/articles/36920.fimmim-troubleshooting-synchronization-service-does-not-start-and-computer-id-in-the-database-does-not-match-this-computer-error.aspx

#### MIM/FIM Troubleshooting: Sync service terminated with service-specific error %%-2146234334 (Primary Server)
https://social.technet.microsoft.com/wiki/contents/articles/51516.mimfim-troubleshooting-sync-service-terminated-with-service-specific-error-2146234334-primary-server.aspx

#### Clone Azure Virtual Machine (Az.CloneVirtualMachine)
https://github.com/J0R3D1N/Az.CloneVirtualMachine

#### Nuke Run History.ps1
https://github.com/Xergy/Nuke-RunHistory/blob/master/Nuke%20Run%20History.ps1

#### SQL Optimization In PowerShell (Rebuilding / Reorganizing Indexes & Heaps)
https://gallery.technet.microsoft.com/scriptcenter/SQL-Optimization-In-95d12ce6

#### SQL Optimization In PowerShell (Rebuilding / Reorganizing Indexes & Heaps)
https://gallery.technet.microsoft.com/scriptcenter/SQL-Optimization-In-95d12ce6

#### Resolve index fragmentation by reorganizing or rebuilding indexes
https://docs.microsoft.com/en-us/sql/relational-databases/indexes/reorganize-and-rebuild-indexes?view=sql-server-ver15

#### FIM Troubleshooting: Installation Error 25009 (SA admin rights missing)
https://social.technet.microsoft.com/wiki/contents/articles/1734.fim-troubleshooting-installation-error-25009-sa-admin-rights-missing.aspx#:~:text=Error%2025009%3A%20The%20Forefront%20Identity%20Manager%20Synchronization%20Service,Microsoft%20SQL%20Server%20is%20a%20remote%20SQL%20Server



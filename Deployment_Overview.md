# Deployment Overview

## Steps:

### Prep Staging Servers

1. Quickly stand up a Marketplace SQL Server (Let's not worry too much on VM Config) <- Rocky
2. Deploy MIM Sync Pre-reqs <- Rocky
3. Deploy MIM Greenfield 
4. Patch MIM
5. Uninstall MIM Sync
6. Copy over Existing DBs
7. Reinstall using existing DBs for Upgrade
8. Patch
9. Perform any Post install tasks
   > Add Updated DLLs - when ready
10. Remove Export Run profiles
11. Test no export Syncs

### Visual Studio Efforts

1. Install VS 2017, 2019?
2. Attempt to open and re-compile old projects <- Rocky
3. Explore creating a project directly from the Sync Engine
4. Compare default project to upgraded project, references etc...
5. Add new DLLs to Staging server for Sync testing

### Prep Production Server

1. Keep rebuilding and tweaking automation until VMs results are good.
2. Deploy MIM Sync Pre-reqs
3. Deploy MIM Greenfield 
4. Patch MIM
5. Uninstall MIM Sync
6. Perform Upgrade
7. Patch
8. Perform any post upgrade tasks
10. Remove Export Run profiles <- Important
10. Test no export Syncs

### Cut Over Testing

1. Backup recent Production DBs
2. Upgrade/Patch on Staging server
3. Backup Staging Server
4. Stop Any MIM Services on New Prod
4. Restore Staging Server Backups to our "NProd" Server
5. Test No-Export Syncs

### Bonus

1. Configure Powershell Run Profile Scripts
2. Configure Automated SQL Backups <- Rocky





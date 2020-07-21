# Deployment Steps Summary

## Abstract

[comment]: # (TODO: Add Deployment Abstract Content)

## Detailed Steps

### Provision Necessary Infrastructure

1.  Active Directory

2.  Email Infrastructure i.e. Exchange or cloud bases email

3.  Enterprise CA or equivalent for Certificates

4.  Azure Network, Automation, and monitoring foundational components

5.  SQL Always On Cluster

###  Review Noteworthy Gotchas and Know Issues:

1.  Almost all FIM documentation is applicable to MIM deployment

2.  .Net 3.5 framework may require Windows media to install

3.  SharePoint Pre-reqs are difficult to install offline. Do some research
    before attempting.  
    <https://blogs.technet.microsoft.com/cjrawson/2014/04/06/offline-installation-no-internet-connection-of-sharepoint-2013-sp1-prerequisites-on-windows-server-2012-r2/>

4.  SharePoint will fail to install if the security option for FIPS is
    turned on.

5.  When in doubt of networking configuration, turn the Windows Firewall off
    temporality

6.  MIMMA account must be a member of the Sync Engine Administrators group
    to create the MIM MA.

7.  Don’t update .Net to 3.6 until SharePoint is installed

8.  Important install links to review before deployment  
    <https://technet.microsoft.com/en-us/library/hh322905(v=ws.10).aspx>  
    <https://docs.microsoft.com/en-us/microsoft-identity-manager/deploy-use/microsoft-identity-manager-deploy>  
    <https://technet.microsoft.com/en-us/library/jj134309(v=ws.10).aspx>  
    <http://www.harbar.net/articles/fimportal.aspx>

9.  Kerberos Authentication Specific Links:  
    <http://social.technet.microsoft.com/wiki/contents/articles/4118.fim-2010-r2-kerberos-authentication-setup.aspx#Password_Registration_Site_amp_Password_Reset_Site>  
    <http://social.technet.microsoft.com/wiki/contents/articles/3385.fim-2010-kerberos-authentication-setup.aspx>

### Deploy VMs

1.  At least 4 dedicated to MIM Deployment.

2.  Join to the Domain (Script Provided)

3.  Install .Net binaries from features 

### Prepare the domain

1.  Create User Accounts (Script Provided)

2.  Create Groups (Script Provided)

    a.  Add MIMAdmin to MIM Sync Admins Group 

3.  Set SPNs and Delegations (Script Provided) 
    <http://social.technet.microsoft.com/wiki/contents/articles/4118.fim-2010-r2-kerberos-authentication-setup.aspx#Password_Registration_Site_amp_Password_Reset_Site>

[comment]: # (TODO: Find new link for below) 

4.  Configure Group Policy for MIM Servers  
    <https://docs.microsoft.com/en-us/microsoft-identity-manager/preparing-domain>

5.  Create DNS Records (Script Provided)

6.  Valid DNS Records for web endpoints are in the Intranet IE Zone

7.  Create Group Policy for MIM Server OU

    - Secure MIM Accounts  
      <https://docs.microsoft.com/en-us/microsoft-identity-manager/deploy-use/prepare-server-ws2012r2>  
      <https://technet.microsoft.com/en-us/library/hh322882(v=ws.10).aspx>

[comment]: # (TODO: Find new link for above) 

### Deploy SQL

1.  Full-Text Search is required on the Instance

2.  Validate SQL Server Agents runs automatically

3.  Valid open port to SQL Server

4.  Typically TCP 445,1433 and UDP 1434  
    <https://technet.microsoft.com/en-us/library/hh322882(v=ws.10).aspx>

5.  IMPORTANT: Add Login for CORP MIMSPFarm account. Set to dbcreator,
    public, securityadmin

### Deploy/Configure Email

1.  Configure Mailbox for MIM Service Account  
    https://technet.microsoft.com/en-us/library/hh322882(v=ws.10).aspx

### Deploy SharePoint on MIM Portal Nodes

1.  Request and Save Required Certificates to Portal Computer Certificate Store (Script Provided)

2.  Disable Loopback Checking and Reboot (Script Provided)

3.  Install SQL Native client x64 

4.  Create required SQL Alias 

5.  Un-pack Sharepoint files

6.  Acquire and Install SharePoint Pre-Reqs 

7.  Install SharePoint binaries (Setup.exe)

    a.  Run Setup.exe, and select Complete, Install Now

    b.  Uncheck **Run the SharePoint product configuration wizard now**,
        then close

    c.  DO NOT RUN THE CONFIGURATION WIZARD.

8.  Patch SharePoint. Be patient, this take a while.

9.  Deploy Farm (Script Provided)

10. Deploy Web App (Script Provided)

11. Validate Team site is reachable

###  Deploy First Sync Service

1.  Create required SQL Alias (Script Provided)

2.  Install SQL Native Client 

3.  Add MIMMA and MIMService account to Local Admins Group

4.  Deploy Sync Service (Script Provided)

    a.  If upgrading, provide encryption key during setup

5.  Patch Sync Service

6.  Stop Sync Service

### Deploy Second Sync Server

1.  Create required SQL Alias (Script Provided)

2.  Install SQL Native Client

3.  Add MIMMA and MIMService account to Local Admins Group

    a.  You can avoid adding the MIMService Account to the Admin group by
        following guidance in the below article:  
        <https://technet.microsoft.com/en-us/library/jj134282(v=ws.10).aspx#step_3>

4.  Deploy Sync Service (Script Provided)

    a.  If upgrading, provide encryption key during setup

5.  Patch Sync Service

### Configure Sync Server Failover

1.  Test re-activating First Sync server node with miisactivate.exe  
    <https://technet.microsoft.com/en-us/library/jj590194(v=ws.10).aspx>

2.  Test Re-activating Second Sync Server with miisactivate.exe

### Deploy MIM Portals and Services

1.  Install MIM Portal and SSPR (Script Provided)

2.  Fix-Up Bindings/hostname to allow SSL connections to multiple sites on
    TCP 443

3.  Valid Firewall allows access to port 5725 and 5726.

4.  Validate all sites are operations on the server and off box

### Install MIM WAL

1.  Deploy MIM WAL on MIM Portal and MIM Service Nodes

### Post Installation Tasks

1.  Disable SharePoint Indexing  
    <https://technet.microsoft.com/en-us/library/hh322875(v=ws.10).aspx>

2.  If upgrading, validate SQL jobs are present on the SQL instance where
    the MIM Service is installed.

3.  If your solution has a configuration at this point

    a.  Validate connection settings in the Sync Engine for each MA. For
        example, the MIM MA might point to the old MIM Service Location.

    b.  Disable able any portal related PowerShell Workflows that might
        reach off box, while testing.

    c.  Validate sync’s without exporting

### Deploy MIM Staging Server

1.  Re-apply applicable steps above to build a replica of the deployment on
    a single server

2.  Scripts are provided to properly install SharePoint and MIM

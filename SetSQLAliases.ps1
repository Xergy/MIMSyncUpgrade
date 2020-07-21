function Clear-SQLAliases { 
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')] 
  param 
  ( 
  ) 
  process { 
    $x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
    $x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
    Clear-Item $x86 -ErrorAction SilentlyContinue
    Clear-Item $x64 -ErrorAction SilentlyContinue

  } 
}

function Create-SQLAlias { 
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')] 
  param 
  ( 
    [Parameter(Mandatory=$True)] 
    [string]$ServerName,         
    [string]$AliasName
  ) 
  process { 
    $x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
    $x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"

    #We're going to see if the ConnectTo key already exists, and create it if it doesn't.

    if ((test-path -path $x86) -ne $True)
        {
            New-Item $x86
        }
    if ((test-path -path $x64) -ne $True)
        {
            New-Item $x64
        }
    
    $TCPAlias = "DBMSSOCN," + $ServerName

    #Creating our TCP/IP Aliases
    New-ItemProperty -Path $x86 -Name $AliasName -PropertyType String -Value $TCPAlias 
    New-ItemProperty -Path $x64 -Name $AliasName -PropertyType String -Value $TCPAlias

  } 
}

Clear-SQLAliases

Create-SQLAlias -ServerName "MDDMIMSG\MIMInstance" -AliasName "SQLMIMSharePoint"
Create-SQLAlias -ServerName "MDDMIMSG\MIMInstance" -AliasName "SQLMIMService"
Create-SQLAlias -ServerName "MDDMIMSG\MIMInstance" -AliasName "SQLMIMSync"
############ 
# PARAMETERS 
############

$params_ComputerName = "." # "." is the current computer 
$params_delayBetweenExecs = 5 #delay between each execution, in seconds

############ 
# FUNCTIONS 
############

function Run-MA 
{PARAM([string]$maName,[string]$runProfile) 
   $MAs = @(Get-WmiObject ` 
   -class "MIIS_ManagementAgent" ` 
   -Namespace "root\MicrosoftIdentityIntegrationServer" ` 
   -ComputerName ".")

   foreach($MA in $MAs) 
   { 
      if($MA.Name.Equals($maName)) 
      { 
         $result = $MA.Execute($runProfile) 
      } 
   } 
}

$SynchronousRun = {function Run-MAsynchronous 
   {PARAM([string]$maName,[string]$runProfile) 
      $MAs = @(Get-WmiObject ` 
      -class "MIIS_ManagementAgent" ` 
      -Namespace "root\MicrosoftIdentityIntegrationServer" ` 
      -ComputerName ".") 
      $maNameArray = $maName.split(",") 
      foreach($singleMA in $maNameArray) 
      {  
         foreach($MA in $MAs) 
         { 
            if($MA.Name.Equals($singleMA)) 
            { 
               $results = $MA.Execute($runProfile) 
            } 
         } 
      } 
   } 
}

############ 
# PROGRAM 
############

start-job {Run-MAsynchronous -maName "FIM" -runProfile "FI"} -InitializationScript $SynchronousRun 
Start-Job {Run-MAsynchronous -maName "AD" -runProfile "FI"} -InitializationScript $SynchronousRun 

Get-Job | Wait-Job

Run-MA -maName "FIM" -runProfile "FS" 
Run-MA -maName "AD" -runProfile "FS" 

start-job {Run-MAsynchronous -maName "FIM" -runProfile "EX"} -InitializationScript $SynchronousRun 
#start-job {Run-MAsynchronous -maName "AD" -runprofile "EX"} -InitializationScript $SynchronousRun 

Get-Job | Wait-Job

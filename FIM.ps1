
$userDefinedPath = Read-Host -Prompt "Enter Path of the File you would like to monitor"

Write-Host ""
Write-Host "What would you Like to do?"
Write-Host ""
Write-Host "A). Collect new BaseLine"
Write-Host "B). Begin Monitoring files with existing Baseline"
Write-Host ""

Function Calculate-File-Hash($userDefinedPath){
    $fileHash = Get-ChildItem $userDefinedPath -Recurse -File | Get-FileHash -Algorithm SHA256
    return $fileHash
}

$response = Read-Host -Prompt "Please Enter Option A or B"

Function Erase-Baseline-If-Already-Exists(){
    $baselineExists = Test-Path -Path $userDefinedPath\baseline.txt
    
    if($baselineExists){
        #Delete file baseline.txt
        Remove-Item -Path $userDefinedPath\baseline.txt
    }
}


if($response -eq "A".ToUpper()){
    #Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    #Calculate Hash From the target files and store in baseline.txt
    Write-Host 'Calculate Hashes, make new baseline.txt?'

    #Collect all files in the target folder
    $files = Get-ChildItem -Path $userDefinedPath 
    

    #for each file , calculate the hash, and write to baseline.txt
    foreach($f in $files){
       $hash = Calculate-File-Hash $f.FullName
       "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $userDefinedPath\baseline.txt -Append
    }
}

elseif($response -eq "B".ToUpper()){
    #Empty Dictionary 
    $fileHashDictionary =@{}
    #Load File | hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path $userDefinedPath\baseline.txt
    foreach($f in $filePathsAndHashes){
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1]) 
    }
    
    #Begin Constantly keep checking
  while($true){
    Start-Sleep -Seconds 2
     #Collect all files in the target folder
     $files = Get-ChildItem -Path $userDefinedPath 
    

     #for each file , calculate the hash, and write to baseline.txt
     foreach($f in $files){
        $hash = Calculate-File-Hash $f.FullName
        #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $userDefinedPath\baseline.txt -Append
            if($null -eq $fileHashDictionary[$hash.Path]){
                #A new file has been Created
                Write-Host "$($hash.Path) has been Created" -ForegroundColor Green
            }

            #Notify if new file has been changed
            if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                #The file has not changed
            }else{
                #File Has been compromised!, notify ADMIN!!║¼┌"
                Write-Host "$($hash.Path) has been Modified!!" -ForegroundColor Red
            }
     }

     foreach($key in $fileHashDictionary.Keys){
        $baselineFileStillExists = Test-Path -Path $key

        if(-Not $baselineFileStillExists){
            #One of the file/s has been deleted, notify Admin"
            Write-Host "$($key) has been Deleted!! Alert!! ADMIN" -ForegroundColor DarkRed -BackgroundColor Gray
        }
     }
  }

    #Begin monitoring files with saved baseline file
    Write-Host "Read existing baseline.txt, start monitoring files" -ForegroundColor Yellow

}











# Write-Host ""
# Write-Host "What would you like to do?"
# Write-Host ""
# Write-Host ""    Write-Host "A. Collect new Baseline"
# Write-Host ""    Write-Host "B. Begin monitoring files with saved Baseline?"



# $response = Read-Host -Prompt "Please enter 'A' or 'B' "
# Write-Host ""


# $Date_Time = Get-Date -Format "yyyyMMdd_HH_mm"

# $ErrorActionPreference = 'Stop'

# [ValidateScript({
# if(-not (Test-Path -Path $_ -PathType Container))
# {
#     throw 'Invalid Path'
# }

# $true
# })]
# $Source_UIP = Read-Host -Prompt 'Get path of the source files'

# [ValidateScript({
# if(-not (Test-Path -Path $_ -PathType Container))
# {
#     throw 'Invalid Path'
# }

# $true
# })]
# $Extracetd_UIP = Read-Host -Prompt 'Get path of the Destination files'



# #Compare

# $Hash_Src = Get-ChildItem $Source_UIP -Recurse -File | Get-FileHash -Algorithm SHA256

# $Hash_Extr = Get-Filehash -Algorithm SHA256 (Get-ChildItem -Recurse | Get-Item | where {!$_.PsIsContainer})
# $Hash_Extr = Get-ChildItem $Extracetd_UIP -Recurse -File | Get-FileHash -Algorithm SHA256


# $Compare = Compare-Object -ReferenceObject $Hash_Src -DifferenceObject $Hash_Extr -Property hash -IncludeEqual -PassThru | Format-List

# $Compare | Out-File -FilePath "$($Extracetd_UIP)\ Hash_Result-$Date_Time.txt"

# Invoke-Item -Path "~\Desktop\test\Destination\Hash_Result-$Date_Time.txt"


# ###<#

# ###########################################################################################

# #>#
# Function Calculate-File-Hash($filepath){
#     $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
#     return $filehash
# }



# Function Erase-Baseline-If-Already-Exists(){
#     $baselineExists = Test-Path .\baseline.txt
    
#     if($baselineExists){
#         #Delete it

#         Remove-Item -Path .\baseline.txt
#     }

# }
# if($userPathInput -eq $filepath.ToLower()){

# }

# if ($response -eq "A".ToUpper()) {
#     #Delete baseline if it already exists
#     Erase-Baseline-If-Already-Exists
    
#     $files = Get-ChildItem -Path .\$userPathInput
  

#     #Calculate Hash from the target files and store in baseline.txt

#     foreach($f in $files){
#       $hash = Calculate-File-Hash $f.FullName
#       "$($hash.Path)|$($hash.Hash)"|Out-File -FilePath .\baseline.txt -Append

#     }

#     Write-Host "Calculate Hashes, make new baseline.txt" -ForegroundColor Red

#     #Collect all files in the target folder

#     #For each file, calculate the hash, and write to baseline.txt

# }
# elseif ($response -eq "B".ToUpper()){
#     #Empty Dictonary
    
#     $fileHashDictionary = @{}

#     #Load file | Hash from baseline.txt and store in the dictonary
#     $filePathsAndHashes = Get-Content -Path .\baseline.txt

#     foreach($f in $filePathsAndHashes){
        
#     $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
   
#   }
#     $fileHashDictionary.Keys

#     #Begin (continuously) monitoring files with saved Baseline
#     Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor Yellow
#      Write-Host "Press Ctlr+C to stop monitoring"
#     while($true){
#         Start-Sleep -Seconds 1
#         Write-Host "Checking Files For Hash Match...."

#         $files = Get-ChildItem -Path .\Files

#         #For each file, calculate the hash, and write to the baseline.txt file
#         foreach ($f in $files){
#             $hash = Calculate-File-Hash $f.FullName
#             #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

#             if($fileHashDictionary[$hash.Path] -eq $null){
#                 #A New file has been Created
#                 Write-Host "$($hash.Path) has been Created!" -ForegroundColor Green
#             }

#           else{
          
#             #Notify if a new file has changed

#             if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
#                 #the File has not changed
#                 Write-Host "Files Integrity Intact"
#             }
#             else{
#                  #File has been Compromised
#                  Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Cyan
#                  }
#           }

#           foreach($key in $fileHashDictionary.Keys){
#             $baselineFileStillExists = Test-Path -Path $key
#             if(-Not $baselineFileStillExists){
#                 #One of the baseline files must have been deleted, notify your Admin
#                 Write-Host "$($key) has been Deleted!" -ForegroundColor Red
#             }
#         }
         
#         } 
        
#     }

# }
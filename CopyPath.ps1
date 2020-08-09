<#
.Synopsis
   This script will copy all your data from one server to another, based on the import list provided.
.DESCRIPTION
   Long description
   Copy has -force added which overwrites folders, otherwise the normal behavior for Copy-Item will only overwrite the destination file (with or without -Force). 

It has different response types depending on the error
*Source file missing or The network path was not found.
*Folder does not exist \\localhost\C$\Test\DestData
*Error on creating directory \\localhost\C$\Test\DestData

It supports verbose and whatif switches and handles data as expected.

Source: Can be local C:\Folder\ or UNC \\Server01\C$\Folder
Destination: Has to be Local

Refer to various examples to learn more upon the usage.


.EXAMPLE
.\CopyPath.ps1

.EXAMPLE
.\CopyPath.ps1 -InputFile Otherpathfile.csv

\\Server-1\C$\Test\CopyData :Source file missing or The network path was not found.
Folder does not exist \\localhost\C$\Test\DestData
Error on creating directory \\localhost\C$\Test\DestData
Folder does not exist \\Home-PC\C$\Test\DestData
Error on creating directory \\Home-PC\C$\Test\DestData

.EXAMPLE
.\CopyPath.ps1 -InputFile Otherpathfile.csv -Verbose

.EXAMPLE
.\CopyPath.ps1 Importfile.csv -WhatIf -Verbose
This command doesn't make any changes but just tests it.

.EXAMPLE
get-help .\CopyPath.ps1
This is the way to get the help files

.EXAMPLE
PS Scripts> .\CopyPath.ps1 -Verbose

VERBOSE: Source: \\Server-1\C$\Test\CopyData ;Destination: \\Server-1\C$\Test\DestData
\\Server-1\C$\Test\CopyData :Source file missing or The network path was not found.
VERBOSE: Source: C:\Test\CopyData ;Destination: \\localhost\C$\Test\DestData
Folder does not exist \\localhost\C$\Test\DestData
Error on creating directory \\localhost\C$\Test\DestData
VERBOSE: Source: C:\Test\CopyData ;Destination: \\Home-PC\C$\Test\DestData
Folder does not exist \\Home-PC\C$\Test\DestData
Error on creating directory \\Home-PC\C$\Test\DestData

.EXAMPLE
PS C:\test\scripts> .\CopyPath.ps1
Copy Complete on: \\Server-1\C$\Test\DestData.
Copy Complete on: \\localhost\C$\Test\DestData.
Server not reachable: Home-PC
Server not reachable: Server1

.INPUTS
   Inputs to this cmdlet (if any)
   Importpath.csv
    #File Format Starts----------------
Source,Destination,DestnationServer
\\Server-1\C$\Test\CopyData,C:\Test\DestData,Server-1
C:\Test\CopyData,C:\Test\DestData,Server-1
    #File Format Ends------------------

Source: Can be local C:\Folder\ or UNC \\Server01\C$\Folder
Destination: Has to be Local

.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
   Developed by Satyajit Aug 2015
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
#function Copy-Path
#{This can be a function that can be dot sourced to the session if required
[CmdletBinding(SupportsShouldProcess=$true,
               ConfirmImpact='Medium')]

    Param
    (
        #Provide Input CSV file path or default would be used
        [Parameter(Mandatory=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $InputFile = "Importpath.csv",

        #Provide Output CSV file path or default would be used
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ResultFile = "ResultStatus.csv"
    )


#Reading the CSV data
if (Test-Path $InputFile)
{   $im = Import-Csv $InputFile 
Write-Verbose "Input File found: $InputFile"
}
else
{
    Write-Output "Input FILE NOT FOUND!: $InputFile"
    #Exiting the Script in 5secs
    Start-Sleep 5
    return
}



#Enable this if timestamped file required, as Export-Csv overwrites the data
#$ResultFile = "ResultStatus_$(Get-Date -f 'yyyy-MM-dd-HH_mm_ss').csv"

#Preparing the variable for Exporting results, skipping attribute addition if already exists in file
if($($im | gm | where {$_.Name -eq 'Status'}) -eq $null)
{$im | Add-Member Status $null}

#Progress bar counter
$i = 0

#Looping through the paths
foreach ($_obj in $im)
{

#Showing Progress based on the input data object count
write-progress -activity "Copying Files" -status "Progress:" -percentcomplete ($i/$im.count*100)
$i++

#Converting local destination to UNC using servername
$dest = "\\$($_obj.DestServer)\$($_obj.destination.Replace(":","$"))"
$srce = $_obj.source
$server = $_obj.DestServer

Write-Verbose "Source: $srce ;Destination: $dest"
#Write-host "Source: $srce ;Destination: $dest"

#Do a source file validation as well.
if (-not(Test-Path $srce) )
{
Write-Warning "Source file missing or the network path was not found: $srce" 
 $_obj.Status = "Source file missing or the network path was not found: $srce" 
#Decide to 'break' the whole file or might want to 'continue' with remaining. Depends on how many source files we have.
#break
continue #Source missing skip destination steps
}


    #Ping server to check if on network or not
    if(Test-Connection -ComputerName $server -Quiet)
    {
        #Check if path exists or not
        if (Test-Path $dest)
                {
	                #If it does run the copy command
	                Write-Verbose "Folder Exists on: $dest"
                }
                else
                {
                    #If it doesn't, create it and then run the copy command
                    Write-Verbose "Folder does not exist: $dest or the network path was not found."

                    try
                    {
                        # Create the folder and suppress screen output
                        if($WhatIfPreference)
                           {New-Item $dest -type directory -WhatIf -ErrorAction Stop}
                        else #whatif
                        {
                            New-Item $dest -type directory -ErrorAction Stop | Write-Verbose
                            Write-Verbose "Created directory: $dest"
                        }

                    }
                    catch
                    {
                        Write-Output "Error on creating directory: $dest"
                         $_obj.Status = "Error on creating directory: $dest"
                        continue
                    }
                }

                try
                {

                    #Copy all the items from the source folder
                    if($WhatIfPreference)
                        {Copy-Item "$srce\*"  -Destination $dest -Recurse -force -WhatIf -ErrorAction Stop}
                    else #Whatif
                    {
                        if($VerbosePreference -eq 'Continue')
                         {Copy-Item "$srce\*"  -Destination $dest -Recurse -Verbose -force -ErrorAction Stop}
                        else #Verbose
                         {Copy-Item "$srce\*"  -Destination $dest -Recurse -force -ErrorAction Stop}

                    #Copy the whole folder with the contents inside
                    #Copy-Item $_obj.source -Destination $_obj.destination -Recurse -Verbose -force
                    Write-Output "Copy Complete on: $dest."
                    $_obj.Status = "Copy Complete on: $dest."
                    }




                }
                catch
                {
                    Write-Output "Copy Error on: $dest."
                    $_obj.Status = "Copy Error on: $dest."
                    Write-Verbose $error[0]
                }

    } #If test connection
    else
    {
    Write-Output "Server not reachable: $server"
    $_obj.Status = "Server not reachable: $server"
    }


}#For

#Progress Bar - Finishing 100% called
write-progress -activity "Copying Files" -status "Progress:" -percentcomplete ($i/$im.count*100)

#Generate a consolidated result on csv
#Note if unhandled error hits in between, this will not be updated. Lookout for console results.
if($WhatIfPreference)
    {$im | Export-Csv $ResultFile -WhatIf}
else
    {
    $im | Export-Csv $ResultFile -NoTypeInformation
    Write-Output "`n Results exported to $ResultFile"
    Start-Sleep 5
    }
#}
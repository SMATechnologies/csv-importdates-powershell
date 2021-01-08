<#
    -This script reads a file containing dates, and adds the dates to an OpCon calendar.  
    -The calendar can exist or be created (if you are using the OpCon API).
    -The parameters can be set here or passed in on the OpCon job.
    -You can use traditional MSGIN functionality or the OpCon API.
    
    Author: Bruce Jernell
    Version: 1.1

    * Added delimiter parameter option
    * Added ability to login rather than requiring application token for OpCon API
    * Renamed parameters token -> password, extuser -> user for clarity
#>
param(
    $path                         # Path to CSV/Text file containing dates
    ,$opconPath                   # Path to OpCon API PS Module
    ,$msginPath                   # Path to MSGIN directory
    ,$url                         # URL for OpCon API
    ,$password                    # User password/token for MSGIN/API
    ,$calendar                    # Name of the calendar to update
    ,$user                        # User for MSGIN/API authentication
    ,$description                 # Description for the new user calendar
    ,$delimiter                   # Used to specify file delimiter
    ,$option                      # Script option, "apiCreate","apiUpdate","msgin","test"
)

if(($option -eq "apiCreate") -or ($option -eq "apiUpdate"))
{
    # Verifies opcon module exists and is imported
    if(Test-Path $opconPath)
    {
        # Verify PS version is at least 3.0
        if($PSVersionTable.PSVersion.Major -ge 3)
        { Import-Module -Name $opconPath -Force }
        else
        {
            Write-Host "Powershell version needs to be 3.0 or higher!"
            Exit 100
        }
    }
    else
    {
        Write-Host "Unable to import SMA API module!"
        Exit 100
    }

    # Adds dates into an array
    $date = New-Object System.Collections.ArrayList
    gc $path -Delimiter $delimiter | ForEach-Object{ $date.Add($_) | Out-Null }

    if($date.Count -gt 0)
    {
        # Ignore self signed certificates
        # There are different function for Powershell/Powershell Core
        if($PSVersionTable.PSVersion.Major -ge 6)
        { OpCon_SkipCerts }
        else 
        { OpCon_IgnoreSelfSignedCerts }

        try
        {
            # Authenticate to the OpCon API
            $token = "Token " + (OpCon_Login -url $url -user $user -password $password).id

            # Calls the OpCon API to update the calendar
            if($option -eq "apiUpdate")
            { OpCon_UpdateCalendar -url $url -token $token -name $calendar -date $date }

            # Calls the OpCon API to create the calendar
            if($option -eq "apiCreate")
            { OpCon_CreateCalendar -url $url -token $token -name $calendar -dates $date -description $description -type 1 }
        }
        catch [Exception]
        {
            Write-Host $_
            Write-Host $_.Exception.Message
            Exit 100
        }
    }
}
elseif($option -eq "msgin")
{
    if($msginPath)
    {
        if(test-path $msginPath)
        {   Write-Host "$msginPath path exists" }
        else
        {
            Write-Host "$msginPath path does not exist"
            Exit 101
        }
    }
    else
    {
        Write-Host "MSGIN Path parameter must be specified!"
        Exit 102
    }    

    # Builds a variable with the dates delimited
    gc $path -delimiter $delimiter | ForEach-Object{ $date = $date + $_.Replace($delimiter,"") + ";" } 
    $date = $date.TrimEnd(";") 

    # Creates an event file containing the dates and places it in the MSGIN directory
    # Does not check for existing/duplicates
    "`$CALENDAR:ADD,$calendar,$date,$user,$password" | Out-File -FilePath ($msginPath + "\event.txt") -Encoding ascii
}
elseif($option = "test")
{
    # Outputs dates found in a delimited format to the output
    # Does NOT make any changes inside of OpCon
    gc $path -delimiter $delimiter | ForEach-Object{ $date = $date + $_.Replace($delimiter,"") + ";" } 
    $date = $date.TrimEnd(";") 
    $date | Out-Host
}
else
{
    Write-Host 'Invalid option, must be "apiCreate","apiUpdate","msgin","test"!'
    Exit 100
}


# Define the filter for event ID 4014
$filter = @{
    LogName = 'Microsoft-Windows-PowerShell/Operational'
    Id = 4104
}

# Get the events
Get-WinEvent -FilterHashtable $filter -MaxEvents 5


# Define the filter for event ID 4014
$filter = @{
    LogName = 'Microsoft-Windows-PowerShell/Operational'
    Id = 4014
}

# Get the events
Get-WinEvent -FilterHashtable $filter

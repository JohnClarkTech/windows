# location of CSV file with 
$Location = "D:\shared\data\"
$CsvLocation = "c:\dept.csv"
Set-Location $Location

$Folders = Import-Csv $CsvLocation

ForEach ($Folder in $Folders) { 

    # create folder if does not exist
    If (Test-Path -Path $Folder.name) {
        #do nothing
    }
    else {
        New-Item -ItemType Directory -Name $Folder.Name
    } 

    # remove empty spaces from string
    $FolderTrimmed = $Folder.name -replace '\s',''
    
    # generate a read-write AD Group based on the input names
    $ADGroup1 = "FILE-" + $FolderTrimmed + "-RW"
    $ADdescription = "RW access to " + $FolderTrimmed + " folder"
    #Write-Output $ADGroup

    #check to see if the AD group exists already, if not create
    $groupobj = get-adgroup -LDAPFilter "(SAMAccountName=$adgroup1)"
    if($groupobj -eq $null){
        # create AD group    
        New-ADGroup -Name $ADGroup1 -GroupScope DomainLocal -GroupCategory Security -Path “OU=Test,DC=DOMAIN,DC=COM” -Description $ADdescription
    }

    # generate a read-only AD Group based on the input names
    $ADGroup2 = "FILE-" + $FolderTrimmed + "-RO"
    $ADdescription = "RO access to " + $FolderTrimmed + " folder"
    #Write-Output $ADGroup

    # check to see if the AD group exists already, if not create
    $groupobj = get-adgroup -LDAPFilter "(SAMAccountName=$adgroup2)"
    if($groupobj -eq $null){
        # create AD group    
        New-ADGroup -Name $ADGroup2 -GroupScope DomainLocal -GroupCategory Security -Path “OU=Test,DC=DOMAIN,DC=CO” -Description $ADdescription
    }



    # 3) SET FOLDER PERMISSIONS
    # generate new 
    $FolderPath = $Location + $folder.name
    $acl = Get-Acl $FolderPath
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($ADGroup1,"Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $FolderPath $acl
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($ADGroup2,"Read", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $FolderPath $acl

    #Write-Output $acl
    Write-Output $FolderPath
    
    Write-Output $Acl | fl *
    #Write-Output $Username
}

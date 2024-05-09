Param (
    [string] $CSVPath,            # Path to the CSV file containing user details
    [string] $DomainController    # Domain controller name
)

# Import the Active Directory module
Import-Module ActiveDirectory

# Read the CSV file
$users = Import-Csv -Path $CSVPath

# Iterate over each user in the CSV file
foreach ($user in $users) {
    $username = $user.Username      # Username
    $fullName = $user.FullName      # Full name of the user
    $password = $user.Password      # Password
    $ou = $user.OrganizationalUnit  # Organizational Unit
    $group = $user.Group            # Group the user should belong to
    $pathDomain = "DC=$(($DomainController -split '\.')[0]),DC=$(($DomainController -split '\.')[1])"  # Domain path

    # Check if the user already exists in the domain
    if (Get-ADUser -Filter {SamAccountName -eq $username}) {
        Write-Host "The user $username already exists in the domain." -ForegroundColor Yellow
        continue
    }

    # Create the OU if it doesn't exist
    if ($ou -and (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'"))) {
        New-ADOrganizationalUnit -Name $ou -Path $pathDomain -ProtectedFromAccidentalDeletion $false
        Write-Host "Organizational Unit $ou created." -ForegroundColor Green
    }

    # Create the new user in the default "Users" OU
    New-ADUser -SamAccountName $username `
               -UserPrincipalName "$username@$DomainController" `
               -Name $fullName `
               -Path "OU=$ou,$pathDomain" `
               -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -PassThru |
    Set-ADUser -Description "Created via PowerShell script"

    Write-Host "User $username has been successfully created in OU=$ou,$pathDomain." -ForegroundColor Green

    # Check if a group was specified and if it exists
    if ($group -and (-not (Get-ADGroup -Filter "Name -eq '$group'"))) {
        # Create the group in the default OU
        New-ADGroup -Name $group -GroupCategory Security -GroupScope Global -Path "OU=$ou,$pathDomain"
        Write-Host "Group $group has been successfully created in OU=$ou,$pathDomain." -ForegroundColor Green
    }

    # Add the user to the group if specified
    if ($group) {
        Add-ADGroupMember -Identity $group -Members $username
        Write-Host "User $username added to group $group." -ForegroundColor Green
    }
}

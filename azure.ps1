Write-Host "[!] Importing and installing modules......"
Install-Module -Name AzureAD
Import-Module AzureAD

function Connect-Azure{
    <#
        .SYNOPSIS
        Connect-Azure

        .DESCRIPTION
        Connects to the Azure Powershell Module

        .PARAMETER Username
        The UserPrincipalName

        .PARAMETER Password
        The password for the user

        .EXAMPLE
        C:\PS> Connect-Azure -Username teste@domain.com -Password 'Domain@2024'
    #>

    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )

    $cred = New-Object System.Management.Automation.PSCredential ("$Username", (ConvertTo-SecureString "$Password" -AsPlainText -Force))
    Connect-AzureAD -Credential $cred
}

function Get-UserMemberofGroup{
    <#
        .SYNOPSIS
        Get-UserMemberofGroup

        .DESCRIPTION
        Returns the groups of a given username

        .PARAMETER User
        The UserPrincipalName

        .EXAMPLE
        C:\PS> Get-UserMemberofGroup -User teste@domain.com
    #>
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$User
    )

    $principal = Get-AzureADUser -SearchString $User
    Get-AzureADUserMembership -ObjectId $principal.ObjectId
}

function Get-ListUsers{
    <#
        .SYNOPSIS
        Get-ListUsers

        .DESCRIPTION
        Returns the users of the Azure Domain

        .EXAMPLE
        C:\PS> Get-ListUsers
    #>
    Import-Module Microsoft.Graph.Users
    Connect-MgGraph -NoWelcome -Scopes 'User.Read.All'
    Get-MgUser -All
}

function Get-ListDomains{
    <#
        .SYNOPSIS
        Get-ListDomains

        .DESCRIPTION
        Returns Azure Domains

        .EXAMPLE
        C:\PS> Get-ListDomains
    #>
    Get-AzureADDomain
}

function Get-ListGroups{
    <#
        .SYNOPSIS
        Get-ListGroups

        .DESCRIPTION
        Returns the Azure Domain's groups

        .EXAMPLE
        C:\PS> Get-ListGroups
    #>
    Get-AzureADGroup
}

function Get-ListMembersGroup{
    <#
        .SYNOPSIS
        Get-ListMembersGroup

        .DESCRIPTION
        Returns the members of a given group

        .PARAMETER User
        The name of the group

        .EXAMPLE
        C:\PS> Get-ListMembersGroup -Group Admin
    #>
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Group
    )
    try {
		$search = Get-AzureADGroup -SearchString $Group
		if ($search.ObjectId.Count -gt 1){
			Get-AzureADGroup -SearchString $Group
		} else {
			Get-AzureADGroupMember -ObjectId $search.ObjectId
			}
	}
	catch {
		Write-Host "[!] Unable to find a group with that name!"
	}
}
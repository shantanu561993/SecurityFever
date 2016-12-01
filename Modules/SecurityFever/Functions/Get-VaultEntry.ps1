
<#
    .SYNOPSIS
    Get the credential entries from the Windows Credential Manager vault.

    .DESCRIPTION
    This cmdlet uses the native unmanaged Win32 api to retrieve all entries from
    the Windows Credential Manager vault. The entries are not objects of type
    PSCredential. The PSCredential is available on the Credential property or
    with the Get-VaultEntryCredential cmdlet or you can get a secure string
    with the Get-VaultEntrySecureString cmdlet.

    .INPUTS
    None.

    .OUTPUTS
    SecurityFever.CredentialManager.CredentialEntry.

    .EXAMPLE
    PS C:\> Get-VaultEntry
    Returns all available credential entries.

    .EXAMPLE
    PS C:\> Get-VaultEntry -TargetName 'MyUserCred'
    Return the credential entry with the target name 'MyUserCred'.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/SecurityFever
#>

function Get-VaultEntry
{
    [CmdletBinding()]
    [OutputType([SecurityFever.CredentialManager.CredentialEntry])]
    param
    (
        # Filter the credentials by target name. Does not support wildcards. 
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [System.String]
        $TargetName,

        # Filter the credentials by type.
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [SecurityFever.CredentialManager.CredentialType]
        $Type,

        # Filter the credentials by persist location.
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [SecurityFever.CredentialManager.CredentialPersist]
        $Persist
    )

    # Create a second variable, because the TargetName parameter is a string and
    # will only be empty and never null.
    if ([String]::IsNullOrEmpty($TargetName))
    {
        $filterTargetName = $null
    }
    else
    {
        $filterTargetName = $TargetName
    }

    $credentialEntries = [SecurityFever.CredentialManager.CredentialStore]::GetCredentials($filterTargetName, $Type, $Persist)

    foreach ($credentialEntry in $credentialEntries)
    {
        Write-Output $credentialEntry
    }
}

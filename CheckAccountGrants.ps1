# Define the specified account
$specifiedAccount = Read-Host "Account to check "  # Change this to the account you want to check

try{
        # Check if the specified account exists
        $mailbox = Get-Mailbox -Identity $specifiedAccount -ErrorAction Stop

} catch {

    Write-Host "An error occurred: $_" -ForegroundColor DarkRed

}

Write-Host "Checking Full Access" -ForegroundColor Yellow
try {
    # Retrieve all accounts that can 'Send As' the specified account
    $fullAccessPermissions = Get-MailboxPermission -Identity $mailbox.Alias | Where-Object {
        $_.AccessRights -eq "FullAccess" -and $_.User -ne "NT AUTHORITY\SELF"
    }

    # Check if any accounts have 'Send As' permission
    if ($fullAccessPermissions) {

        $path = $specifiedAccount + "_FullAccessPermissions.csv"
        
        $fullAccessPermissions | Export-CSV -Path $path -NoTypeInformation

    } else {
        Write-Host "No accounts have 'Full Access' permission for $specifiedAccount." -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor DarkRed
} 

Write-Host "Checking Send As" -ForegroundColor Yellow
try {

    # Retrieve all accounts that can 'Send As' the specified account
    $sendAsPermissions = Get-RecipientPermission -Identity $mailbox.Alias | Where-Object {
        $_.AccessRights -eq "SendAs"
    }

    # Check if any accounts have 'Send As' permission
    if ($sendAsPermissions) {

        $path = $specifiedAccount + "_SendAs.csv"
        
        $sendAsPermissions | Export-CSV -Path $path -NoTypeInformation

    } else {
        Write-Host "No accounts have 'Send As' permission for $specifiedAccount." -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor DarkRed
} 

Write-Host "Checking Send On Behalf" -ForegroundColor Yellow
try {

    # Retrieve all accounts that can 'Send As' the specified account
    $sendOnBehalfPermissions = Get-Mailbox -Identity $specifiedAccount | Select-Object -ExpandProperty GrantSendOnBehalfTo

    # Check if any accounts have 'Send As' permission
    if ($sendOnBehalfPermissions) {
        
        $path = $specifiedAccount + "_SendOnBeghalf.csv"

        $sendOnBehalfPermissions | Export-CSV -Path $path -NoTypeInformation

    } else {
        Write-Host "No accounts have 'Send On Behalf To' permission for $specifiedAccount." -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor DarkRed
} 

Write-Host "Done! Check created CSV Logs" -ForegroundColor Green

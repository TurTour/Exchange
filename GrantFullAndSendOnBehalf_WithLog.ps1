function Write-Log {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$LogFilePath
    )
    $date = get-date -format "ddmmyy hh:ss" 
    $logMessage = "[$date] :: $Message"
    Add-Content -Path $logFilePath -Value $logMessage
}

#connect-exchangeonline

#log info
$today = get-date -format "ddMMyy" 
$logPath = ".\GrantAccess_" + $today + "_.log"
#*********

#account that needs access
$grantTo = "JohnDoe@contoso.com" # account that needs access

#import csv with accounts to have access to
#csv with list of account to access to
$listOfNeededAccess = Import-Csv -Path ".\something.csv" 

#NOTE:: how the script is built in your csv the field with the email addresses should be called 'Address'

foreach($account in $($listOfNeededAccess.Address)){
    try {

        # Set Full Access
        Add-MailboxPermission -Identity $currentAccount -User $grantTo -AccessRights FullAccess -InheritanceType All

        # Send on Behalf
        $mailbox = Get-Mailbox -Identity $account

        #get current grants existing on for the account
        $current = $mailbox.GrantSendOnBehalfTo

        #set grants to all previous + the new address to have SendOnBehalfAccess
        Set-Mailbox -Identity $account -GrantSendOnBehalfTo ($current + $grantTo)
        Write-Log -Message " [OK] ::Account $grantTo granted access to $account" -LogFilePath $logPath

    }
    catch {
        
        $err = $_
        Write-Log -Message " [ERR] ::Account $grantTo  NOT granted access to $account" -LogFilePath $logPath
        Write-Log -Message " ERROR >> $err" -LogFilePath $logPath

    }
}


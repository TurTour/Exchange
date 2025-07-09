[System.Collections.ArrayList]$ddlInfo = @{}

$ddlName = Read-Host "DDL display Name "

$ddl = Get-DynamicDistributionGroup $ddlName

$userList = Get-Recipient -RecipientPreviewFilter $ddl.RecipientFilter -OrganizationalUnit $ddl.RecipientContainer

$pbcCounter = 0

foreach($user in $userList){

    $checkPattern = $($user.Name).contains("-")

    if(!($checkPattern)){
        $ddlInfo += $($user.Name)
    } else {
        $ddlInfo += (get-mgUser -userId $($user.Name)).DisplayName
    }

    #progress Bar
    $pbCounter++
    Write-Progress -Activity "Building Report..." -CurrentOperation $($user.Name) -PercentComplete (($pbCounter / $userList.count) * 100)

}

$ddlInfo > "$ddlName.txt"

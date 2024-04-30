#Function area this will run back end items withing UCK 

#Cloud Functions
Function UserCloudChangesFTE([system.string] $UPN)
{
    #Defualt location for now is USA wil have to change manually if you want the location to be diffrent looking for ways to implment this automatically
    Set-MsolUser -UserPrincipalName $UPN -UsageLocation US

    $LicenseE5 = "contoso:E5License"
    
    Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $LicenseE5 
    
}
Function UserCloudChangesContract([system.string] $UPN)
{
    #Defualt location for now is USA wil have to change manually if you want the location to be diffrent looking for ways to implment this automatically
    Set-MsolUser -UserPrincipalName $UPN -UsageLocation US

    $LicenseE3 = "contoso:E3License"
    $LicenseE5Sec = "constoso:E5SecLicense"
    Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $LicenseE5Sec
    Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $LicenseE3
    
}

#SyncFunction
Function Start-ADsyncCycle2SyncServer()
{
    #This will hold the Script Admin account
    $s = New-PSSession -computerName ("DIRSYNCServer.$($Domain)") -credential $cred
    Invoke-Command -Session $s -Scriptblock {Start-AdsyncsyncCycle -PolicyType Delta}
    Start-Sleep -Seconds 300
    Remove-PSSession $s
    #Checks to see if the connection was removed sucessfully
    if($?)
    {
        Write-host "Connection to DIRSYNCServer.$($Domain) Terminated"
    }
    else
    {
        Write-host "The connection failed to terminate DIRSYNCServer.$($Domain) `nPlease Troubleshoot"
    }
}

#Function of FullTimeEmployee 
Function FullTimeEmployeeMain
{
    $LabelUPNSide.Text = ("$($TextBoxFN.Text)" + "." + "$($TextBoxLN.Text)"+"$($Domain)")
    #OU path using the ComboBox NEEDS *****WORK****
    $OUPath = "OU=Users, DC=TestDomain.edu, DC=com" 
    $SAM = $LabelUPNSide.Text.Replace(($Domain),"")
    if($SAM.Length -gt 20)
    {
        Write-host "Your Sam account name is greater than Sam can not be longer than 20 Charecters long'nEx.Giancarlo.Barrientes.c is to long to be a sam account name"
        break
    }
    if($SAM -like $AllUsersSamCheck)
    {
        Write-host "This is user already appears to exsist with 'n$($SAM) Already is in the active directory environment"
        break
    }
    $UserPrincipleName = $LabelUPNSide.Text
    $DisplayName = "$($TextBoxFN.Text)" + " "+ "$($TextBoxLN.Text)"
    $proxyAddresses = @("SMTP:$($SAM)" + "$($Domain)")
    $Password = $TextBoxUserPass.Text
    #Command here for onpremise ad user account set up using above variables
    # Create a new AD user account
    try {
        New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $UserPrincipleName -DisplayName $DisplayName -GivenName $TextBoxFN.Text -Surname $TextBoxLN.Text -EmailAddress $UserPrincipleName -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Path $OUPath -Enabled $true 
    }
    catch {
        Write-Warning "On-Premise User account failed to create check user attributes"
    }
    # Set additional user attributes
    
    try {
        Set-ADUser -Identity $SAM -Add @{proxyAddresses=$proxyAddresses}
    }
    catch {
        Write-Warning "Setting Proxy Addresses failed please investigate"
    }
    #Sync Function here
    try {
        Start-ADsyncCycle2SyncServer
    }
    catch {
        Write-Warning "Start-ADsyncCycle2SyncServer function failed"
    }
    #Cloud Varibles (Assigning the Cloud location defualt choise is usa and the License)
    try {
        UserCloudChangesFTE -UPN $UserPrincipleName
    }
    catch {
        Write-Warning "UserCloudChanges function failed please investigate"
    }
    #Once finsihed spit out message stating this is completed have okay button when ok button pressed close 
    $endResult = [System.Windows.Forms.MessageBox]::Show(
        "User $($UserPrincipleName) has been created",
        "Good Job",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    if ($endResult -eq [System.Windows.Forms.DialogResult]::OK) {
         #Set flag to true to indicate that user has been created thus finalized button will not work
        $script:UserCreated = $true
        $Onboardform.Close()
    }
}
#Function of Contractor Creation
function ContractorMain
{
    #OnPremise Variables
    $LabelUPNSide.Text = ("$($TextBoxFN.Text)" + "." + "$($TextBoxLN.Text)" + ".c" +"$($Domain)")
    $OUPath = "OU=ContractorUsers, DC=contoso, DC=com"
    $SAM = $LabelUPNSide.Text.Replace($Domain,"")
    #Script check to see if sam is greater than 20
    if($SAM.Length -gt 20)
    {
        Write-host "Your Sam account name is greater than Sam can not be longer than 20 Charecters long'nEx.Giancarlo.Barrientes.c is to long to be a "
        break
    }
    if($SAM -like $AllUsersSamCheck)
    {
        Write-host "This is user already appears to exsist with 'n$($SAM) Already is in the active directory environment"
        break
    }
    
    
    $proxyAddresses = @("SMTP:$($SAM)" + +"$($Domain)")
    $Password = $TextBoxUserPass.Text
    $UserPrincipleName = $LabelUPNSide.Text
    #Command here for onpremise ad user account set up using above variables
    #Create a new AD user account
    try {
       New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $UserPrincipleName -DisplayName $DisplayName -GivenName $TextBoxFN.Text -Surname $TextBoxLN.Text -EmailAddress $UserPrincipleName -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Path $OUPath -Enabled $true   
    }
    catch {
        Write-Warning "On-Premise User account failed to create check user attributes"
    }
    # Set additional user attributes
    try {
        Set-ADUser -Identity $SAM -Add @{proxyAddresses=$proxyAddresses}
    }
    catch {
        Write-Warning "Setting Proxy Addresses failed please investigate"
    }
    #Sync Function here
    try {
        Start-ADsyncCycle2SyncServer
    }
    catch {
        Write-Warning "Start-ADsyncCycle2SyncServer function failed"
    }
    #Cloud Varibles (Assigning the Cloud location defualt choise is usa and the License)
    try {
        UserCloudChangesContract -UPN $UserPrincipleName
    }
    catch {
        Write-Warning "UserCloudChanges function failed please investigate"
    }
    #Once finsihed spit out message stating this is completed have okay button when ok button pressed close 
    $endResult = [System.Windows.Forms.MessageBox]::Show(
        "User $($UserPrincipleName) has been created",
        "Good Job",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    if ($endResult -eq [System.Windows.Forms.DialogResult]::OK) {
         # set flag to true to indicate that user has been created
        $script:UserCreated = $true
        $Onboardform.Close()
    }

}
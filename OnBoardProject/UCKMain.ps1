Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Functions/Variables locations
. "PathTO\OnBoardProject\UCKCustomItems.ps1"
. "PathTO\OnBoardProject\UCKBackEnd.ps1"
. "PathTO\OnBoardProject\UCKGUI.ps1"
#XML Variable function loader
XMLandIcoLoader

#DomainVariable function loader
DomainLoader

#MSOL-connect and On-prem Domain admin login here
StartUpCred

#Load GUI Function
GUiLoader

#Finalize Button meant to push the variables out so the back end can work! Boolean to control and make sure this ran only once (Dummy proofing)
$script:UserCreated = $false
$FinalButton.Add_Click({
   #User Check to confirm that the user has not been already created holds all sam user information within an active environment
    
    $script:AllUsersSamCheck = (Get-ADUser -filter *).SamAccountName
    $script:LabelUPNSide.Text = ("$($TextBoxFN.Text)" + "." + "$($TextBoxLN.Text)"+"$($Domain)")
    $script:UserPrincipleName = $LabelUPNSide.Text
    #Checks to see if 
    if ($script:UserCreated) {
        [System.Windows.Forms.MessageBox]::Show("User has already been created. Please exit the program and try again.", "Error")
        return  # exit the function without doing anything else
    }
    $result = [System.Windows.Forms.MessageBox]::Show(
        ("You are about to create a new user Confirm that variables you inputed are CORRECT!`nIf contractor checkbox marked imagine .c at the end of the last name for following variable
        UserPrincipleName: $($UserPrincipleName)"),
        "Confirm Data Is Correct",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
       if ($result -eq [System.Windows.Forms.DialogResult]::Yes)
    {
        #Removes the spaces if there any from the name text box's
        RemoveSpaceFromTxtBoxName
        if($ContractorsCheckBox.Checked -eq $true)
        {
            ContractorMain
        }
        else
        {
            FullTimeEmployeeMain 
        }   
    }
})

#Simple Exit button
$exitButton.Add_Click({

    $result = [System.Windows.Forms.MessageBox]::Show(
        "Are you sure you want to quit `"$($Onboardform.Text)`"?", 
        "Confirm",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $Onboardform.Close()
    }
})
#Shows the form
$Onboardform.ShowDialog() | Out-Null
#Cleans up the variables of the form
$Onboardform.Dispose()

#Used if dir sync is giving me problems
#Remove-MSOLUser -UserPrincipalName "Giancarlo.Barrientes@MyDEVAzureTenant.onmicrosoft.com"

Function GUiLoader{
    $script:formObject = [System.Windows.Forms.Form]
    $script:labelObject = [System.Windows.Forms.Label]
    $script:comboBoxObject = [System.Windows.Forms.ComboBox]
    $script:TextObject = [System.Windows.Forms.TextBox]
    $script:ButtonObject = [System.Windows.Forms.Button]
    $script:CheckBoxObject = [System.Windows.Forms.CheckBox]

    #FinalButtonController

    #Oboard Main Form creation and Object variables
    $script:Onboardform = New-Object $formObject
    #This is the size of the main window
    $Onboardform.ClientSize = '500,350'
    $Onboardform.Text = 'User Creation Kit'
    $Onboardform.BackColor = "#ffffff"
    $Onboardform.Icon = $script:CustomIcon

    #Labels Area
    #FirstName label
    $script:LabelFirstName = New-Object $labelObject
    $LabelFirstName.Text = 'First Name:'
    $LabelFirstName.AutoSize = $true
    $LabelFirstName.Location = New-Object System.Drawing.Point(20, 20)

    #Last Name Label
    $script:LabelLastName = New-Object $labelObject
    $LabelLastName.Text = 'Last Name:'
    $LabelLastName.AutoSize = $true
    $LabelLastName.Location = New-Object System.Drawing.Point(20, 40)


    $script:LabelUPN = New-Object $labelObject
    $LabelUPN.Text = 'UPN:'
    $LabelUPN.AutoSize = $true
    $LabelUPN.Location = New-Object System.Drawing.Point(20, 60)

    $script:LabelUPNSide = New-Object $labelObject
    $script:LabelUPNSide.AutoSize = $true
    $LabelUPNSide.Text = ""
    $LabelUPNSide.Location = New-Object System.Drawing.Point(100, 60)

    $script:LabelDepartment = New-Object $labelObject
    $LabelDepartment.AutoSize = $true
    $LabelDepartment.Text = "Department"
    $LabelDepartment.Location = New-Object System.Drawing.Point(20, 80)

    $script:LabelLocationContinent = New-Object $labelObject
    $LabelLocationContinent.AutoSize = $true
    $LabelLocationContinent.Text = "Continent Location"
    $LabelLocationContinent.Location = New-Object System.Drawing.Point(20, 120)

    $script:LabelLocationCountry = New-Object $labelObject
    $LabelLocationCountry.AutoSize = $true
    $LabelLocationCountry.Text = "Country Location"
    $LabelLocationCountry.Location = New-Object System.Drawing.Point(20, 150)

    $script:LabelPassword = New-Object $labelObject
    $LabelPassword.AutoSize = $true
    $LabelPassword.Text = "Password for new user:"
    $LabelPassword.Location = New-Object System.Drawing.Point(20, 180)

    #DropDownBoxArea
    $script:ddlDepartment = New-Object $comboBoxObject
    $ddlDepartment.Width = 300
    $ddlDepartment.Location = New-Object System.Drawing.Point(125, 80)
    $ddlDepartment.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

    $script:ddlContLocation = New-Object $comboBoxObject
    $ddlContLocation.Width = 300
    $ddlContLocation.Location = New-Object System.Drawing.Point(125, 120)
    $ddlContLocation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

    $script:ddlCountryLocation = New-Object $comboBoxObject
    $ddlCountryLocation.Width = 300
    $ddlCountryLocation.Location = New-Object System.Drawing.Point(125, 150)
    $ddlCountryLocation.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    #Department DropDown Box backend
    

    #EXAMPLE this is selecting the Greece SOHO 
    #$regions.countries[1].Country[11].Locations.Location.Name
    #What it looks like when you have America selected as the Country
    foreach ($Item in $TestDomain.Departments) {
        $ddlDepartment.Items.Add($Item)
    }


    #$comboBox.Items.AddRange($comboBoxItems) equilvilants to adding the whole range

    #TextBox Area
    $script:TextBoxFN = New-Object $TextObject
    $TextBoxFN.AutoSize = $true
    $TextBoxFN.Location = New-Object System.Drawing.Point(100, 20)

    $script:TextBoxLN = New-Object $TextObject
    $TextBoxLN.AutoSize = $true
    $TextBoxLN.Location = New-Object System.Drawing.Point(100, 40)
    # Define a function to remove spaces from text boxes
    function RemoveSpaceFromTxtBoxName() {
        if ($TextBoxFN.Text.Contains(" ")) {
            $TextBoxFN.Text = $TextBoxFN.Text.Replace(" ", "")
        }
        if ($TextBoxLN.Text.Contains(" ")) {
            $TextBoxLN.Text = $TextBoxLN.Text.Replace(" ", "")
        }
    }

    $script:TextBoxUserPass = New-Object $TextObject
    $TextBoxUserPass.AutoSize = $true
    $TextBoxUserPass.Location = New-Object System.Drawing.Point(150, 180)
    #end of Text box area

    #CheckBox Area
    $script:ContractorsCheckBox = new-object $CheckBoxObject
    $ContractorsCheckBox.Location = new-object System.Drawing.Size(20, 200)
    $ContractorsCheckBox.Size = new-object System.Drawing.Size(250, 50)
    $ContractorsCheckBox.Text = "Is Contractor(Unchecked means False)"
    $ContractorsCheckBox.Checked = $false


    #Button Area
    #Finalized button
    $script:FinalButton = New-Object $ButtonObject
    $FinalButton.Location = New-Object System.Drawing.Point(75, 250)
    $FinalButton.Size = New-Object System.Drawing.Size(200, 23)
    $FinalButton.Text = 'Finalize Results'
    #$FinalButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

    # Create the exit button
    $script:exitButton = New-Object $ButtonObject
    $exitButton.Size = New-Object System.Drawing.Size(175, 23)
    $exitButton.Text = "Exit ScriptProgram"
    $exitButton.Location = New-Object System.Drawing.Point(300, 250)



    #Adds everything to the Form page
    $script:Onboardform.Controls.addRange(@($LabelFirstName, $LabelLastName, $LabelUPN, $TextBoxFN, $TextBoxLN , $LabelUPNSide, $FinalButton, $exitButton))
    $script:Onboardform.Controls.addRange(@($ddlDepartment, $LabelDepartment, $LabelLocationContinent, $ddlContLocation, $LabelLocationCountry, $ddlCountryLocation ))
    $script:Onboardform.Controls.addRange(@($ContractorsCheckBox, $LabelPassword, $TextBoxUserPass))

    #Gui Logic
    $ddlContLocation.add_SelectedIndexChanged({
            $selectedItem = $ddlContLocation.SelectedItem
            if ($selectedItem -eq 'Asia') {
                # If USA is selected, add some items to the second ComboBox
                $ddlCountryLocation.Items.Clear()
                $ddlCountryLocation.Items.AddRange($TestDomain.Department[0].Country.Name)
            }
            elseif ($selectedItem -eq 'Europe') {
                # If Canada is selected, add some different items to the second ComboBox
                $ddlCountryLocation.Items.Clear()
                $ddlCountryLocation.Items.AddRange($TestDomain[1].countries.Country.Name)
            }
            elseif ($selectedItem -eq 'Latin America') {
                # For all other countries, clear the items in the second ComboBox
                $ddlCountryLocation.Items.Clear()
                $ddlCountryLocation.Items.AddRange($TestDomain[2].countries.Country.Name)
            }
            elseif ($selectedItem -eq 'North America') {
                $ddlCountryLocation.Items.Clear()
                $ddlCountryLocation.Items.AddRange($Departments[3].countries.Country.Name)
            }
        })
}
#Custom Items/Variables that should be changed with company logo and xml file of OU structure. Can be left with default

function XMLandIcoLoader{
    #custom xml can be placed here
    $script:xml = $xml = [xml](Get-Content -Path "C:PathTo\xmlData\Department.xml")
    $script:TestDomain = $xml.SelectNodes("//TestDomain")
    #Company logo for where you want customl logo on top left corner of window
    $script:CustomIcon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:PathTo\FormData\user.ico")
}

function DomainLoader{
    #Domain name for where you want to create the user
    $script:Domain = "@TestDomain.edu"
    $atDomainoff = $script:Domain.Replace("@", "") 
    $script:SplitDomain = $atDomainoff.Replace(".com","")
}   

function StartUpCred{
    #Connect to Cloud Tenant use CADM.Firstname.Lastname account
    Connect-MsolService -WarningAction Stop
    #Domain Admin account Creds to run the script dir sync 
    $script:cred = Get-Credential $script:SplitDomain\admin.gb
}

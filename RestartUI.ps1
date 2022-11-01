#Start-Sleep -Seconds 90

$r = Get-Content C:\pending_results.txt

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type @'
using System.Windows.Forms;
public class FormWithoutX : Form {
  protected override CreateParams CreateParams
  {
    get {
      CreateParams cp = base.CreateParams;
      cp.ClassStyle = cp.ClassStyle | 0x200;
      return cp;
    }
  }

}
'@ -ReferencedAssemblies System.Windows.Forms

$PostponeCounter = 0

# Create a new form
$RestartForm                    = [FormWithoutX]::new()

# Create confirmation form
$ConfirmForm                    = [FormWithoutX]::new()

# Create postpone form
$PostponeForm                   = [FormWithoutX]::new()

#$Icon				            = New-Object system.drawing.icon ("C:\Users\Zach S\AppData\Local\Microsoft\Office\SolutionPackages\9641fb159bad7fd251f0672bc0c49dc2\PackageResources\win32\favicon.ico")
$ConfirmForm.ClientSize         = '540,150'
$ConfirmForm.text               = "AIS - Restart Confirmation"
$ConfirmForm.BackColor          = "#ffffff"
#$ConfirmForm.Icon		        = $Icon
$ConfirmForm.AutoScale          = $true

# Define the size, title and background color
#$Icon				            = New-Object system.drawing.icon ("C:\Users\Zach S\AppData\Local\Microsoft\Office\SolutionPackages\9641fb159bad7fd251f0672bc0c49dc2\PackageResources\win32\favicon.ico")
$RestartForm.ClientSize         = '500,300'
$RestartForm.text               = "Adaptive Information Systems - Restart Notice"
$RestartForm.BackColor          = "#ffffff"
#$RestartForm.Icon		        = $Icon
$RestartForm.AutoScale          = $true

$PostponeForm.ClientSize         = '500,300'
$PostponeForm.text               = "Adaptive Information Systems - Postpone"
$PostponeForm.BackColor          = "#ffffff"
#$PostponeForm.Icon		         = $Icon
$PostponeForm.AutoScale          = $true

# Create a Title for our form. We will use a label for it.
$Titel                           = New-Object system.Windows.Forms.Label

# The content of the label
$Titel.text                      = "Restart needed to apply updates"

# Make sure the label is sized the height and length of the content
$Titel.AutoSize                  = $true

# Define the minial width and height (not nessary with autosize true)
$Titel.width                     = 25
$Titel.height                    = 10

# Position the element
$Titel.location                  = New-Object System.Drawing.Point(20,20)

# Define the font type and size
$Titel.Font                      = 'Microsoft Sans Serif,13'

# Create a Title for our form. We will use a label for it.
$PTitel                           = New-Object system.Windows.Forms.Label

# The content of the label
$PTitel.text                      = "Confirm time to postpone restart"

# Make sure the label is sized the height and length of the content
$PTitel.AutoSize                  = $true

# Define the minial width and height (not nessary with autosize true)
$PTitel.width                     = 25
$PTitel.height                    = 10

# Position the element
$PTitel.location                  = New-Object System.Drawing.Point(20,20)

# Define the font type and size
$PTitel.Font                      = 'Microsoft Sans Serif,13'

# Other elemtents
$Description                     = New-Object system.Windows.Forms.Label
$Description.text                = "Updates have been downloaded in the background and are waiting for a restart to install."
$Description.AutoSize            = $false
$Description.width               = 450
$Description.height              = 50
$Description.location            = New-Object System.Drawing.Point(20,50)
$Description.Font                = 'Microsoft Sans Serif,10'

$CDescription                     = New-Object system.Windows.Forms.Label
$CDescription.text                = "Make sure all files are saved and programs are closed in order to prevent data loss."
$CDescription.AutoSize            = $true
$CDescription.width               = 550
$CDescription.height              = 50
$CDescription.location            = New-Object System.Drawing.Point(20,50)
$CDescription.Font                = 'Microsoft Sans Serif,10'

$PDescription                     = New-Object system.Windows.Forms.Label
$PDescription.text                = "Restart prompt will reappear after the selected amount of time"
$PDescription.AutoSize            = $true
$PDescription.width               = 550
$PDescription.height              = 50
$PDescription.location            = New-Object System.Drawing.Point(20,50)
$PDescription.Font                = 'Microsoft Sans Serif,10'

$PaDescription                     = New-Object system.Windows.Forms.Label
$PaDescription.text                = "Amount of times restart has been postponed: "+$Script:PostponeCounter
$PaDescription.AutoSize            = $true
$PaDescription.width               = 550
$PaDescription.height              = 50
$PaDescription.location            = New-Object System.Drawing.Point(20,100)
$PaDescription.Font                = 'Microsoft Sans Serif,10'

$RestartBtn                   = New-Object system.Windows.Forms.Button
$RestartBtn.BackColor         = "#a4ba67"
$RestartBtn.text              = "Restart"
$RestartBtn.width             = 90
$RestartBtn.height            = 30
$RestartBtn.location          = New-Object System.Drawing.Point(260,250)
$RestartBtn.Font              = 'Microsoft Sans Serif,10'
$RestartBtn.ForeColor         = "#ffffff"

$ConfirmBtn                   = New-Object system.Windows.Forms.Button
$ConfirmBtn.BackColor         = "#a4ba67"
$ConfirmBtn.text              = "Confirm"
$ConfirmBtn.width             = 90
$ConfirmBtn.height            = 30
$ConfirmBtn.location          = New-Object System.Drawing.Point(170,110)
$ConfirmBtn.Font              = 'Microsoft Sans Serif,10'
$ConfirmBtn.ForeColor         = "#ffffff"

$ConfirmBackBtn                   = New-Object system.Windows.Forms.Button
$ConfirmBackBtn.BackColor         = "#ffffff"
$ConfirmBackBtn.text              = "Back"
$ConfirmBackBtn.width             = 90
$ConfirmBackBtn.height            = 30
$ConfirmBackBtn.location          = New-Object System.Drawing.Point(270,110)
$ConfirmBackBtn.Font              = 'Microsoft Sans Serif,10'
$ConfirmBackBtn.ForeColor         = "#000000"

$PostponeBackBtn                   = New-Object system.Windows.Forms.Button
$PostponeBackBtn.BackColor         = "#ffffff"
$PostponeBackBtn.text              = "Back"
$PostponeBackBtn.width             = 90
$PostponeBackBtn.height            = 30
$PostponeBackBtn.location          = New-Object System.Drawing.Point(50,250)
$PostponeBackBtn.Font              = 'Microsoft Sans Serif,10'
$PostponeBackBtn.ForeColor         = "#000000"

$PostponeBtn                       = New-Object system.Windows.Forms.Button
$PostponeBtn.BackColor             = "#ffffff"
$PostponeBtn.text                  = "Postpone"
$PostponeBtn.width                 = 90
$PostponeBtn.height                = 30
$PostponeBtn.location              = New-Object System.Drawing.Point(370,250)
$PostponeBtn.Font                  = 'Microsoft Sans Serif,10'
$PostponeBtn.ForeColor             = "#000"

$PostponeAmt                     = New-Object system.Windows.Forms.ComboBox
$PostponeAmt.text                = ""
$PostponeAmt.width               = 90
$PostponeAmt.autosize            = $true

# Add the items in the dropdown list
@('15 Minutes','30 Minutes', '45 minutes', '1 hour') | ForEach-Object {[void] $PostponeAmt.Items.Add($_)}

# Select the default value
$PostponeAmt.SelectedIndex       = 0
$PostponeAmt.location            = New-Object System.Drawing.Point(370,200)
$PostponeAmt.Font                = 'Microsoft Sans Serif,10'
$PostponeAmt.DropDownStyle       = [System.Windows.Forms.ComboBoxStyle]::DropDownList;

$PConfirmBtn                       = New-Object system.Windows.Forms.Button
$PConfirmBtn.BackColor             = "#ffffff"
$PConfirmBtn.text                  = "Postpone"
$PConfirmBtn.width                 = 90
$PConfirmBtn.height                = 30
$PConfirmBtn.location              = New-Object System.Drawing.Point(370,240)
$PConfirmBtn.Font                  = 'Microsoft Sans Serif,10'
$PConfirmBtn.ForeColor             = "#000"


# ADD OTHER ELEMENTS ABOVE THIS LINE

# Add the elements to the form
$RestartForm.controls.AddRange(@($Titel,$Description,$RestartBtn, $PostponeBtn))

function PostponeClick {
    [void]$RestartForm.Hide()
    $PostponeForm.Controls.AddRange(@($PTitel, $PDescription, $PaDescription, $PostponeBackBtn, $PostponeAmt, $PConfirmBtn))
    [void]$PostponeForm.ShowDialog()
}

function RestartClick {
    [void]$RestartForm.Hide()
    $ConfirmForm.controls.AddRange(@($ConfirmBtn, $ConfirmBackBtn, $CDescription))
    [void]$ConfirmForm.ShowDialog()
}

function ConfirmClick {
    [void]$ConfirmForm.Close()
    Restart-Computer -Force
}

# Handles dropdown selection, can add more, as values are decided on

function PConfirmClick {
    if ($PostponeAmt.SelectedValue = "15 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 15 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedValue = "30 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 30 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedValue = "45 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 45 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedValue = "1 hour") {
        [void]$PostponeForm.Hide()
        $sleep = 60 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
}

function ConfirmBackClick {
    [void]$PostponeForm.Hide()
    [void]$ConfirmForm.Hide()
    [void]$RestartForm.Show()
}

function PostponeBackClick {
    [void]$PostponeForm.Hide()
    [void]$ConfirmForm.Hide()
    [void]$RestartForm.Show()
}

function Increment {
    $Script:PostponeCounter++
    $PaDescription.Text = "Amount of times restart has been postponed: "+$Script:PostponeCounter
}

$ConfirmBtn.Add_Click({ConfirmClick})

$RestartBtn.Add_Click({RestartClick})

$PostponeBtn.Add_Click({PostponeClick})

$PConfirmBtn.Add_Click({PConfirmClick})

$ConfirmBackBtn.Add_Click({ConfirmBackClick})

$PostponeBackBtn.Add_Click({PostponeBackClick})

# THIS SHOULD BE AT THE END OF YOUR SCRIPT FOR NOW
# Display the form
if ($r.Contains("True")) {
    [void]$RestartForm.ShowDialog()
}
else {
    echo "No restart needed."
    Exit
}
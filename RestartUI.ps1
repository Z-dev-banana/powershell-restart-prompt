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

$15Minutes = [timespan] '0:15'

# Start time, based on now 
$rawStartTime = Get-Date
$startTime = [datetime]::new(
  [long] [Math]::Ceiling($rawStartTime.Ticks / $15Minutes.Ticks) * $15Minutes.Ticks,
  $rawStartTime.Kind
)

$endTime = $startTime.AddHours(5)

# Create an array of time-of-day strings in 15-minute intervals 
# between the start and end time, inclusively:
[string[]] $timeStrings = 
  while ($startTime -le $endTime) {
    $startTime.ToString('h:mm tt') # format and output
    $startTime += $15Minutes
  }

$PostponeCounter = 0

# Create a new form
$RestartForm                    = [FormWithoutX]::new()

# Create confirmation form
$ConfirmForm                    = [FormWithoutX]::new()

# Create postpone form
$PostponeForm                   = [FormWithoutX]::new()

# Create set time form
$SetTimeForm                   = [FormWithoutX]::new()

#$Icon				            = New-Object system.drawing.icon ("C:\Users\Zach S\AppData\Local\Microsoft\Office\SolutionPackages\9641fb159bad7fd251f0672bc0c49dc2\PackageResources\win32\favicon.ico")
$ConfirmForm.ClientSize         = '540,150'
$ConfirmForm.text               = "Adaptive Information Systems - Restart Confirmation"
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

$SetTimeForm.ClientSize         = '500,300'
$SetTimeForm.text               = "Adaptive Information Systems - Restart Time Select"
$SetTimeForm.BackColor          = "#ffffff"
#$SetTimeForm.Icon		        = $Icon
$SetTimeForm.AutoScale          = $true

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
$PDescription.text                = "Are you ready to restart now?"
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

$TDescription                     = New-Object system.Windows.Forms.Label
$TDescription.text                = "Select a time to restart the computer. A confirmation will appear before actual restart."
$TDescription.AutoSize            = $false
$TDescription.width               = 450
$TDescription.height              = 50
$TDescription.location            = New-Object System.Drawing.Point(20,50)
$TDescription.Font                = 'Microsoft Sans Serif,10'

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
$ConfirmBtn.Enabled           = $false
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

# Why is this button object level with the Postpone button even though y = 240 here and y= 250 there, world may never know
$ConfirmBackPostBtn                   = New-Object system.Windows.Forms.Button
$ConfirmBackPostBtn.BackColor         = "#ffffff"
$ConfirmBackPostBtn.text              = "Restart"
$ConfirmBackPostBtn.width             = 90
$ConfirmBackPostBtn.height            = 30
$ConfirmBackPostBtn.location          = New-Object System.Drawing.Point(270,240) 
$ConfirmBackPostBtn.Font              = 'Microsoft Sans Serif,10'
$ConfirmBackPostBtn.ForeColor         = "#000000"

$ConfirmCheckbox                      = New-Object System.Windows.Forms.CheckBox
$ConfirmCheckbox.Text                 = "I'm ready"
$ConfirmCheckbox.Checked              = $false
$ConfirmCheckbox.location             = New-Object System.Drawing.Point(30,80)

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

$TimePicker =  New-Object system.Windows.Forms.ComboBox
$TimePicker.Width = 90

@($timeStrings) | ForEach-Object {[void] $TimePicker.Items.Add($_)}

$TimePicker.SelectedIndex          = 0
$TimePicker.Font                   = 'Microsoft Sans Serif,10'
$TimePicker.Location               = New-Object System.Drawing.Point(370,200)
$TimePicker.DropdownStyle          = [System.Windows.Forms.ComboBoxStyle]::DropDownList;

$TConfirmBtn                       = New-Object system.Windows.Forms.Button
$TConfirmBtn.BackColor             = "#ffffff"
$TConfirmBtn.text                  = "Set Time"
$TConfirmBtn.width                 = 90
$TConfirmBtn.height                = 30
$TConfirmBtn.location              = New-Object System.Drawing.Point(370,240)
$TConfirmBtn.Font                  = 'Microsoft Sans Serif,10'
$TConfirmBtn.ForeColor             = "#000"

# ADD OTHER ELEMENTS ABOVE THIS LINE

# Add the elements to the form
$RestartForm.controls.AddRange(@($Titel,$Description,$RestartBtn, $PostponeBtn))

function PostponeClick {
    [void]$RestartForm.Hide()
    $PostponeForm.Controls.AddRange(@($PTitel, $PDescription, $PaDescription, $ConfirmBackPostBtn, $PostponeAmt, $PConfirmBtn))
    [void]$PostponeForm.ShowDialog()
}

function SetTimeClick {
    [void]$RestartForm.Hide()
    $SetTimeForm.controls.AddRange(@($TDescription, $PTitle, $TimePicker, $TConfirmBtn))
    [void]$SetTimeForm.ShowDialog()
}

function RestartClick {
    [void]$RestartForm.Hide()
    $ConfirmForm.controls.AddRange(@($ConfirmBtn, $ConfirmBackBtn, $CDescription, $ConfirmCheckbox))
    [void]$ConfirmForm.ShowDialog()
}

function ConfirmClick {
    [void]$ConfirmForm.Close()
    $PostponeCounter | Out-File -FilePath C:\attempts.txt
    Restart-Computer -Force -WhatIf
}

# Handles dropdown selection, can add more, as values are decided on

function PConfirmClick {
    if ($PostponeAmt.SelectedItem -eq "15 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 15 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedItem -eq "30 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 30 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedItem -eq "45 minutes") {
        [void]$PostponeForm.Hide()
        $sleep = 45 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
    elseif ($PostponeAmt.SelectedItem -eq "1 hour") {
        [void]$PostponeForm.Hide()
        $sleep = 60 * 60
        Increment
        Start-Sleep -Seconds $sleep
        [void]$PostponeForm.Show()
    }
}

function TConfirmClick {
    # Checks seconds before selected restart time \\ Write-Host (New-TimeSpan -End ([datetime]::ParseExact($TimePicker.SelectedItem, "h:mm tt", $null))).TotalSeconds
    [void]$SetTimeForm.Hide()
    (New-TimeSpan -End ([datetime]::ParseExact($TimePicker.SelectedItem, "h:mm tt", $null))).TotalSeconds | Sleep
    Increment
    RestartClick
}

function ConfirmBackClick {
    [void]$PostponeForm.Hide()
    [void]$ConfirmForm.Hide()
    [void]$RestartForm.Hide()
    [void]$SetTimeForm.Hide()
    PostponeClick
}

function ConfirmBackPostClick {
    [void]$PostponeForm.Hide()
    [void]$ConfirmForm.Show()
    [void]$RestartForm.Hide()
    [void]$SetTimeForm.Hide()
}

function Increment {
    $Script:PostponeCounter++
    $PaDescription.Text = "Amount of times restart has been postponed: "+$Script:PostponeCounter
}

function test-checkbox-value {
    if ($ConfirmCheckbox.Checked) {
        $ConfirmBtn.Enabled = $true
    } else {
        $ConfirmBtn.Enabled = $false
    }
}

$ConfirmBtn.Add_Click({ConfirmClick})

$RestartBtn.Add_Click({RestartClick})

$PostponeBtn.Add_Click({SetTimeClick})

$PConfirmBtn.Add_Click({PConfirmClick})

$ConfirmBackBtn.Add_Click({ConfirmBackClick})

$ConfirmBackPostBtn.Add_Click({ConfirmBackPostClick})

$TConfirmBtn.Add_Click({TConfirmClick})

$ConfirmCheckbox.Add_CheckedChanged({test-checkbox-value})

# THIS SHOULD BE AT THE END OF YOUR SCRIPT FOR NOW
# Display the form
if ($r.Contains("True")) {
    
    [void]$RestartForm.ShowDialog()
}
else {
    echo "No restart needed."
    Exit
}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Hide PowerShell console window
$consolePtr = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($consolePtr, 0)  # 0 = SW_HIDE

# Registry path and value
$regPath = "HKCU:\Software\eDisclosure"
$regName = "Acknowledged"
$regValue = "Yes"  # store Yes

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "!!!FORM NAME!!!"
$form.Size = New-Object System.Drawing.Size(800,650)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true

# Header Label
$labelHeader = New-Object System.Windows.Forms.Label
$labelHeader.Text = "!!!MESSAGE HEADING!!!"
$labelHeader.Font = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$labelHeader.AutoSize = $true
$labelHeader.Location = New-Object System.Drawing.Point(10,10)
$form.Controls.Add($labelHeader)

# Message TextBox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ReadOnly = $true
$textBox.WordWrap = $true
$textBox.TabStop = $false
$textBox.BorderStyle = "None"
$textBox.BackColor = $form.BackColor
$textBox.Font = New-Object System.Drawing.Font("Consolas",11)
$textBox.Size = New-Object System.Drawing.Size(760,500)
$textBox.Location = New-Object System.Drawing.Point(10,40)

$textBox.Text = @"
!!! WRITE YOUR MESSAGE HERE!!!
"@

$form.Controls.Add($textBox)

# Acknowledge Button
$ackButton = New-Object System.Windows.Forms.Button
$ackButton.Text = "Acknowledge"
$ackButton.Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold)
$ackButton.Size = New-Object System.Drawing.Size(120,35)
$ackButton.Location = New-Object System.Drawing.Point(340,560)

# Add click event to write registry key and close form
$ackButton.Add_Click({
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    # Write the registry value with timestamp
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force

    # Close the form
    $form.Close()
})

$form.Controls.Add($ackButton)

# Set focus on button
$form.Add_Shown({ $ackButton.Focus() })

# Show Form
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($form)

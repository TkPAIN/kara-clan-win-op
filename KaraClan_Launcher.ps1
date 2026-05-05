Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Kara Clan • Windows Optimizer 2026"
$form.Size = New-Object System.Drawing.Size(820, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 23, 42)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# Title
$title = New-Object System.Windows.Forms.Label
$title.Text = "KARA CLAN"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Gold
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(290, 30)
$form.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "WINDOWS OPTIMIZER 2026 • ES / EN"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$subtitle.ForeColor = [System.Drawing.Color]::LightGray
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(265, 80)
$form.Controls.Add($subtitle)

# Function to create big buttons
function Create-BigButton($text, $y, $color, $action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(380, 85)
    $btn.Location = New-Object System.Drawing.Point(220, $y)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $btn.BackColor = $color
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Add_Click($action)
    $form.Controls.Add($btn)
}

# Vol.1
Create-BigButton "🚀 Vol.1 - BASIC / ESENCIAL" 160 ([System.Drawing.Color]::FromArgb(0, 122, 204)) {
    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v1.ps1 | iex"' -Verb RunAs
}

# Vol.2
Create-BigButton "🚀 Vol.2 - ADVANCED / AVANZADO" 260 ([System.Drawing.Color]::FromArgb(0, 180, 0)) {
    [System.Windows.Forms.MessageBox]::Show("Vol.2 is coming very soon!`n`nFor now please use Vol.1", "Kara Clan", "OK", "Information")
}

# Vol.3
Create-BigButton "🚀 Vol.3 - COMPLETE / COMPLETO" 360 ([System.Drawing.Color]::FromArgb(255, 140, 0)) {
    [System.Windows.Forms.MessageBox]::Show("Vol.3 is coming very soon!`n`nFor now please use Vol.1", "Kara Clan", "OK", "Information")
}

# Revert
Create-BigButton "🔄 REVERT ALL CHANGES / REVERTIR TODO" 470 ([System.Drawing.Color]::FromArgb(200, 40, 40)) {
    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/Revert_Optimizer.ps1 | iex"' -Verb RunAs
}

# Footer
$footer = New-Object System.Windows.Forms.Label
$footer.Text = "✅ One-click • Runs as Administrator • 100% Open Source • Made with ❤️ by TkPAIN"
$footer.ForeColor = [System.Drawing.Color]::Gray
$footer.AutoSize = $true
$footer.Location = New-Object System.Drawing.Point(140, 590)
$form.Controls.Add($footer)

$form.ShowDialog() | Out-Null
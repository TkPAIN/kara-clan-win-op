Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Kara Clan • Windows Optimizer 2026"
$form.Size = New-Object System.Drawing.Size(820, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 23, 42)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

$title = New-Object System.Windows.Forms.Label
$title.Text = "KARA CLAN"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Gold
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(290, 30)
$form.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "WINDOWS OPTIMIZER 2026"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$subtitle.ForeColor = [System.Drawing.Color]::LightGray
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(265, 80)
$form.Controls.Add($subtitle)

function Create-BigButton($text, $y, $color, $script) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(380, 85)
    $btn.Location = New-Object System.Drawing.Point(220, $y)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $btn.BackColor = $color
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Add_Click({
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/$using:script | iex`"" -Verb RunAs
    })
    $form.Controls.Add($btn)
}

Create-BigButton "Vol.1 - BASICA" 160 ([System.Drawing.Color]::FromArgb(0, 122, 204)) "OptimizarWindows_v1.ps1"
Create-BigButton "Vol.2 - AVANZADA" 260 ([System.Drawing.Color]::FromArgb(0, 180, 0)) "OptimizarWindows_v2.ps1"
Create-BigButton "Vol.3 - COMPLETA" 360 ([System.Drawing.Color]::FromArgb(255, 140, 0)) "OptimizarWindows_v3.ps1"
Create-BigButton "REVERTIR TODO" 470 ([System.Drawing.Color]::FromArgb(200, 40, 40)) "Revert_Optimizer.ps1"

$form.ShowDialog() | Out-Null

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

function Run-Script($name) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/$name | iex`"" -Verb RunAs
}

$btn1 = New-Object System.Windows.Forms.Button; $btn1.Text = "🚀 Vol.1 - BÁSICA"; $btn1.Size = New-Object System.Drawing.Size(380,85); $btn1.Location = New-Object System.Drawing.Point(220,160); $btn1.BackColor = [System.Drawing.Color]::FromArgb(0,122,204); $btn1.ForeColor = "White"; $btn1.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold); $btn1.FlatStyle = "Flat"; $btn1.FlatAppearance.BorderSize = 0; $btn1.Add_Click({Run-Script "OptimizarWindows_v1.ps1"}); $form.Controls.Add($btn1)
$btn2 = New-Object System.Windows.Forms.Button; $btn2.Text = "🚀 Vol.2 - AVANZADA"; $btn2.Size = New-Object System.Drawing.Size(380,85); $btn2.Location = New-Object System.Drawing.Point(220,260); $btn2.BackColor = [System.Drawing.Color]::FromArgb(0,180,0); $btn2.ForeColor = "White"; $btn2.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold); $btn2.FlatStyle = "Flat"; $btn2.FlatAppearance.BorderSize = 0; $btn2.Add_Click({Run-Script "OptimizarWindows_v2.ps1"}); $form.Controls.Add($btn2)
$btn3 = New-Object System.Windows.Forms.Button; $btn3.Text = "🚀 Vol.3 - COMPLETA"; $btn3.Size = New-Object System.Drawing.Size(380,85); $btn3.Location = New-Object System.Drawing.Point(220,360); $btn3.BackColor = [System.Drawing.Color]::FromArgb(255,140,0); $btn3.ForeColor = "White"; $btn3.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold); $btn3.FlatStyle = "Flat"; $btn3.FlatAppearance.BorderSize = 0; $btn3.Add_Click({Run-Script "OptimizarWindows_v3.ps1"}); $form.Controls.Add($btn3)
$btnR = New-Object System.Windows.Forms.Button; $btnR.Text = "🔄 REVERTIR TODO"; $btnR.Size = New-Object System.Drawing.Size(380,85); $btnR.Location = New-Object System.Drawing.Point(220,470); $btnR.BackColor = [System.Drawing.Color]::FromArgb(200,40,40); $btnR.ForeColor = "White"; $btnR.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold); $btnR.FlatStyle = "Flat"; $btnR.FlatAppearance.BorderSize = 0; $btnR.Add_Click({Run-Script "Revert_Optimizer.ps1"}); $form.Controls.Add($btnR)

$form.ShowDialog() | Out-Null

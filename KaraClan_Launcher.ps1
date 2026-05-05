Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Kara Clan • Windows Optimizer 2026"
$form.Size = New-Object System.Drawing.Size(820, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15,23,42)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

$title = New-Object System.Windows.Forms.Label
$title.Text = "KARA CLAN"
$title.Font = New-Object System.Drawing.Font("Segoe UI",32,[System.Drawing.FontStyle]::Bold)
$title.ForeColor = "Gold"
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(290,30)
$form.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "WINDOWS OPTIMIZER 2026"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI",14)
$subtitle.ForeColor = "LightGray"
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(265,80)
$form.Controls.Add($subtitle)

# URLs de los scripts (cámbialas si quieres usar .ps1 en vez de .bat)
$scripts = @{
    "Vol.1 – BÁSICA"    = "https://github.com/TkPAIN/kara-clan-win-op/blob/main/OptimizarWindows_v1.ps1"
    "Vol.2 – AVANZADA"  = "https://github.com/TkPAIN/kara-clan-win-op/blob/main/OptimizarWindows_v2.ps1"
    "Vol.3 – COMPLETA"  = "https://github.com/TkPAIN/kara-clan-win-op/blob/main/OptimizarWindows_v3.ps1"
    "REVERTIR TODO"     = "https://github.com/TkPAIN/kara-clan-win-op/blob/main/Revert_Optimizer.ps1"
}

# Función para ejecutar script como administrador
function Run-Script($url) {
    $psCommand = "irm '$url' | iex"
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command $psCommand" -Verb RunAs
}

$y = 160
foreach ($name in $scripts.Keys) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "🚀 $name"
    $btn.Size = New-Object System.Drawing.Size(380, 85)
    $btn.Location = New-Object System.Drawing.Point(220, $y)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $btn.ForeColor = "White"
    # Colores por botón
    switch ($name) {
        "Vol.1 – BÁSICA"    { $btn.BackColor = "#007ACD" }
        "Vol.2 – AVANZADA"  { $btn.BackColor = "#00B400" }
        "Vol.3 – COMPLETA"  { $btn.BackColor = "#FF8C00" }
        "REVERTIR TODO"     { $btn.BackColor = "#C82828" }
    }
    $url = $scripts[$name]
    $btn.Add_Click({ Run-Script $url })
    $form.Controls.Add($btn)
    $y += 100
}

$form.ShowDialog() | Out-Null

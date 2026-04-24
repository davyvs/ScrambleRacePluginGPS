$yamlBlock = Get-Content 'C:/Users/Davyv/Desktop/ac-scripts/scramble_arrival_config.yaml' -Raw -Encoding UTF8

$base = 'C:/Users/Davyv/Desktop/ACSERVER(0.54)'
$servers = @(
    '(server01) ChilledDVS - Shutoko Lane Switch AI - Vanilla Cars',
    '(server02) ChilledDVS - Shutoko - Lane split AI - Modded Cars',
    '(server03) ChilledDVS - Shutoko - F1',
    '(server11) ChilledDVS- SDC - Vanilla Cars',
    '(server12) ChilledDVS - SDC - Modded Cars',
    '(server25) ChilledDVS - SDC - WRC',
    '(server26) ChilledDVS - Extra Server'
)

foreach ($s in $servers) {
    $cfg = "$base/$s/cfg/extra_cfg.yml"
    if (-not (Test-Path $cfg)) { Write-Host "SKIP (not found): $cfg"; continue }

    $content = Get-Content $cfg -Raw -Encoding UTF8

    # 1. Add ScrambleArrivalPlugin to EnablePlugins if not already present
    if ($content -notmatch 'ScrambleArrivalPlugin') {
        if ($content -match 'ScrambleRacePlugin') {
            $content = $content -replace '(  - ScrambleRacePlugin)', "`$1`n  - ScrambleArrivalPlugin"
        } else {
            $content = $content -replace '(# Ignore some common)', "  - ScrambleArrivalPlugin`n`$1"
        }
        Write-Host "  Added to EnablePlugins"
    } else {
        Write-Host "  Already in EnablePlugins"
    }

    # 2. Append YAML config block if not already present
    if ($content -notmatch '!ScrambleArrivalConfiguration') {
        $content = $content.TrimEnd("`n", "`r") + "`n" + $yamlBlock
        Write-Host "  Appended config block"
    } else {
        Write-Host "  Config block already present"
    }

    $content | Set-Content $cfg -Encoding UTF8 -NoNewline
    Write-Host "DONE: $s"
    Write-Host ""
}
Write-Host "All servers updated."

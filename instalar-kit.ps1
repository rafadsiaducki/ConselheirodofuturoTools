# ============================================================
#  Kit de Edicao de Video com AI - Conselheiro do Futuro
#  Windows (PowerShell). Uso, em uma linha:
#    irm https://raw.githubusercontent.com/rafadsiaducki/ConselheirodofuturoTools/main/instalar-kit.ps1 | iex
#  Confere cada item: se ja estiver instalado, so avisa; se faltar, instala.
# ============================================================

$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'
$SkillsDir = Join-Path $HOME '.claude\skills'
$Resumo    = New-Object System.Collections.ArrayList

function Say($tag, $msg, $color) { Write-Host ("[{0}] {1}" -f $tag, $msg) -ForegroundColor $color }
function Add-Res($item, $status) { [void]$Resumo.Add([pscustomobject]@{ Item = $item; Status = $status }) }
function Has($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')
}
function Winget-Install($id) {
    winget install -e --id $id --silent --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null
    Refresh-Path
}

function Test-Node   { if (-not (Has node))   { return $false }; try { [int]((node --version).TrimStart('v').Split('.')[0]) -ge 22 } catch { $false } }
function Test-Python { if (-not (Has python)) { return $false }; [bool]((python --version 2>&1 | Out-String) -match 'Python 3\.(1[1-9]|[2-9][0-9])') }
function Test-Git    { Has git }
function Test-Ffmpeg { (Has ffmpeg) -and (Has ffprobe) }
function Test-Ytdlp  { Has yt-dlp }
function Test-Whisper {
    if (-not (Test-Python)) { return $false }
    python -c "import whisper" 2>&1 | Out-Null
    return ($LASTEXITCODE -eq 0)
}

function Ensure-Program($nome, $teste, $wingetId, $upgrade) {
    if (& $teste) { Say 'OK' "$nome - ja esta instalado" Green; Add-Res $nome 'ja estava instalado'; return }
    if (-not (Has winget)) { Say 'ERRO' "$nome - falta e o winget nao existe nesta maquina. Instale o 'App Installer' pela Microsoft Store." Red; Add-Res $nome 'ERRO: sem winget'; return }
    Say '..' "$nome - instalando (pode pedir permissao de administrador)..." Yellow
    if ($upgrade) { winget upgrade -e --id $wingetId --silent --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null; Refresh-Path }
    if (-not (& $teste)) { Winget-Install $wingetId }
    if (& $teste) { Say 'OK' "$nome - instalado" Green; Add-Res $nome 'instalado agora' }
    else { Say 'ERRO' "$nome - nao consegui confirmar. Feche e abra o terminal e rode o instalador de novo." Red; Add-Res $nome 'ERRO: reabra o terminal e rode de novo' }
}

function Ensure-Skill($nome, $pasta, [string[]]$npxArgs, [string[]]$fallbackArgs) {
    $alvo = Join-Path $SkillsDir $pasta
    if (Test-Path $alvo) { Say 'OK' "$nome - ja esta instalado" Green; Add-Res $nome 'ja estava instalado'; return }
    if (-not (Test-Node)) { Say 'ERRO' "$nome - precisa do Node.js 22+ (falhou acima)." Red; Add-Res $nome 'ERRO: sem Node.js'; return }
    Say '..' "$nome - instalando..." Yellow
    $saida = & npx.cmd -y @npxArgs 2>&1 | Out-String
    if (-not (Test-Path $alvo) -and $fallbackArgs) { $saida = & npx.cmd -y @fallbackArgs 2>&1 | Out-String }
    if (Test-Path $alvo) { Say 'OK' "$nome - instalado" Green; Add-Res $nome 'instalado agora' }
    else {
        Say 'ERRO' "$nome - falhou. Ultimas linhas:" Red
        ($saida -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 6) | ForEach-Object { Write-Host "       $_" }
        Add-Res $nome 'ERRO (ver mensagem acima)'
    }
}

Write-Host ''
Write-Host '=============================================' -ForegroundColor Cyan
Write-Host '  Kit de Edicao de Video com AI'               -ForegroundColor Cyan
Write-Host '  Conselheiro do Futuro'                       -ForegroundColor Cyan
Write-Host '=============================================' -ForegroundColor Cyan
Write-Host ''

# ---------- 1. Programas ----------
Write-Host '--- Programas ---' -ForegroundColor Cyan
Ensure-Program 'Node.js 22+' ${function:Test-Node}   'OpenJS.NodeJS.LTS'   $true
Ensure-Program 'Git'         ${function:Test-Git}    'Git.Git'             $false
Ensure-Program 'Python 3'    ${function:Test-Python} 'Python.Python.3.12'  $false
Ensure-Program 'FFmpeg'      ${function:Test-Ffmpeg} 'Gyan.FFmpeg'         $false
Ensure-Program 'yt-dlp'      ${function:Test-Ytdlp}  'yt-dlp.yt-dlp'       $false

# ---------- 2. Whisper ----------
Write-Host ''
Write-Host '--- Whisper ---' -ForegroundColor Cyan
if (Test-Whisper) { Say 'OK' 'Whisper - ja esta instalado' Green; Add-Res 'Whisper' 'ja estava instalado' }
elseif (-not (Test-Python)) { Say 'ERRO' 'Whisper - precisa do Python (falhou acima).' Red; Add-Res 'Whisper' 'ERRO: sem Python' }
else {
    Say '..' 'Whisper - instalando (cerca de 1 GB, leva alguns minutos)...' Yellow
    # Atualiza o pip. Se a rede tiver inspecao HTTPS (antivirus ou firewall da empresa),
    # o pip antigo falha com CERTIFICATE_VERIFY_FAILED; o --use-feature=truststore faz ele
    # usar os certificados do Windows. O pip 24.2+ ja faz isso sozinho.
    python -m pip install -q -U pip 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { python -m pip install -q -U pip --use-feature=truststore 2>&1 | Out-Null }
    $pipOut = python -m pip install -U openai-whisper --extra-index-url https://download.pytorch.org/whl/cpu 2>&1 | Out-String
    if (-not (Test-Whisper)) {
        $pipOut = python -m pip install -U openai-whisper --extra-index-url https://download.pytorch.org/whl/cpu --use-feature=truststore 2>&1 | Out-String
    }
    if (Test-Whisper) { Say 'OK' 'Whisper - instalado' Green; Add-Res 'Whisper' 'instalado agora' }
    elseif ($pipOut -match 'CERTIFICATE_VERIFY_FAILED|SSLError') {
        Say 'ERRO' 'Whisper - a rede bloqueou o download (inspecao HTTPS de antivirus ou firewall).' Red
        Write-Host '       Peca ao TI para liberar pypi.org, files.pythonhosted.org e download.pytorch.org,'
        Write-Host '       ou desative a verificacao HTTPS do antivirus so durante a instalacao.'
        Add-Res 'Whisper' 'ERRO: certificado da rede (ver acima)'
    }
    else {
        Say 'ERRO' 'Whisper - falhou. Ultimas linhas:' Red
        ($pipOut -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 6) | ForEach-Object { Write-Host "       $_" }
        Add-Res 'Whisper' 'ERRO (ver mensagem acima)'
    }
}
# Garante que o comando "whisper" funcione no terminal
if ((Test-Whisper) -and -not (Has whisper)) {
    $scripts = @(
        (python -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>$null),
        (python -c "import sysconfig; print(sysconfig.get_path('scripts', 'nt_user'))" 2>$null)
    ) | Where-Object { $_ -and (Test-Path (Join-Path $_ 'whisper.exe')) } | Select-Object -First 1
    if ($scripts) {
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$scripts*") { [Environment]::SetEnvironmentVariable('Path', "$userPath;$scripts", 'User') }
        Refresh-Path
    }
}

# ---------- 3. Skills de video para o Claude ----------
Write-Host ''
Write-Host '--- Skills do Claude ---' -ForegroundColor Cyan
Ensure-Skill 'Hyperframes' 'hyperframes' @('skills', 'add', 'heygen-com/hyperframes', '-g', '-y', '--skill', '*', '--agent', 'claude-code') $null
Ensure-Skill 'Impeccable'  'impeccable'  @('impeccable', 'install', '--providers=claude', '--scope=global') $null
Ensure-Skill 'Taste Skill' 'design-taste-frontend' @('skills', 'add', 'Leonxlnx/taste-skill', '-g', '-y', '--skill', '*', '--agent', 'claude-code') $null
Ensure-Skill 'Remotion'    'remotion-best-practices' @('skills', 'add', 'remotion-dev/skills', '-g', '-y', '--skill', '*', '--agent', 'claude-code') $null
Ensure-Skill 'Skill FFmpeg' 'ffmpeg' @('skills', 'add', 'digitalsamba/claude-code-video-toolkit', '-g', '-y', '--skill', 'ffmpeg', '--agent', 'claude-code') @('skills', 'add', 'TerminalSkills/skills', '-g', '-y', '--skill', 'ffmpeg', '--agent', 'claude-code')

# Chrome de renderizacao do Hyperframes (se ja existir, so confirma)
if (Test-Path (Join-Path $SkillsDir 'hyperframes')) {
    Say '..' 'Hyperframes - conferindo o Chrome de renderizacao...' Yellow
    & npx.cmd -y hyperframes browser ensure 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Say 'OK' 'Chrome de renderizacao pronto' Green; Add-Res 'Chrome do Hyperframes' 'pronto' }
    else { Say 'AVISO' 'Nao consegui preparar o Chrome. O render funciona, so que mais devagar.' Yellow; Add-Res 'Chrome do Hyperframes' 'aviso: render mais lento' }
}

# ---------- 4. Resumo ----------
Write-Host ''
Write-Host '=============== RESUMO ===============' -ForegroundColor Cyan
$Resumo | Format-Table -AutoSize | Out-String | Write-Host
$erros = @($Resumo | Where-Object { $_.Status -like 'ERRO*' }).Count
if ($erros -eq 0) {
    Write-Host 'Tudo pronto! Feche e abra o Claude Code para as skills aparecerem.' -ForegroundColor Green
    Write-Host 'Teste pedindo: "crie um video de 10 segundos com Hyperframes com um titulo animado".' -ForegroundColor Green
} else {
    Write-Host "$erros item(ns) com erro. Feche e abra o terminal e rode o instalador de novo." -ForegroundColor Yellow
    Write-Host 'Se continuar, copie a tela e mande para o Claude.' -ForegroundColor Yellow
}
Write-Host ''

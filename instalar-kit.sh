#!/usr/bin/env bash
# ============================================================
#  Kit de Edicao de Video com AI - Conselheiro do Futuro
#  macOS / Linux. Uso, em uma linha:
#    curl -fsSL https://raw.githubusercontent.com/rafadsiaducki/ConselheirodofuturoTools/main/instalar-kit.sh | bash
#  Confere cada item: se ja estiver instalado, so avisa; se faltar, instala.
# ============================================================

SKILLS_DIR="$HOME/.claude/skills"
RESUMO=""
ERROS=0
G='\033[32m'; Y='\033[33m'; R='\033[31m'; C='\033[36m'; N='\033[0m'

say()  { printf "${3}[%s] %s${N}\n" "$1" "$2"; }
res()  { RESUMO="${RESUMO}$(printf '%-24s %s' "$1" "$2")\n"; case "$2" in ERRO*) ERROS=$((ERROS+1));; esac; }
has()  { command -v "$1" >/dev/null 2>&1; }

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then PM="brew"; elif has apt-get; then PM="apt"; else PM=""; fi
SUDO=""; [ "$PM" = "apt" ] && [ "$(id -u)" -ne 0 ] && SUDO="sudo"

pkg_install() { # $1 = pacote brew, $2 = pacote apt
  case "$PM" in
    brew) brew install "$1" >/dev/null 2>&1 ;;
    apt)  $SUDO apt-get install -y "$2" >/dev/null 2>&1 ;;
    *)    return 1 ;;
  esac
}

test_node()   { has node && [ "$(node --version | sed 's/^v//; s/\..*//')" -ge 22 ] 2>/dev/null; }
test_git()    { has git; }
test_python() { has python3 && python3 -c 'import sys; exit(0 if sys.version_info >= (3,11) else 1)' 2>/dev/null; }
test_ffmpeg() { has ffmpeg && has ffprobe; }
test_ytdlp()  { has yt-dlp; }
test_whisper(){ has whisper; }

ensure_program() { # nome teste brew apt
  if $2; then say OK "$1 - ja esta instalado" "$G"; res "$1" "ja estava instalado"; return; fi
  say .. "$1 - instalando..." "$Y"
  if [ "$1" = "Node.js 22+" ] && [ "$PM" = "apt" ]; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO -E bash - >/dev/null 2>&1
  fi
  pkg_install "$3" "$4"
  hash -r
  if $2; then say OK "$1 - instalado" "$G"; res "$1" "instalado agora"
  else say ERRO "$1 - nao consegui instalar automaticamente." "$R"; res "$1" "ERRO"; fi
}

ensure_skill() { # nome pasta comando... (fallback separado por ||)
  local nome="$1" pasta="$2"; shift 2
  if [ -d "$SKILLS_DIR/$pasta" ]; then say OK "$nome - ja esta instalado" "$G"; res "$nome" "ja estava instalado"; return; fi
  if ! test_node; then say ERRO "$nome - precisa do Node.js 22+." "$R"; res "$nome" "ERRO: sem Node.js"; return; fi
  say .. "$nome - instalando..." "$Y"
  local saida; saida="$(eval "$*" 2>&1)"
  if [ -d "$SKILLS_DIR/$pasta" ]; then say OK "$nome - instalado" "$G"; res "$nome" "instalado agora"
  else say ERRO "$nome - falhou. Ultimas linhas:" "$R"; printf '%s\n' "$saida" | sed 's/\x1b\[[0-9;]*[A-Za-z]//g' | grep -v '^\s*$' | tail -6 | sed 's/^/       /'; res "$nome" "ERRO"; fi
}

printf "\n${C}=============================================\n  Kit de Edicao de Video com AI\n  Conselheiro do Futuro\n=============================================${N}\n\n"

if [ -z "$PM" ]; then say AVISO "Gerenciador de pacotes nao encontrado (precisa de Homebrew no Mac ou apt no Linux). Programas que faltarem nao serao instalados." "$Y"; fi
[ "$PM" = "apt" ] && $SUDO apt-get update -qq >/dev/null 2>&1

printf "${C}--- Programas ---${N}\n"
ensure_program "Node.js 22+" test_node   node      nodejs
ensure_program "Git"         test_git    git       git
ensure_program "Python 3"    test_python python@3.12 python3
ensure_program "FFmpeg"      test_ffmpeg ffmpeg    ffmpeg
[ "$PM" = "apt" ] && ! has unzip && $SUDO apt-get install -y unzip >/dev/null 2>&1
[ "$PM" = "apt" ] && ! has pipx && $SUDO apt-get install -y pipx >/dev/null 2>&1
[ "$PM" = "brew" ] && ! has pipx && brew install pipx >/dev/null 2>&1
export PATH="$HOME/.local/bin:$PATH"

printf "\n${C}--- Whisper e yt-dlp ---${N}\n"
for item in whisper yt-dlp; do
  if [ "$item" = whisper ]; then nome="Whisper"; t=test_whisper; pkg="openai-whisper"; args='--pip-args=--extra-index-url=https://download.pytorch.org/whl/cpu'
  else nome="yt-dlp"; t=test_ytdlp; pkg="yt-dlp"; args=""; fi
  [ "$OS" = "Darwin" ] && args=""
  if $t; then say OK "$nome - ja esta instalado" "$G"; res "$nome" "ja estava instalado"; continue; fi
  [ "$nome" = "Whisper" ] && say .. "Whisper - instalando (cerca de 1 GB, leva alguns minutos)..." "$Y" || say .. "$nome - instalando..." "$Y"
  if has pipx; then pipx install $args "$pkg" >/dev/null 2>&1; pipx ensurepath >/dev/null 2>&1; fi
  hash -r
  if $t; then say OK "$nome - instalado" "$G"; res "$nome" "instalado agora"
  else say ERRO "$nome - falhou. Tente: pipx install $pkg" "$R"; res "$nome" "ERRO"; fi
done

printf "\n${C}--- Skills do Claude ---${N}\n"
A="--agent claude-code"
ensure_skill "Hyperframes"  hyperframes             "npx -y skills add heygen-com/hyperframes -g -y --skill '*' $A"
ensure_skill "Impeccable"   impeccable              "npx -y impeccable install --providers=claude --scope=global"
ensure_skill "Taste Skill"  design-taste-frontend   "npx -y skills add Leonxlnx/taste-skill -g -y --skill '*' $A"
ensure_skill "Remotion"     remotion-best-practices "npx -y skills add remotion-dev/skills -g -y --skill '*' $A"
ensure_skill "Skill FFmpeg" ffmpeg                  "npx -y skills add digitalsamba/claude-code-video-toolkit -g -y --skill ffmpeg $A || npx -y skills add TerminalSkills/skills -g -y --skill ffmpeg $A"

if [ -d "$SKILLS_DIR/hyperframes" ]; then
  say .. "Hyperframes - conferindo o Chrome de renderizacao..." "$Y"
  if npx -y hyperframes browser ensure >/dev/null 2>&1; then say OK "Chrome de renderizacao pronto" "$G"; res "Chrome do Hyperframes" "pronto"
  else say AVISO "Nao consegui preparar o Chrome. O render funciona, so que mais devagar." "$Y"; res "Chrome do Hyperframes" "aviso: render mais lento"; fi
fi

printf "\n${C}=============== RESUMO ===============${N}\n"
printf "$RESUMO"
echo
if [ "$ERROS" -eq 0 ]; then
  printf "${G}Tudo pronto! Feche e abra o Claude Code para as skills aparecerem.${N}\n"
  printf "${G}Teste pedindo: \"crie um video de 10 segundos com Hyperframes com um titulo animado\".${N}\n"
else
  printf "${Y}%s item(ns) com erro. Feche e abra o terminal e rode o instalador de novo.${N}\n" "$ERROS"
  printf "${Y}Se continuar, copie a tela e mande para o Claude.${N}\n"
fi
echo

---
name: instalar-kit-edicao-video
description: Instala do zero o kit completo de edição de vídeo com AI: Hyperframes, Impeccable, Taste Skill, Remotion, FFmpeg e Whisper, com pré-requisitos e verificação final.
---

# Instalar o Kit de Edição de Vídeo

Use esta skill quando alguém pedir para "instalar as skills de vídeo", "preparar o computador para editar vídeo com AI", "montar o kit de edição" ou quando outra skill de vídeo falhar porque falta Hyperframes, Remotion, FFmpeg ou Whisper.

O objetivo é deixar a máquina da pessoa pronta, do zero, com:

| # | Item | O que é | Tipo |
|---|------|---------|------|
| 0 | Pré-requisitos | Node.js 22+, Git, Python 3.11/3.12 | Programas |
| 1 | Hyperframes (HeyGen) | Vídeo escrito em HTML + GSAP, renderizado em MP4 | Skills + CLI |
| 2 | Impeccable | Vocabulário de design: polish, bolder, critique, audit | Skill |
| 3 | Taste Skill | Anti-"AI slop": layout, tipografia e motion com bom gosto | Skills |
| 4 | Remotion | Vídeo programático com React | Skills |
| 5 | FFmpeg | Motor de corte, conversão, áudio e encode | Programa + skill |
| 6 | Whisper | Transcrição e legendas automáticas | Programa |
| 7 | Extras | yt-dlp (baixar referências) | Opcional |

---

## Regras antes de começar

1. **Onde rodar:** os comandos rodam no terminal do computador da pessoa. Se você tem um shell nessa máquina (por exemplo `device_bash` ou o Bash do Claude Code), rode você mesmo. Se não tem, entregue os comandos em blocos prontos para copiar e colar, um passo por vez, e peça para a pessoa colar a saída.
2. **Peça confirmação uma vez** antes de instalar programas no sistema (winget/brew/apt). Mostre a lista do que falta instalar e o tamanho aproximado (o Whisper com PyTorch passa de 2 GB).
3. **Não reinstale o que já existe.** Sempre detecte primeiro (Passo 1) e instale só o que está faltando ou desatualizado.
4. **Escopo das skills:** por padrão instale de forma **global** (`-g`), para valerem em qualquer projeto. Se a pessoa preferir só no projeto atual, tire o `-g` e rode dentro da pasta do projeto.
5. **Nunca peça senhas.** Se um comando pedir senha de administrador (sudo, UAC), a própria pessoa digita.
6. Em caso de erro, leia a mensagem, corrija a causa (ver "Problemas comuns") e tente de novo uma vez. Não fique repetindo o mesmo comando.

---

## Passo 1 — Detectar o sistema e o que já está instalado

Descubra o sistema operacional e rode o diagnóstico.

**Windows (PowerShell):**
```powershell
node --version; npm --version; git --version; python --version; ffmpeg -version | Select-Object -First 1; whisper --help | Select-Object -First 1; yt-dlp --version
```

**macOS / Linux:**
```bash
node --version; npm --version; git --version; python3 --version; ffmpeg -version | head -1; whisper --help | head -1; yt-dlp --version
```

Monte uma tabela "instalado / falta / versão antiga" e mostre para a pessoa. Critérios:
- Node.js precisa ser **22 ou maior** (exigência do Hyperframes). Abaixo disso, atualizar.
- Python: **3.11 ou 3.12** são os mais seguros para o Whisper.
- FFmpeg: qualquer versão recente com libx264 e AAC.

---

## Passo 2 — Instalar os pré-requisitos (só o que falta)

### Windows (winget)
```powershell
winget install -e --id OpenJS.NodeJS.LTS
winget install -e --id Git.Git
winget install -e --id Python.Python.3.12
winget install -e --id Gyan.FFmpeg
```
Depois de instalar, **feche e abra o terminal** para o PATH atualizar, e rode o Passo 1 de novo.

### macOS (Homebrew)
Se não tiver Homebrew, instale primeiro pelo site oficial brew.sh.
```bash
brew install node git python@3.12 ffmpeg
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update && sudo apt install -y git python3 python3-pip pipx ffmpeg unzip
# Node 22+: o apt do Ubuntu 24.04 traz Node 18 (antigo). Use o NodeSource ou nvm:
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
```

Confirme: `node --version` deve mostrar v22 ou maior, e `ffmpeg -version` deve responder.

---

## Passo 3 — Hyperframes (HeyGen)

Vídeo escrito como página HTML com timeline GSAP; a CLI captura cada frame no Chrome headless e codifica com FFmpeg. Requer Node 22+ e FFmpeg.

```bash
npx -y skills add heygen-com/hyperframes -g -y --all
```
`--all` instala o núcleo e todos os workflows sem abrir o seletor. Skills principais que ficam disponíveis: `/hyperframes`, `/hyperframes-core`, `/hyperframes-cli`, `/hyperframes-animation`, `/hyperframes-media` (TTS, transcrição com Whisper, remoção de fundo, legendas) e `/hyperframes-registry`.

Prepare o Chrome de renderização e verifique o ambiente:
```bash
npx -y hyperframes doctor
```
Se o doctor apontar algo faltando (FFmpeg, unzip, Chrome headless), corrija e rode de novo até ficar tudo verde.

Para manter atualizado depois: `npx hyperframes skills check` e `npx hyperframes skills update <nome>`.

---

## Passo 4 — Impeccable (pbakaus/impeccable)

Vocabulário de design para o agente: comandos como `polish`, `bolder`, `quieter`, `distill`, `animate`, `critique`, `audit`. Útil para deixar telas, títulos animados e composições HTML/React dos vídeos com acabamento profissional.

```bash
npx -y impeccable install --providers=claude --scope=global
```
Alternativa no Claude Code (plugin):
```
/plugin marketplace add pbakaus/impeccable
```
e depois abrir `/plugin` e instalar Impeccable.

Depois de instalar, reinicie o Claude Code e rode `/impeccable init` dentro do projeto. Para atualizar: `npx impeccable update`.

---

## Passo 5 — Taste Skill (Leonxlnx/taste-skill)

Conjunto de skills anti-"AI slop": controla variação de layout, intensidade de motion e densidade visual, evitando visual genérico.

```bash
npx -y skills add Leonxlnx/taste-skill -g -y --all
```
Se a pessoa quiser só a principal:
```bash
npx -y skills add Leonxlnx/taste-skill -g -y --skill design-taste-frontend
```
Outras úteis do pacote: `gpt-taste` (UX/UI + motion GSAP), `minimalist-ui`, `high-end-visual-design`.

---

## Passo 6 — Remotion

Vídeo programático em React. As skills oficiais ensinam timing, mídia, legendas e render.

```bash
npx -y skills add remotion-dev/skills -g -y
```
Skill principal: `/remotion-best-practices` (abrange as outras). Dentro de um projeto Remotion também funciona `npx remotion skills add` e, para atualizar, `npx remotion skills update`.

Para criar um projeto de teste (opcional):
```bash
npx -y create-video@latest --yes --blank meu-video
cd meu-video && npm install && npm run dev
```

---

## Passo 7 — FFmpeg (skill de uso)

O programa FFmpeg já foi instalado no Passo 2. Agora adicione uma skill com receitas prontas (cortar, juntar, converter, extrair áudio, reenquadrar 16:9 → 9:16, GIF, normalizar áudio):

```bash
npx -y skills add digitalsamba/claude-code-video-toolkit -g -y --skill ffmpeg
```
Se esse repositório não estiver disponível, use a alternativa:
```bash
npx -y skills add TerminalSkills/skills -g -y --skill ffmpeg
```
Confirme também o ffprobe (vem junto): `ffprobe -version`.

---

## Passo 8 — Whisper (transcrição e legendas)

Whisper da OpenAI, roda local e de graça. Precisa de Python e FFmpeg.

**Windows:**
```powershell
python -m pip install -U pip
python -m pip install -U openai-whisper
```
**macOS:**
```bash
brew install openai-whisper
```
(ou `pipx install openai-whisper`)

**Linux:**
```bash
pipx install openai-whisper
```

Teste rápido (o primeiro uso baixa o modelo):
```bash
whisper arquivo.mp4 --language pt --model small --output_format srt
```
Dicas de modelo para português: `small` é rápido e bom; `medium` é mais preciso; `large-v3` é o melhor mas pesado (ideal com GPU NVIDIA).

Observação: o Hyperframes também transcreve sozinho com `npx hyperframes transcribe`, e o Remotion tem o pacote `@remotion/install-whisper-cpp`. O Whisper standalone serve para qualquer fluxo, inclusive gerar `.srt` para CapCut, Premiere ou DaVinci.

---

## Passo 9 — Extras recomendados (opcional, perguntar antes)

- **yt-dlp** — baixar vídeos de referência ou o próprio conteúdo publicado:
  - Windows: `winget install -e --id yt-dlp.yt-dlp`
  - macOS: `brew install yt-dlp`
  - Linux: `pipx install yt-dlp`

---

## Passo 10 — Verificação final

Rode tudo e monte um relatório para a pessoa:

```bash
node --version
ffmpeg -version
ffprobe -version
whisper --help
npx -y hyperframes doctor
npx -y skills list -g
```

No Windows, confira também a pasta de skills: `dir $HOME\.claude\skills`. No macOS/Linux: `ls ~/.claude/skills`.

Entregue um resumo assim:

| Item | Status | Versão / observação |
|------|--------|---------------------|
| Node.js | ✅ | v22.x |
| FFmpeg + ffprobe | ✅ | 7.x |
| Whisper | ✅ | modelo small baixado |
| Hyperframes | ✅ | doctor verde |
| Impeccable | ✅ | rodar /impeccable init no projeto |
| Taste Skill | ✅ | 13 skills |
| Remotion | ✅ | remotion-best-practices |
| Skill FFmpeg | ✅ | |

Finalize avisando: **reinicie o Claude Code / app do Claude** para as novas skills aparecerem, e sugira um primeiro teste (por exemplo: "crie um vídeo de 10 segundos com Hyperframes com um título animado").

---

## Problemas comuns

- **"node não é reconhecido" / "ffmpeg not found" depois de instalar no Windows:** feche e abra o terminal. Se persistir, reinicie o computador (o winget atualiza o PATH só em novas sessões).
- **Hyperframes recusa o Node:** versão abaixo de 22. Atualize com `winget upgrade OpenJS.NodeJS.LTS`, `brew upgrade node` ou NodeSource 22.
- **`npx skills add` abre seletor interativo e trava:** confirme que usou `-y`. Se a flag `--all` não for aceita pela versão da CLI, rode sem ela e selecione todas no seletor.
- **Whisper falha ao instalar no Python 3.13+:** instale o Python 3.12 e use `py -3.12 -m pip install openai-whisper` (Windows).
- **Whisper muito lento:** use `--model small` ou `base`; sem GPU NVIDIA, os modelos grandes demoram muito.
- **`hyperframes doctor` reclama de unzip (Linux):** `sudo apt install -y unzip`.
- **Erro de permissão no npm global (macOS/Linux):** não use `sudo npm`; prefira `npx` (já usado aqui) ou configure o nvm.

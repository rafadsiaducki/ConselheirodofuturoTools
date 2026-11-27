# ConselheirodofuturoTools

Ferramentas e skills abertas do **Conselheiro do Futuro** para quem quer usar AI na prática: criação de conteúdo, edição de vídeo e automação.

---

## ⚡ Instalação rápida: Kit de Edição de Vídeo com AI

**Um comando instala tudo.** Ele confere o seu computador item por item: o que você já tem aparece como `ja esta instalado`, e o que falta ele instala sozinho. Pode rodar quantas vezes quiser, porque ele nunca reinstala nada.

### 🪟 Windows

1. Aperte **`Win + X`** e clique em **Terminal** (ou "Windows PowerShell").
2. Copie a linha abaixo, cole no Terminal e aperte **Enter**:

   ```powershell
   irm https://raw.githubusercontent.com/rafadsiaducki/ConselheirodofuturoTools/main/instalar-kit.ps1 | iex
   ```

3. Se o Windows pedir permissão, clique em **Sim**.
4. Espere aparecer o **RESUMO** no final. A primeira vez leva alguns minutos, por causa do Whisper.
5. **Feche e abra o Claude Code.** Pronto.

### 🍎 macOS / 🐧 Linux

1. Abra o **Terminal**.
2. Copie a linha abaixo, cole e aperte **Enter**:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/rafadsiaducki/ConselheirodofuturoTools/main/instalar-kit.sh | bash
   ```

3. Se pedir a senha do computador, digite (ela não aparece enquanto você digita, é normal).
4. Espere o **RESUMO** e **feche e abra o Claude Code**.

> No Mac é preciso ter o [Homebrew](https://brew.sh) instalado.

### O que você vai ver no final

```
=============== RESUMO ===============
Node.js 22+              ja estava instalado
Git                      ja estava instalado
Python 3                 ja estava instalado
FFmpeg                   ja estava instalado
Whisper                  instalado agora
yt-dlp                   instalado agora
Hyperframes              instalado agora
Impeccable               instalado agora
Taste Skill              instalado agora
Remotion                 instalado agora
Skill FFmpeg             instalado agora
Chrome do Hyperframes    pronto

Tudo pronto! Feche e abra o Claude Code para as skills aparecerem.
```

### Primeiro teste

Abra o Claude Code e peça:

> "Crie um vídeo de 10 segundos com Hyperframes com um título animado."

### Deu algum problema?

| Mensagem | O que fazer |
|---|---|
| Algum item com `ERRO` no resumo | Feche o Terminal, abra de novo e rode o mesmo comando. Ele continua de onde parou. |
| `winget nao existe` (Windows) | Instale o **App Installer** pela Microsoft Store e rode de novo. |
| `npx não é reconhecido` | Feche e abra o Terminal (o Node.js acabou de ser instalado) e rode de novo. |
| Continua dando erro | Tire um print do resumo e mande para o Claude: ele resolve o item que falhou. |

### O que o kit instala

| Item | Para que serve |
|---|---|
| **Node.js, Git, Python** | Base para as ferramentas funcionarem |
| **FFmpeg** | Cortar, juntar, converter e exportar vídeo e áudio |
| **Whisper** (OpenAI) | Transcrever falas e gerar legendas `.srt` automaticamente |
| **yt-dlp** | Baixar vídeos de referência |
| **Hyperframes** (HeyGen) | Criar vídeos com HTML + animação e renderizar em MP4 |
| **Remotion** | Criar vídeos programáticos com React |
| **Impeccable** | Acabamento de design profissional (polish, critique, audit) |
| **Taste Skill** | Evita visual genérico de "feito por AI" |
| **Skill FFmpeg** | Ensina o Claude a editar com FFmpeg |

---

## Skills deste repositório

| Skill | O que faz |
|-------|-----------|
| [`instalar-kit-edicao-video`](skills/instalar-kit-edicao-video/SKILL.md) | Deixa o Claude instalar e conferir o kit sozinho. É só pedir: *"Instala o kit de edição de vídeo no meu computador."* |

As skills seguem o padrão aberto de Agent Skills (`SKILL.md`) e funcionam no Claude Code, Cursor, Codex e outros agentes compatíveis.

### Instalar as skills deste repositório

Precisa do [Node.js](https://nodejs.org). No Terminal:

```bash
npx skills add rafadsiaducki/ConselheirodofuturoTools -g --agent claude-code -y
```

Use o mesmo comando para **atualizar** para a versão mais nova.

- Sem o `-g`, a skill fica só no projeto atual.
- Usa outro agente (Cursor, Codex…)? Troque `claude-code` pelo nome dele, ou remova `--agent` para escolher na hora.

**Instalação manual:** baixe o repositório (**Code → Download ZIP**) e copie a pasta `skills/instalar-kit-edicao-video` para `C:\Users\SEU_USUARIO\.claude\skills\` (Windows) ou `~/.claude/skills/` (Mac/Linux). Depois reinicie o Claude Code.

---

## Créditos

Este kit instala ferramentas de terceiros. Todo o crédito vai para os autores originais:

- [Hyperframes](https://github.com/heygen-com/hyperframes) — HeyGen
- [Impeccable](https://github.com/pbakaus/impeccable) — Paul Bakaus
- [Taste Skill](https://github.com/Leonxlnx/taste-skill) — Leonxlnx
- [Remotion](https://github.com/remotion-dev/skills) — Remotion
- [FFmpeg](https://ffmpeg.org)
- [Whisper](https://github.com/openai/whisper) — OpenAI
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)

---

Feito por [Rafa Dsiaducki](https://conselheirodofuturo.com.br) · Conselheiro do Futuro

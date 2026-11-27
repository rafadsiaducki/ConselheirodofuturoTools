# ConselheirodofuturoTools

Ferramentas e skills abertas do **Conselheiro do Futuro** para quem quer usar AI na prática — criação de conteúdo, edição de vídeo e automação.

As skills seguem o padrão aberto de Agent Skills (`SKILL.md`) e funcionam no Claude Code, Claude (app), Cursor, Codex e outros agentes compatíveis.

## Skills disponíveis

| Skill | O que faz |
|-------|-----------|
| [`instalar-kit-edicao-video`](skills/instalar-kit-edicao-video/SKILL.md) | Prepara o computador do zero para editar vídeo com AI: instala Node.js, FFmpeg, Whisper e as skills Hyperframes, Impeccable, Taste Skill, Remotion e FFmpeg, com verificação final. Windows, macOS e Linux. |

## Como instalar

### Opção 1 — Comando único (recomendado)

Precisa ter o [Node.js](https://nodejs.org) instalado. No terminal:

```bash
npx skills add rafadsiaducki/ConselheirodofuturoTools -g
```

Para instalar só uma skill específica:

```bash
npx skills add rafadsiaducki/ConselheirodofuturoTools -g --skill instalar-kit-edicao-video
```

Sem o `-g`, a skill é instalada só no projeto atual.

### Opção 2 — Manual

1. Baixe este repositório (botão **Code → Download ZIP**).
2. Copie a pasta `skills/instalar-kit-edicao-video` para:
   - Windows: `C:\Users\SEU_USUARIO\.claude\skills\`
   - macOS / Linux: `~/.claude/skills/`
3. Reinicie o Claude Code.

### Opção 3 — App do Claude (claude.ai)

Baixe o `SKILL.md`, compacte a pasta da skill em `.zip` e envie em **Configurações → Capacidades → Skills**.

## Como usar

Depois de instalada, é só pedir ao Claude:

> "Instala o kit de edição de vídeo no meu computador."

A skill verifica o que você já tem, instala só o que falta e, no fim, mostra um relatório com tudo funcionando.

## Créditos

Este kit instala ferramentas de terceiros. Todo o crédito vai para os autores originais:

- [Hyperframes](https://github.com/heygen-com/hyperframes) — HeyGen
- [Impeccable](https://github.com/pbakaus/impeccable) — Paul Bakaus
- [Taste Skill](https://github.com/Leonxlnx/taste-skill) — Leonxlnx
- [Remotion](https://github.com/remotion-dev/skills) — Remotion
- [FFmpeg](https://ffmpeg.org)
- [Whisper](https://github.com/openai/whisper) — OpenAI

---

Feito por [Rafa Dsiaducki](https://conselheirodofuturo.com.br) · Conselheiro do Futuro

# openclaw-skill-siliconflow-audio-tts

This is an example **Text-to-Speech (TTS)** tool using SiliconFlow's `/v1/audio/speech` endpoint. It can be used as an OpenClaw skill or as a standalone CLI helper.

> This repo is an example implementation. Users are expected to adjust scripts, paths and environment variable setup according to their own environment.

## Features

- Model: `FunAudioLLM/CosyVoice2-0.5B`
- Purpose: Synthesize mp3 audio from text via SiliconFlow API
- Supports system voices: `claire`, `anna`, `bella`, `alex`, etc.

## Directory

```bash
siliconflow-audio-tts/
├── SKILL.md
└── scripts/
    └── tts_request.sh
```

## Setup

1. Create an API key in SiliconFlow console.
2. Set `SILICONFLOW_API_KEY` on your machine, for example:

   ```bash
   mkdir -p ~/.config/openclaw/secrets
   chmod 700 ~/.config/openclaw/secrets

   cat > ~/.config/openclaw/secrets/siliconflow.env <<'EOF'
   SILICONFLOW_API_KEY=your_api_key_here
   EOF

   chmod 600 ~/.config/openclaw/secrets/siliconflow.env
   ```

3. Load it before running scripts:

   ```bash
   set -a
   . ~/.config/openclaw/secrets/siliconflow.env
   set +a
   ```

## Usage

```bash
cd siliconflow-audio-tts
scripts/tts_request.sh "text to speak" [voice] [output_file]
```

On success, the script writes a non-empty mp3 file and exits with code `0`. On failure, it prints error details, removes any partial file and exits with non-zero code.

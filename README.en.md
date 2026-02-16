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
2. Set `OPENCLAW_SILICONFLOW_API_KEY` on your machine (standardized location):

   ```bash
   mkdir -p ~/.openclaw
   chmod 700 ~/.openclaw

   cat >> ~/.openclaw/.env <<'EOF'
   OPENCLAW_SILICONFLOW_API_KEY=your_api_key_here
   EOF

   chmod 600 ~/.openclaw/.env
   ```

3. Note: OpenClaw loads `~/.openclaw/.env` automatically on startup (no manual `source` needed).

## Usage

```bash
cd siliconflow-audio-tts
scripts/tts_request.sh "text to speak" [voice] [output_file]
```

On success, the script writes a non-empty mp3 file and exits with code `0`. On failure, it prints error details, removes any partial file and exits with non-zero code.

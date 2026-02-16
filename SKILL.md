---
name: siliconflow-audio-tts
description: Text-to-speech (TTS)
homepage: https://api.siliconflow.cn
user-invocable: true
metadata: { "openclaw": { "emoji": "🔊", "primaryEnv": "OPENCLAW_SILICONFLOW_API_KEY", "requires": { "env": ["OPENCLAW_SILICONFLOW_API_KEY"] } } }
---

# SiliconFlow Text-to-Speech (TTS)

Use this skill to call SiliconFlow `FunAudioLLM/CosyVoice2-0.5B` and synthesize text into a local mp3 file. Default voice: **claire**.

## Credential reuse

- This skill reuses the same API key as `siliconflow-audio-transcribe`.
- Environment variable: `OPENCLAW_SILICONFLOW_API_KEY`
- **Required location (standardized): `~/.openclaw/.env`**

Example:
```bash
mkdir -p ~/.openclaw
chmod 700 ~/.openclaw
cat > ~/.openclaw/.env <<'EOF'
OPENCLAW_SILICONFLOW_API_KEY=你的_API_KEY_放这里
EOF
chmod 600 ~/.openclaw/.env
```

Notes:
- OpenClaw loads `~/.openclaw/.env` automatically on startup (no manual `source` needed).

## Workflow

1. Ensure `OPENCLAW_SILICONFLOW_API_KEY` is set (via `~/.openclaw/.env`).
2. Run the script from the skill directory:
   ```bash
   cd skills/siliconflow-audio-tts
   scripts/tts_request.sh "Text to speak..." [voice] [output_filename]
   ```
3. On success, exit code is `0` and an mp3 file is written; on failure, exit code is non-zero and the error is printed.

## Script contract

- Entry script: `scripts/tts_request.sh`
- Endpoint: `https://api.siliconflow.cn/v1/audio/speech`
- Default model: `FunAudioLLM/CosyVoice2-0.5B`
- Default voice: `FunAudioLLM/CosyVoice2-0.5B:claire`
- Default format: `mp3`
- Args:
  - Required: text to synthesize (positional arg #1)
  - Optional: voice (positional arg #2), e.g.
    - `FunAudioLLM/CosyVoice2-0.5B:claire`
    - `FunAudioLLM/CosyVoice2-0.5B:anna`
    - `FunAudioLLM/CosyVoice2-0.5B:bella`
    - `FunAudioLLM/CosyVoice2-0.5B:alex`
  - Optional: output filename (positional arg #3), default: `output.mp3`
- Exit codes:
  - `0`: success (non-empty audio file written)
  - non-zero: validation error, missing env var, non-200 HTTP response, etc.

## Examples

```bash
# 1) Ensure API key is present in ~/.openclaw/.env (auto-loaded by OpenClaw)
cd /home/chen/.openclaw/workspace/skills/siliconflow-audio-tts

# 2) Chinese, default voice (claire)
scripts/tts_request.sh "<|happy|>Happy New Year, Captain!" \
  "FunAudioLLM/CosyVoice2-0.5B:claire" happy.mp3

# 3) English, specify a different voice
scripts/tts_request.sh "Good evening, captain. All systems are running smoothly." \
  "FunAudioLLM/CosyVoice2-0.5B:anna" anna_en.mp3
```

## Notes

- On success, the API returns a binary audio stream and the script saves it as an mp3.
- On failure, the API returns a JSON error; the script prints the raw error for debugging.
- You can reuse the generated mp3 in downstream workflows (e.g., sending a Telegram voice message).

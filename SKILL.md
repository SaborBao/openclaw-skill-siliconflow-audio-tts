---
name: siliconflow-audio-tts
description: Text-to-speech (TTS)
homepage: https://api.siliconflow.cn
user-invocable: true
metadata: { "openclaw": { "emoji": "🔊", "primaryEnv": "OPENCLAW_SILICONFLOW_API_KEY", "requires": { "env": ["OPENCLAW_SILICONFLOW_API_KEY"] } } }
---

# SiliconFlow Text-to-Speech (TTS)

Prereq: `OPENCLAW_SILICONFLOW_API_KEY` must be set.

## Usage

```bash
cd skills/siliconflow-audio-tts
scripts/tts_request.sh "Text to speak..." [voice] [output_filename]
```

## Defaults

- Model: `FunAudioLLM/CosyVoice2-0.5B`
- Voice: `FunAudioLLM/CosyVoice2-0.5B:claire`
- Output: `mp3`

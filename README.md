# openclaw-skill-siliconflow-audio-tts

基于 SiliconFlow `/v1/audio/speech` 接口的文本转语音（TTS）脚本示例，可作为 OpenClaw skill 使用或独立命令行工具使用。

> 本仓库为示例实现，使用者可按需调整脚本细节、目录结构与环境变量配置。

## 功能简介

- 调用模型：`FunAudioLLM/CosyVoice2-0.5B`
- 功能：将一段文本合成为本地 mp3 音频文件
- 支持系统音色：`claire`、`anna`、`bella`、`alex` 等

## 目录结构

```bash
siliconflow-audio-tts/
├── SKILL.md             # Skill 说明与使用约定
└── scripts/
    └── tts_request.sh   # 实际调用 SiliconFlow TTS 接口的脚本
```

## 使用前准备

1. 在 SiliconFlow 控制台创建 API Key。
2. 在本机设置环境变量 `SILICONFLOW_API_KEY`，推荐写入：

   ```bash
   mkdir -p ~/.config/openclaw/secrets
   chmod 700 ~/.config/openclaw/secrets

   cat > ~/.config/openclaw/secrets/siliconflow.env <<'EOF'
   SILICONFLOW_API_KEY=your_api_key_here
   EOF

   chmod 600 ~/.config/openclaw/secrets/siliconflow.env
   ```

3. 使用前加载：

   ```bash
   set -a
   . ~/.config/openclaw/secrets/siliconflow.env
   set +a
   ```

## 命令行用法

```bash
cd siliconflow-audio-tts
scripts/tts_request.sh "要朗读的文本" [音色] [输出文件名]
```

常见音色示例：

- `FunAudioLLM/CosyVoice2-0.5B:claire`（温柔女声，默认）
- `FunAudioLLM/CosyVoice2-0.5B:anna`
- `FunAudioLLM/CosyVoice2-0.5B:bella`
- `FunAudioLLM/CosyVoice2-0.5B:alex`

示例：

```bash
cd siliconflow-audio-tts

# 1）使用温柔女声 claire 合成一段中文
scripts/tts_request.sh "<|happy|>太棒了！听到这个消息我真的非常激动！" \
  "FunAudioLLM/CosyVoice2-0.5B:claire" happy.mp3

# 2）用 anna 读一段英文
scripts/tts_request.sh "Good evening, captain. All systems are running smoothly." \
  "FunAudioLLM/CosyVoice2-0.5B:anna" anna_en.mp3

# 3）只给文本，音色和文件名都用默认（claire + output.mp3）
scripts/tts_request.sh "This sentence is synthesized by SiliconFlow CosyVoice2."
```

- 成功：生成非空 mp3 文件，stderr 打印成功提示，退出码为 `0`
- 失败：stderr 输出错误信息并删除残缺文件，退出码为非 `0`

## 额外说明：SiliconFlow 推广链接

如果你是第一次使用 SiliconFlow，可以通过以下链接注册，每人都可以获取 16 元额度（可用来体验除免费模型之外的其他模型）：

- 推荐链接：https://cloud.siliconflow.cn/i/QcpkcG5j

> 说明：这是代码作者使用的推广链接，不影响你正常使用免费模型，只是多拿一份初始额度。

## English

This is an example **Text-to-Speech (TTS)** tool using SiliconFlow's `/v1/audio/speech` endpoint. It can be used as an OpenClaw skill or as a standalone CLI helper.

> This repo is an example implementation. Users are expected to adjust scripts, paths and environment variable setup according to their own environment.

### Features

- Model: `FunAudioLLM/CosyVoice2-0.5B`
- Purpose: Synthesize mp3 audio from text via SiliconFlow API
- Supports system voices: `claire`, `anna`, `bella`, `alex`, etc.

### Directory

```bash
siliconflow-audio-tts/
├── SKILL.md
└── scripts/
    └── tts_request.sh
```

### Setup

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

### Usage

```bash
cd siliconflow-audio-tts
scripts/tts_request.sh "text to speak" [voice] [output_file]
```

On success, the script writes a non-empty mp3 file and exits with code `0`. On failure, it prints error details, removes any partial file and exits with non-zero code.

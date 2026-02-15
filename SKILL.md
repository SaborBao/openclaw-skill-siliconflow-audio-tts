---
name: siliconflow-audio-tts
description: 使用 SiliconFlow 的 `/v1/audio/speech` 接口，通过 `FunAudioLLM/CosyVoice2-0.5B` 把文字合成为语音（支持 claire/anna/bella 等系统音色）。当你需要把文本变成语音播报，并且已经配置好了 SiliconFlow 的转写 API Key 时，使用这个 skill。
---

# SiliconFlow 文本转语音（TTS）

用这个 skill，可以调用 SiliconFlow 的 `FunAudioLLM/CosyVoice2-0.5B` 模型，把一段文本合成到本地 mp3 文件里。默认音色是 **claire（温柔女声）**。

## 凭证复用说明

- 本 skill 复用 `siliconflow-audio-transcribe` 的同一套 Key。
- 环境变量：`SILICONFLOW_API_KEY`
- 推荐把 Key 写在：`~/.config/openclaw/secrets/siliconflow.env`

示例：
```bash
mkdir -p ~/.config/openclaw/secrets
chmod 700 ~/.config/openclaw/secrets
cat > ~/.config/openclaw/secrets/siliconflow.env <<'EOF'
SILICONFLOW_API_KEY=你的_API_KEY_放这里
EOF
chmod 600 ~/.config/openclaw/secrets/siliconflow.env
```

使用前加载：
```bash
set -a
. ~/.config/openclaw/secrets/siliconflow.env
set +a
```

## 使用流程

1. 确认 `SILICONFLOW_API_KEY` 已经生效（或按上面方式 source `.env`）。
2. 在 skill 目录下运行脚本：
   ```bash
   cd skills/siliconflow-audio-tts
   scripts/tts_request.sh "要朗读的文本..." [音色] [输出文件名]
   ```
3. 脚本成功则返回码为 `0`，并在当前目录生成 mp3 文件；失败则返回非 0，并在终端输出错误原因。

## 脚本约定

- 入口脚本：`scripts/tts_request.sh`
- 请求地址：`https://api.siliconflow.cn/v1/audio/speech`
- 默认模型：`FunAudioLLM/CosyVoice2-0.5B`
- 默认音色：`FunAudioLLM/CosyVoice2-0.5B:claire`（温柔女声）
- 默认格式：`mp3`
- 参数：
  - 必选：要合成的文本（第 1 个位置参数）
  - 可选：音色（第 2 个位置参数），例如：
    - `FunAudioLLM/CosyVoice2-0.5B:claire`
    - `FunAudioLLM/CosyVoice2-0.5B:anna`
    - `FunAudioLLM/CosyVoice2-0.5B:bella`
    - `FunAudioLLM/CosyVoice2-0.5B:alex`
  - 可选：输出文件名（第 3 个位置参数），默认：`output.mp3`
- 退出码：
  - `0`：请求成功，音频文件非空写入成功
  - 非 0：参数错误、环境变量缺失、HTTP 非 200 或返回体异常等

## 示例命令

```bash
# 1）加载 Key（和转写 skill 一样）
set -a && . ~/.config/openclaw/secrets/siliconflow.env && set +a
cd /home/chen/.openclaw/workspace/skills/siliconflow-audio-tts

# 2）使用默认温柔女声 claire，合成一段开心语气的中文
scripts/tts_request.sh "<|happy|>太棒了！听到这个消息我真的非常激动！" \
  "FunAudioLLM/CosyVoice2-0.5B:claire" happy.mp3

# 3）用 anna 读一段英文
scripts/tts_request.sh "Good evening, captain. All systems are running smoothly." \
  "FunAudioLLM/CosyVoice2-0.5B:anna" anna_en.mp3

# 4）只给文本，其他用默认（claire + output.mp3）
scripts/tts_request.sh "头儿，现在是 SiliconFlow 的 CosyVoice2 在给你读这句话。"
```

## 其他说明

- 成功时接口直接返回二进制音频流，脚本把它保存为 mp3 文件。
- 失败时接口返回 JSON 错误，脚本会把错误文本打到终端，方便排查。
- 可以在上层工作流中读取生成的 mp3 路径，把文件继续用在 Telegram 语音、播放器等场景中。

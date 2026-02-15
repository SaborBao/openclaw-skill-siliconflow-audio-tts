#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "用法: $0 <文本> [音色] [输出文件]" >&2
}

if [[ $# -lt 1 || $# -gt 3 ]]; then
  usage
  exit 2
fi

text="$1"
voice="${2:-FunAudioLLM/CosyVoice2-0.5B:claire}"
# 默认输出目录改为 /tmp 下的专用子目录，避免把 skill 目录弄脏
if [[ $# -ge 3 ]]; then
  # 显式指定了输出文件名 → 原样使用（可以是相对或绝对路径）
  output_file="$3"
else
  # 未指定文件名 → 使用 /tmp/siliconflow-tts/output-<timestamp>.mp3
  tmp_dir="/tmp/siliconflow-tts"
  mkdir -p "$tmp_dir"
  output_file="$tmp_dir/output-$(date +%s).mp3"
fi
model="FunAudioLLM/CosyVoice2-0.5B"
endpoint="https://api.siliconflow.cn/v1/audio/speech"

if [[ -z "${SILICONFLOW_API_KEY:-}" ]]; then
  echo "错误: 未检测到 SILICONFLOW_API_KEY 环境变量，请先配置 SiliconFlow 的 API Key。" >&2
  exit 2
fi

if [[ -z "$text" ]]; then
  echo "错误: 待合成的文本不能为空。" >&2
  exit 2
fi

# 使用临时文件保存 curl 的错误输出
# 当 HTTP 200 时，二进制音频会直接写入 $output_file
# 非 200 时，stderr 中会包含错误信息

tmp_err="$(mktemp)"
cleanup() {
  rm -f "$tmp_err"
}
trap cleanup EXIT

http_status="$(
  curl -sS \
    -w "%{http_code}" \
    --output "$output_file" \
    --request POST "$endpoint" \
    -H "Authorization: Bearer $SILICONFLOW_API_KEY" \
    -H "Content-Type: application/json" \
    --data "{ \"model\": \"$model\", \"input\": \"${text//\"/\\\"}\", \"voice\": \"$voice\", \"response_format\": \"mp3\" }" \
    2>"$tmp_err"
)"

# 如果 curl 自身失败（网络/TLS 等），在 set -e 下已经退出，这里只处理 HTTP 层错误

if [[ "$http_status" != "200" ]]; then
  echo "错误: SiliconFlow TTS 请求失败，HTTP 状态码: $http_status" >&2
  if [[ -s "$tmp_err" ]]; then
    cat "$tmp_err" >&2
  fi
  # 删除可能存在的残缺音频文件
  rm -f "$output_file" || true
  exit 1
fi

# 基本校验: 确认输出文件非空
if [[ ! -s "$output_file" ]]; then
  echo "错误: 收到 HTTP 200 但生成的音频文件为空，请检查接口返回。" >&2
  exit 1
fi

echo "✅ 文本转语音成功，音频已保存到: $output_file" >&2
exit 0

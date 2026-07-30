#!/usr/bin/env bash
#
# video-transcribe.sh — transcribe a video with whisper.cpp and run
# claude-real-video (crv) speaker/scene analysis on it.
#
# Usage:
#   video-transcribe.sh [options] <video-file>
#   video-transcribe.sh install
#
# Subcommands:
#   install        Pre-download the sherpa-onnx speaker-diarization models
#                   used by crv's --speakers option (run once, needs internet).
#
# Options (for the default transcribe action):
#   -m, --model PATH     Path to whisper.cpp ggml model (default: $WHISPER_MODEL
#                        or ~/dev/whisper.cpp/models/ggml-small.bin)
#   -b, --whisper-bin DIR  Directory containing the whisper-cli binary
#                        (default: $WHISPER_BIN_DIR or ~/dev/whisper.cpp/build/bin)
#   -o, --outdir DIR     Directory to write the .wav/.srt output to
#                        (default: same directory as the input video)
#   --no-speakers        Skip the `crv --speakers` step
#   -h, --help           Show this help
#
# Example:
#   video-transcribe.sh "/media/sf_junk/2026-07-16 14-31-55-jpmc-arsenal-otb-sod.mp4"

set -euo pipefail

WHISPER_MODEL="${WHISPER_MODEL:-$HOME/dev/whisper.cpp/models/ggml-small.bin}"
WHISPER_BIN_DIR="${WHISPER_BIN_DIR:-$HOME/dev/whisper.cpp/build/bin}"
CRV_SPEAKER_MODELS_DIR="${CRV_SPEAKER_MODELS_DIR:-$HOME/.cache/claude-real-video/speaker-models}"

OUTDIR=""
RUN_SPEAKERS=1

usage() {
  sed -n '2,26p' "$0" | sed 's/^# \{0,1\}//'
}

cmd_install() {
  # Pre-download the sherpa-onnx speaker-diarization models used by
  # claude-real-video's `--speakers` option, so they can be copied to an
  # offline / air-gapped machine (e.g. a locked-down work laptop).
  #
  # Run this on a machine WITH internet access. It populates:
  #     $CRV_SPEAKER_MODELS_DIR
  # Then copy that whole folder to the SAME path on the offline machine.
  #
  # No Hugging Face and no token required — these are public sherpa-onnx
  # GitHub release assets (plain downloads).

  local cache_dir="$CRV_SPEAKER_MODELS_DIR"
  local seg_url="https://github.com/k2-fsa/sherpa-onnx/releases/download/speaker-segmentation-models/sherpa-onnx-pyannote-segmentation-3-0.tar.bz2"
  local seg_dir="sherpa-onnx-pyannote-segmentation-3-0"

  # note: "recongition" is the actual (typo'd) release-tag name in the sherpa-onnx repo
  local emb_url="https://github.com/k2-fsa/sherpa-onnx/releases/download/speaker-recongition-models/3dspeaker_speech_eres2net_base_sv_zh-cn_3dspeaker_16k.onnx"
  local emb_file="3dspeaker_speech_eres2net_base_sv_zh-cn_3dspeaker_16k.onnx"

  mkdir -p "$cache_dir"
  cd "$cache_dir"

  # 1) Segmentation model — a tar.bz2 that extracts to $seg_dir/model.onnx
  if [ -f "$seg_dir/model.onnx" ]; then
    echo "[skip] segmentation model already present"
  else
    echo "[download] segmentation model ..."
    curl -fL --retry 3 -o segmentation.tar.bz2 "$seg_url"
    tar xjf segmentation.tar.bz2
    rm -f segmentation.tar.bz2
    [ -f "$seg_dir/model.onnx" ] || { echo "ERROR: $seg_dir/model.onnx missing after extract" >&2; exit 1; }
  fi

  # 2) Speaker embedding model — a single .onnx file placed directly in cache_dir
  if [ -f "$emb_file" ]; then
    echo "[skip] embedding model already present"
  else
    echo "[download] embedding model ..."
    curl -fL --retry 3 -o "$emb_file" "$emb_url"
  fi

  echo
  echo "Done. Models are in: $cache_dir"
  ls -la "$cache_dir"
  echo
  echo "Next steps:"
  echo "  1) Copy the whole folder to the SAME path on the offline machine:"
  echo "       $cache_dir"
  echo "  2) There, install the extra:  pip install 'claude-real-video[speakers]'"
  echo "  3) Run with --speakers; it finds the local models and downloads nothing."
}

cmd_transcribe() {
  local video="$1"

  [ -f "$video" ] || { echo "ERROR: video file not found: $video" >&2; exit 1; }
  [ -f "$WHISPER_MODEL" ] || { echo "ERROR: whisper model not found: $WHISPER_MODEL" >&2; exit 1; }
  [ -x "$WHISPER_BIN_DIR/whisper-cli" ] || { echo "ERROR: whisper-cli not found in: $WHISPER_BIN_DIR" >&2; exit 1; }
  command -v ffmpeg >/dev/null || { echo "ERROR: ffmpeg not found in PATH" >&2; exit 1; }
  command -v crv >/dev/null || { echo "ERROR: crv not found in PATH" >&2; exit 1; }

  local video_dir base outdir wav srt_prefix
  video_dir="$(cd "$(dirname "$video")" && pwd)"
  base="$(basename "$video")"
  base="${base%.*}"
  outdir="${OUTDIR:-$video_dir}"
  mkdir -p "$outdir"

  wav="$outdir/$base.wav"
  srt_prefix="$outdir/$base"

  echo "==> Extracting audio to $wav"
  ffmpeg -y -i "$video" -ar 16000 -ac 1 -c:a pcm_s16le "$wav"

  echo "==> Transcribing with whisper-cli ($WHISPER_MODEL)"
  (
    cd "$WHISPER_BIN_DIR"
    ./whisper-cli -m "$WHISPER_MODEL" -f "$wav" -osrt -of "$srt_prefix"
  )

  if [ "$RUN_SPEAKERS" -eq 1 ]; then
    echo "==> Running crv --speakers on $video"
    crv "$video" --speakers
  fi

  echo "==> Done. Output: $srt_prefix.srt"
}

# --- arg parsing ---

if [ "${1:-}" = "install" ]; then
  cmd_install
  exit 0
fi

VIDEO=""
while [ $# -gt 0 ]; do
  case "$1" in
    -m|--model)
      WHISPER_MODEL="$2"; shift 2 ;;
    -b|--whisper-bin)
      WHISPER_BIN_DIR="$2"; shift 2 ;;
    -o|--outdir)
      OUTDIR="$2"; shift 2 ;;
    --no-speakers)
      RUN_SPEAKERS=0; shift ;;
    -h|--help)
      usage; exit 0 ;;
    --)
      shift; break ;;
    -*)
      echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *)
      VIDEO="$1"; shift ;;
  esac
done

if [ -z "$VIDEO" ]; then
  usage
  exit 1
fi

cmd_transcribe "$VIDEO"

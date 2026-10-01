#!/bin/zsh
# Convert a Hugging Face Whisper fine-tune to a quantized whisper.cpp (ggml) model.
#   scripts/convert.sh <hf-repo> <model-id> <quant: q8_0|q5_0|f16> [--tokenizer-from <hf-repo>]
# Needs: WHISPER_CPP=<path to whisper.cpp checkout with build-mac/bin/whisper-quantize>,
#        OPENAI_WHISPER=<path to github.com/openai/whisper checkout>, python with torch + transformers.
set -euo pipefail
repo=$1; id=$2; quant=$3; tok_from=${5:-}
work=${WORK:-./work}/$id; mkdir -p "$work/hf" "$work/out"
files=$(curl -s "https://huggingface.co/api/models/$repo" | python3 -c "import json,sys; print(' '.join(s['rfilename'] for s in json.load(sys.stdin)['siblings'] if '/' not in s['rfilename'] and s['rfilename'].endswith(('.json','.txt','.safetensors','.bin')) and 'training' not in s['rfilename'] and 'optimizer' not in s['rfilename']))")
for f in ${=files}; do [ -s "$work/hf/$f" ] || curl -sfL -o "$work/hf/$f" "https://huggingface.co/$repo/resolve/main/$f"; done
if [ -n "$tok_from" ]; then
  for f in vocab.json added_tokens.json merges.txt special_tokens_map.json normalizer.json; do
    [ -s "$work/hf/$f" ] || curl -sfL -o "$work/hf/$f" "https://huggingface.co/$tok_from/resolve/main/$f"
  done
fi
python3 "$WHISPER_CPP/models/convert-h5-to-ggml.py" "$work/hf" "$OPENAI_WHISPER" "$work/out"
out="ggml-$id-$quant.bin"
if [ "$quant" = f16 ]; then cp "$work/out/ggml-model.bin" "$out"; else "$WHISPER_CPP/build-mac/bin/whisper-quantize" "$work/out/ggml-model.bin" "$out" "$quant"; fi
echo "file:   $out"; echo "bytes:  $(stat -f %z "$out")"; echo "sha256: $(shasum -a 256 "$out" | cut -d' ' -f1)"

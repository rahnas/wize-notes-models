# Wize Notes — speech models

Public, downloadable speech-recognition models used by the **Wize Notes** apps (iOS and Android).
The apps read [`catalog.json`](catalog.json) to list the languages a user can enable — in onboarding or
in Settings → Languages — and download only the models for the languages they pick.

Everything runs on the phone; these files are only downloaded, never used to send audio anywhere.

## How it fits together

```
raw.githubusercontent.com/rahnas/wize-notes-models/main/catalog.json   ← apps fetch this (small, cached)
github.com/rahnas/wize-notes-models/releases/download/<tag>/<file>     ← the model files (one release per model version)
```

- **`languages[]`** — what users choose. Each language says which engine each platform uses
  (`apple-speech` needs no download on iOS; `whisper` points to a model id) and, for language
  auto-detection, which Whisper language codes count as this language (`detectAs` — Whisper's small
  detector often labels Malayalam as Tamil/Telugu).
- **`models[]`** — the files: download URL, optional `mirrors[]` (tried in order if the main URL fails),
  exact size, SHA-256 (the apps verify it before use), license, source and attribution. Model files are
  immutable: a new version gets a new id/tag, never a replaced file.

## Hosting

Model files live on GitHub Releases of this public repo: free, no bandwidth charges, 2 GB per file. If a
model ever exceeds that, or GitHub becomes a bottleneck, upload the same file to Hugging Face or Cloudflare R2
and add the URL to `mirrors` (or make it the main `url`). The SHA-256 guarantees users get identical bytes
whichever host serves them.

## Available

| Language | Options (recommended first) |
|---|---|
| English | iOS: Apple on-device speech · [Whisper large-v3 turbo](models/whisper-large-v3-turbo-q8_0.md). Android: [Whisper small.en](models/en-whisper-small-q5_1.md) · turbo |
| Malayalam (മലയാളം) | [large-v3 turbo IndicVoices](models/ml-turbo-indicvoices-q8_0.md) · [IndicWhisper](models/ml-indicwhisper-medium-q8_0.md) · English translation ([large-v3](models/whisper-large-v3-q5_0.md)) · [small code-mixed](models/ml-codemixed-small-q5_0.md) |
| Hindi (हिन्दी) | [Whisper large-v3 turbo](models/whisper-large-v3-turbo-q8_0.md) · [large-v3](models/whisper-large-v3-q5_0.md) · English translation |
| Arabic (العربية) | iOS: Apple on-device speech (ar-SA) · turbo · English translation. Android: turbo · English translation |

Languages can list several `options` per platform; users pick a default per language and can re-transcribe any
recording with another option. An option with `"task": "translate"` produces an English translation instead of a transcript.

## Adding a language

1. Pick a Whisper fine-tune on Hugging Face with a license that allows redistribution
   (Apache-2.0, MIT, CC-BY…). Check the training data's license too and credit it.
2. Evaluate it on real speech in that language (not only read-speech benchmarks).
3. Convert and quantize: `scripts/convert.sh <hf-repo> <model-id> q8_0` (needs a whisper.cpp checkout and
   a Python env with `torch transformers`). It prints the size and SHA-256.
4. Publish: `scripts/publish.sh <model-id> <file>` creates the release `<model-id>-v1` and uploads the file.
5. Add the language and model to `catalog.json` (`scripts/validate.py` checks it), add
   `models/<model-id>.md`, commit, push. Apps pick it up on their next catalog refresh — no app update.

## Licenses

Each model keeps its upstream license; see the model cards and [`LICENSES/`](LICENSES). This repository's
own files (catalog, scripts, docs) are MIT.

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

| Language | Model | Size | License |
|---|---|---|---|
| Malayalam (മലയാളം) | [Whisper large-v3 turbo, IndicVoices fine-tune, q8_0](models/ml-turbo-indicvoices-q8_0.md) | 874 MB | Apache-2.0 |
| English (Android) | [Whisper small.en, q5_1](models/en-whisper-small-q5_1.md) | 190 MB | MIT |

On iOS, English uses Apple's on-device speech recognition and needs no download.

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

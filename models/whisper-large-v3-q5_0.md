# Whisper large-v3 — q5_0 (multilingual)

Served by the whisper.cpp project: [ggerganov/whisper.cpp](https://huggingface.co/ggerganov/whisper.cpp) — MIT.

Used for **English translation** (`"task": "translate"`) of Malayalam, Hindi and Arabic recordings: on a 92 s
conversational Malayalam recording it produced a clear, complete English translation where every Malayalam
transcription model struggled. Also offered for Hindi transcription (7.7% CER / 14.8% WER on FLEURS — similar to turbo, slower).
Run with no text context (`no_context`) to avoid repetition loops.

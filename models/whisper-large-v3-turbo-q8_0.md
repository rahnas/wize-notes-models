# Whisper large-v3 turbo — q8_0 (multilingual)

Served by the whisper.cpp project: [ggerganov/whisper.cpp](https://huggingface.co/ggerganov/whisper.cpp) — MIT.
Default for Hindi and for Arabic on Android; an option for English and Arabic on iOS.

FLEURS test (8 clips each, whisper.cpp beam 5 + Silero VAD): Hindi 7.2% CER / 15.7% WER; Arabic 3.0% CER / 11.5% WER
(Arabic scored without diacritics). Not suitable for Malayalam (produced no usable output on conversational Malayalam).

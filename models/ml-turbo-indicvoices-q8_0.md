# Malayalam · Whisper large-v3 turbo (IndicVoices) — q8_0

| | |
|---|---|
| File | `ggml-ml-turbo-indicvoices-q8_0.bin` (whisper.cpp ggml, q8_0) |
| Size | 874,188,075 bytes |
| SHA-256 | `bf5fef47fa6e89a80a603e9d42d133c88be2c30b5de2eb1d807492191c65e150` |
| Upstream | [BettySara/whisper-large-v3-malayalam-FT](https://huggingface.co/BettySara/whisper-large-v3-malayalam-FT) — Apache-2.0 |
| Base model | [openai/whisper-large-v3-turbo](https://huggingface.co/openai/whisper-large-v3-turbo) — MIT |
| Training data | Malayalam subset of [AI4Bharat IndicVoices](https://huggingface.co/datasets/ai4bharat/IndicVoices) — CC BY 4.0 |

## Why this model

Compared with whisper.cpp (beam 5, Silero VAD) on real conversational Malayalam recorded with a
Neo 1 pendant, against two smaller community fine-tunes and AI4Bharat IndicWhisper (medium), it was the only
one that produced natural, correctly spelled sentences:

| Model | Real clip |
|---|---|
| **this model** | പറഞ്ഞതൊട്ടും ശരിയായില്ല എന്നാലും നമുക്ക് ഒന്നുകൂടി സംസാരിച്ച് നോക്കാം മലയാളത്തിൽ പറയുന്ന കാര്യങ്ങളും… |
| IndicWhisper medium | 2 ക് പറണ്ണത് ഒട്ടും ശരിയായില്ല എന്നാലും… |
| small code-mixed | കാരിങ്ങളും റോട്ടും ശരിയായില്ല, എന്നാലും നമുക്ക് ഒന്നൂടി സംസാരിസ് നോക്കാം മലാത്തിൽ… |

It writes colloquial spellings (e.g. അതിന് rather than അതിനു), so it scores worse than the small models on
formal read-speech references (12% vs 3–11% CER on 8 OpenSLR-63 / SMC MSC clips) even though it is better on
real speech. q8_0 was kept over q5_0 (574 MB), which made more mistakes.

## How it was built

```bash
# tokenizer files are missing upstream; they are identical to openai/whisper-large-v3-turbo's
scripts/convert.sh BettySara/whisper-large-v3-malayalam-FT ml-turbo-indicvoices q8_0 \
  --tokenizer-from openai/whisper-large-v3-turbo
```

## Attribution

Malayalam speech recognition model fine-tuned by BettySara from OpenAI Whisper large-v3-turbo, trained on
IndicVoices by AI4Bharat (IIT Madras), licensed CC BY 4.0. Converted to ggml for whisper.cpp; weights
otherwise unmodified apart from 8-bit quantization.

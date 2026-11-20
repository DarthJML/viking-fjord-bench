# Viking Fjord Bench

One prompt, many AI models, one self-contained HTML file each: a Viking longship sailing through a Norwegian fjord. No libraries, no assets, no build step. Open any file in `scenes/` straight from disk, or play them live in your browser from the table below.

The exact prompt is in [PROMPT.txt](PROMPT.txt).

| Date | Model | Source | Play live |
|---|---|---|---|
| 2026-10-25 | Kimi K3.1 | [scenes/kimi-k3.1.html](scenes/kimi-k3.1.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/kimi-k3.1.html) |
| 2026-10-26 | GPT-6.1 Terra | [scenes/gpt-6.1-terra.html](scenes/gpt-6.1-terra.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gpt-6.1-terra.html) |
| 2026-10-28 | GLM 5.3 Flash | [scenes/glm-flash.html](scenes/glm-flash.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/glm-flash.html) |
| 2026-10-28 | DeepSeek v4 Flash (Hermes chat) | [scenes/hermes.html](scenes/hermes.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/hermes.html) |
| 2026-10-29 | DeepSeek 4.1 Flash 1017 (retest) | [scenes/deepseek-retest-1.html](scenes/deepseek-retest-1.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/deepseek-retest-1.html) |
| 2026-10-29 | GLM 5.3 Flash (retest) | [scenes/glm-retest-1.html](scenes/glm-retest-1.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/glm-retest-1.html) |
| 2026-11-03 | Crouton alpha | [scenes/crouton-alpha-1.html](scenes/crouton-alpha-1.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/crouton-alpha-1.html) |
| 2026-11-04 | HY4 Preview (retry) | [scenes/hy4-preview-1b-retry.html](scenes/hy4-preview-1b-retry.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/hy4-preview-1b-retry.html) |
| 2026-11-10 | Claude Fable 5.2 | [scenes/fable-5.2.html](scenes/fable-5.2.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/fable-5.2.html) |
| 2026-11-12 | Gemini 4 Hydrogen | [scenes/gemini-4-hydrogen.html](scenes/gemini-4-hydrogen.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gemini-4-hydrogen.html) |
| 2026-11-13 | Grok 4.6 | [scenes/grok-4.6.html](scenes/grok-4.6.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/grok-4.6.html) |
| 2026-11-13 | GPT-6.1 Sol | [scenes/gpt-6.1-sol.html](scenes/gpt-6.1-sol.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gpt-6.1-sol.html) |
| 2026-11-13 | Claude Opus 5.5 | [scenes/opus-5.5.html](scenes/opus-5.5.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/opus-5.5.html) |
| 2026-11-13 | Grok 4.7 | [scenes/grok-4.7.html](scenes/grok-4.7.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/grok-4.7.html) |
| 2026-11-16 | Qwen 4 Max | [scenes/qwen-4-max.html](scenes/qwen-4-max.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/qwen-4-max.html) |
| 2026-11-16 | HY4 Flash (free) | [scenes/hy4-flash.html](scenes/hy4-flash.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/hy4-flash.html) |
| 2026-11-18 | GPT-6.2 Sol | [scenes/gpt-6.2-sol.html](scenes/gpt-6.2-sol.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gpt-6.2-sol.html) |
| 2026-11-18 | GPT-6.2 Astra | [scenes/gpt-6.2-astra.html](scenes/gpt-6.2-astra.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gpt-6.2-astra.html) |
| 2026-11-18 | Gemini 4 Neon | [scenes/gemini-4-neon.html](scenes/gemini-4-neon.html) | [▶ play](https://darthjml.github.io/viking-fjord-bench/scenes/gemini-4-neon.html) |

## Honest notes
- Not a strict one-shot benchmark: some earlier entries had runtime repairs, and retests used corrected model IDs.
- The Fable 5.2 entry self-checked with headless screenshots; it was not hand-edited.
- The Gemini 4 Hydrogen entry is a single attempt with no repairs, run through Nous Portal on its release day (about 3.5 minutes, 6 model calls). Gemini 4 Carbon was run the same day with the same prompt and did not finish: three requests failed after 20 to 30 minutes each with no output, so it has no entry.
- Videos on X are captured from these actual HTML files, not generated video.
- Grok 4.6 (2026-11-13) hit its turn limit; the same session fixed the sail, shields and colour afterwards, so the live file is the repaired version.
- GPT-6.1 Sol (2026-11-13) had its motion tuned after a parent review of the clock and the ship's travel.
- Claude Opus 5.5 (2026-11-13) is a one-shot: no repairs, no retries.
- Grok 4.7 (2026-11-13) was stopped during its own self-verification; the file is as it was written at that point and was checked headless afterwards (longship, sail, shields, scene motion, no console errors).
- Qwen 4 Max (2026-11-16, Nous Portal, the day after it launched) is a single unassisted run: 63 model calls over about 68 minutes, self-checked with its own headless renders, no repairs by us. An earlier attempt was cut off by a 5-minute timer and produced nothing.
- HY4 Flash (2026-11-16, the free tier on Nous Portal) is a single unassisted run: 26 model calls in under 5 minutes, no repairs. It has no shield row along the hull.
- GPT-6.2 Sol (2026-11-18) is a single run with no repair round: a 30 KB file, about 14 minutes, 34 model calls. An earlier attempt was silently served by a fallback model, so it doesn't count and isn't published.
- GPT-6.2 Astra (2026-11-18) is a single run with no repair round: a 12 KB file, about 3.6 minutes, 8 model calls.
- Gemini 4 Neon (2026-11-18) is a one-shot with no repairs: a 73 KB file, about 8.6 minutes, 14 tool calls.

Made by [@DarthJML](https://x.com/DarthJML) with [Hermes Agent](https://github.com/NousResearch/hermes-agent).

## CAD Bench

Round 1: four models design the same printable Viking shield phone stand from one fixed OpenSCAD prompt. Renders, STL/.scad files and the rubric: [cad-bench/](https://darthjml.github.io/viking-fjord-bench/cad-bench/)

## Videos

Gemini 4 Neon bench videos: [videos/](https://darthjml.github.io/viking-fjord-bench/videos/)

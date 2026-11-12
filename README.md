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

## Honest notes
- Not a strict one-shot benchmark: some earlier entries had runtime repairs, and retests used corrected model IDs.
- The Fable 5.2 entry self-checked with headless screenshots; it was not hand-edited.
- The Gemini 4 Hydrogen entry is a single attempt with no repairs, run through Nous Portal on its release day (about 3.5 minutes, 6 model calls). Gemini 4 Carbon was run the same day with the same prompt and did not finish: three requests each timed out after 30 minutes, so it has no entry.
- Videos on X are captured from these actual HTML files, not generated video.

Made by [@DarthJML](https://x.com/DarthJML) with [Hermes Agent](https://github.com/NousResearch/hermes-agent).

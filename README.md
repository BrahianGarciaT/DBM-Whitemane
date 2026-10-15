# DBM-Whitemane

A continuation of the original `broizter/DBM-Whitemane` build of Deadly Boss Mods (DBM) for **WoW 3.3.5a**, with timers, warnings and raid markers for the **Heroic Naxxramas** and **Heroic Eye of Eternity** mechanics added by the [Whitemane](https://whitemane.gg) private server.

> **Status: experimental.** Most modules were built from real combat logs (10 and 25 player heroic runs), but only part of them has been played in a live raid. Treat timers as *very likely*, not guaranteed, and please report what you see (see [Feedback](#feedback)).

## Why this exists

Whitemane's heroic raids add new boss abilities that use **custom spell IDs** (`9250xxx`) and changed several timers. Stock DBM does not know those IDs, so the new mechanics never trigger any timer or warning, and some existing timers are off. This project teaches DBM about them.

## What is covered

| Raid | Boss | 10 HC | 25 HC | Notes |
|---|---|---|---|---|
| Naxxramas | Anub'Rekhan | yes | yes | Field-tested, timers reported as accurate |
| | Grand Widow Faerlina | yes | yes | Field-tested, timers reported as accurate |
| | Maexxna | yes | yes | Web Wrap marker + say |
| | Instructor Razuvious | yes | yes | Jagged Knife marker + say + warning |
| | Gothik the Harvester | yes | yes | Soul Convergence markers + say; phase 2 retimed |
| | The Four Horsemen | yes | yes | |
| | Noth the Plaguebringer | yes | yes | Curse say + warning; markers on 10 HC only |
| | Heigan the Unclean | yes | yes | |
| | Loatheb | yes | no data | Volatile Spores marker + say + warning |
| | Patchwerk | yes | yes | |
| | Grobbulus | yes | yes | Volatile Bile marker + say + warning |
| | Gluth | yes | yes | |
| | Thaddius | yes | yes | |
| | Sapphiron | yes | yes | |
| | Kel'Thuzad | yes | yes | |
| Eye of Eternity | Malygos | yes | no data | |

**Not covered yet:** Obsidian Sanctum, 25 player Eye of Eternity, 25 player Loatheb heroic, and anything not listed above.

## Player markers and `/say`

For mechanics where a player must react, DBM can mark the affected player and make them say it, so the raid can see who needs what:

| Boss | Mechanic | What the player should do |
|---|---|---|
| Razuvious | Jagged Knife | Move away from the group |
| Gothik | Soul Convergence | Group up with the other affected players |
| Grobbulus | Volatile Bile | Stack with the raid |
| Maexxna | Web Wrap | Get freed |
| Noth | Curse of the Plaguebringer | Move out, a puddle will drop |
| Loatheb | Volatile Spores | Go to a Purifying Mushroom |

Raid markers are only set when **you are raid leader or assistant** (standard DBM behaviour). Every marker, warning and say message has its own option in the DBM GUI and can be disabled. If you never see the say messages, check that DBM's *Don't send yells* option is off.

## Installation

1. Close the game.
2. Copy the folders of this repository into `World of Warcraft\Interface\AddOns\`, replacing the existing ones. If you already use DBM, replacing only `DBM-Naxx` and `DBM-EyeOfEternity` is enough as long as your DBM-Core is the version shipped here.
3. Start the game. Everything loads on demand, no setup needed.

Difficulty detection was verified in game: 10 HC is detected as `heroic10`, 25 HC as `heroic25`, and normal modes keep their stock behaviour.

## How it works

- New abilities are matched by their custom spell ID inside the boss module handlers. Custom IDs are never passed to constructors that look up spell info, because the 3.3.5 client does not have those spells; timers and warnings use localized text and generic icons instead.
- 10 HC and 25 HC use different IDs for the same ability (usually the 10 HC ID plus one). Each module lists both.
- Timers are based on repeated intervals measured in combat logs. When the logs only had a single sample, the timer is marked as an assumption in the in-game notes below.

## Known limitations

- Several timers come from one or two samples: Sapphiron 10 HC Frost Breath, Kel'Thuzad first Freezing Blast, Gothik 10 HC phase 2, Thaddius Polarity Shift and Chain Lightning, Faerlina first Frenzy.
- Gothik phase 2 and Noth teleports have no combat log event of their own (the boss yells), so those timers are anchored to nearby events.
- Noth 25 HC affects more players than there are raid markers: only 10 HC gets markers.
- Malygos 10 HC logs never showed a phase 3.
- Loatheb Spore Catastrophe (`9250695`) is not implemented: it looks like a consequence of failing the spore mechanic, not a timer.

## Feedback

Feedback is the most useful contribution right now. Please open an issue with:

- Boss and difficulty (10 HC / 25 HC)
- What DBM showed and what actually happened (timer, second of the fight)
- A combat log if you can (`/combatlog` before the pull, file in `Logs\WoWCombatLog.txt`). Logs contain player names, so trim or anonymise them before attaching.
- Any Lua error text

Improvements to timers and new mechanics are welcome as pull requests.

## Credits and license

- **Deadly Boss Mods** by the DBM authors.
- **Upstream:** this project continues from the `DBM-Whitemane` build by [broizter](https://github.com/broizter) (`broizter/DBM-Whitemane`, version 11.5.5 of DBM-Core). That repository is no longer available, so this one acts as its continuation: all credit for the base build goes to its author, and the Heroic Naxxramas / Eye of Eternity work is built on top of it.
- Mechanic names and general descriptions: [Whitemane heroic raids announcement](https://whitemane.gg/en/news/heroic-raids-open-today).
- Not affiliated with Whitemane, Blizzard Entertainment or the DBM team.

DBM is distributed under the **Creative Commons Attribution-NonCommercial-ShareAlike 3.0** license (see [`DBM-Core/license.txt`](DBM-Core/license.txt)). The same license applies to this repository: keep the attribution, do not use it commercially, and share derivatives under the same terms.

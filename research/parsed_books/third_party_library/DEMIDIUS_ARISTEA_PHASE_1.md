# Third-Party Library Search: Demidius and Aristea

## Phase 1 scope

This is the first content-level pass over `Pathfinder/3rd Party`, excluding the Legendary Games and Super Genius Games folders that already have dedicated reviews. The library contains 2,261 PDFs from 33 top-level publisher folders. This pass selected 137 unique PDFs from 16 publishers and extracted 3,471 PDF pages, including 3,367 text-bearing pages and about 13.9 million characters. Rogue Genius books stored separately under `RGG` remained in scope when their specific options had not yet been evaluated for these builds.

The four priority batches were:

| Batch | Selected PDFs | PDF pages | Text-bearing pages | Purpose |
|---|---:|---:|---:|---|
| Character core | 18 | 163 | 141 | Oracle, wizard, Arcane Trickster, Charisma, Leadership, and luck options |
| Mythic | 74 | 722 | 698 | Mythic feats, class features, paths, and deity-linked options |
| Naval and water | 24 | 1,510 | 1,464 | Ship spells, water/cold options, sailing support, and naval rules |
| Spells and crafting | 24 | 1,095 | 1,083 | Large spell compilations, crafting, action economy, and ray support |

The local page indexes are under `tmp/3pp-corpus/` and are intentionally excluded from Git. `scripts/extract_3pp_library.py` provides a reproducible page-aware indexer. The source PDFs remain outside Git.

All mechanics below are paraphrased. Printed page numbers and PDF indices are both given when they differ. “Verified” means the relevant source page was rendered and visually checked, not merely found by text search.

## Executive shortlist

### Demidius

| Grade | Candidate | Why it matters | Access and caution | Source |
|---|---|---|---|---|
| S | **Mythic Leadership** | Adds mythic tier to Leadership score, gives the cohort half the leader's tier, and at tier 5 makes the ten highest-level followers mythic tier 1. At Demidius's current tier 7, the raw Leadership increase is +7 and the cohort would be tier 3. | Requires Leadership and mythic tier 2. Interaction with the campaign's Epic Leadership and follower multiplier needs a GM calculation. | Rogue Genius Games, *Mythic Options: The Missing Core Feats*, printed/PDF p. 11. Verified. |
| S if accessible | **Insightful Counterspell** revelation | Immediate-action counterspell functioning as *greater dispel magic*, usable half oracle level per day. At oracle 17 that is 8 uses/day. | Arcana mystery, oracle 7. Demidius already used Strange Revelation for Sidestep Secret, and that feat does not say it can be selected repeatedly. A new access route or GM approval is required. | Rite Publishing, *The Secrets of the Oracle*, printed p. 1 / PDF p. 3. Verified. |
| S if accessible | **Fatespinner** revelation | Immediate-action activation creates a 30-foot aura granting an insight bonus equal to half oracle level to attacks, initiative, and all saves for oracle-level total rounds/day. | Luck mystery. Competes with the Seven-Pipped Gem for immediate actions and needs a legal off-mystery route. | Rite Publishing, *The Secrets of the Oracle*, printed pp. 3-4 / PDF pp. 5-6. |
| A+ if approved | **Mythic Mystery (Power)** | Adds half tier to checks with mystery-granted class skills and adds full tier to oracle level for revelation effectiveness and duration, without granting early access. It also increases uses for many limited-use revelations. | The book's mystery-specific riders do not list Juju, but the general feature still applies if this third-party class-feature system is allowed. At tier 7, Demidius's revelations would function as oracle level 24 for effectiveness and duration. | Rogue Genius Games, *Mythic Options: Mythic Base Class Features*, PDF pp. 14-16. |
| A | **Divine Intervention** revelation | Immediate-action reroll of any die, keeping the higher result, half oracle level/day. | Luck mystery, oracle 11; strong but overlaps the Seven-Pipped Gem and uses the same immediate-action economy. | Rite Publishing, *The Secrets of the Oracle*, printed p. 3 / PDF p. 5. |
| A | **Dormant Spell** | A helpful single-target spell can be cast in advance on a willing creature and triggered later as a standard action regardless of range. Activation is not spellcasting. | Costs a slot one level higher and expires when the caster refreshes spells. Excellent for remote crew or cohort preparation. | Open Design, *Advanced Feats: Visions of the Oracle*, PDF pp. 6-7. |
| A- | **Transfer Spell** | Changes a personal spell to touch, allowing powerful self-only wizard buffs to be shared. | +1 spell level; combines unusually well with Demidius's campaign ability to prepare wizard spells as divine spells. | Open Design, *Advanced Feats: Visions of the Oracle*, PDF p. 11. |
| B+ strategic | **Great Orator** | A one-minute speech gives each listening cohort/follower a stored +1 bonus usable on one roll during the next several hours. | Small numeric bonus, but it scales across a ship or organization. | Abandoned Arts, *Feats of Leadership*, PDF p. 2. |
| B strategic | **Team Spirit** | Followers receive +4 morale on skill checks made to aid another. | Best for organized shipboard work, repairs, research, or construction rather than combat. | Abandoned Arts, *Feats of Leadership*, PDF p. 2. |

### Aristea

| Grade | Candidate | Why it matters | Access and caution | Source |
|---|---|---|---|---|
| S at level 19 | **Master of the Unseen Spell** | When Invisible Spell, Silent Spell, or Still Spell is applied to a hit-point-damaging spell, Aristea may add sneak-attack damage a number of times/day equal to Intelligence modifier. The feat does not require the target to be flat-footed. | Requires Int 17, 12 ranks in Spellcraft and Stealth, and Arcane Trickster 9. Aristea reaches Arcane Trickster 9 at character level 19 on the current plan. It does not stack with Surprise Spells, but it remains valuable when the target is not flat-footed. | Louis Porter Jr. Design, *UndeFEATable 11: Arcane Trickster*, printed/PDF p. 3. Verified. |
| S mechanically; GM review | **Torn Muscle** | A 2nd-level sorcerer/wizard spell makes one living target permanently flat-footed, unable to run, and imposes -4 to attacks, skills, and ability checks. A flat-footed target qualifies for Aristea's campaign Sap Master engine. | Fortitude negates, spell resistance applies, and 2nd-level-or-higher healing, fast healing, or regeneration ends it. The permanent flat-footed condition is far above normal 2nd-level balance; require explicit GM approval. | Rite Publishing, *1001 Spells*, printed p. 238 / PDF p. 241. |
| A+ | **Distract** | A 1st-level sorcerer/wizard spell makes one target flat-footed for one round and removes its remaining actions in the current round. Quickened *distract* followed by a ray spell creates a direct Sap Master setup. | Will negates and spell resistance applies. Unlike merely denying Dexterity to AC, the spell explicitly says flat-footed. | Rite Publishing, *1001 Spells*, printed p. 97 / PDF p. 100. |
| A | **Incomprehensible Caster** | A tricky or metamagic spell becomes impossible to identify. A creature attempting to identify it is denied Dexterity to AC for one round. | Denial of Dexterity enables ordinary sneak attack, but not Sap Master, because the target is not expressly flat-footed. | Louis Porter Jr. Design, *UndeFEATable 11: Arcane Trickster*, printed/PDF p. 3. Verified. |
| A- | **Accurate Spells** and **Greater Accurate Spells** | The chain improves Reflex-save spell DCs, with the greater feat adding a further bonus against flat-footed targets. | Two-feat cost; best only if Aristea adds more Reflex-save control alongside rays. | Louis Porter Jr. Design, *UndeFEATable 11: Arcane Trickster*, PDF pp. 1-2. |
| B+ | **Metamagic Mastery** | Reduces the slot adjustment of one selected metamagic feat by 1, to a minimum of +1. | Cannot make a +1 adjustment free. Compare with Spell Perfection and existing trait reductions before spending a feat. | Louis Porter Jr. Design, *UndeFEATable 1: Wizards and Sorcerers*, PDF p. 3. |
| B+ | **Spell Thesis** | Grants +2 on concentration checks and caster-level checks involving one chosen spell. | A practical *scorching ray* specialization if the bonus applies to spell-resistance checks as expected; confirm interpretation. | Abandoned Arts, *Class Acts: Wizards*, PDF p. 3. |

## Ship, water, and fleet support

| Grade | Option | Application | Source |
|---|---|---|---|
| S ship utility | **St. Mirolch's Water Snakes** | 5th-level wizard or 4th-level oracle spell; creates or controls surface currents in a one-mile radius for 10 minutes/level. Currents carry vessels and floating creatures horizontally at up to 60 feet. Aristea can prepare it directly; Demidius may have access through the campaign's wizard-spell rule. It can also steer hostile ships into hazards. | Open Design, *Deep Magic*, printed p. 227 / PDF p. 228. Verified. |
| A ship speed | **Shadow Sails** | 4th-level wizard spell; replaces the vessel's sails for 1 hour/level and increases maximum speed and acceleration by 50%. The sails cannot be damaged but still require wind. On the Dawnrunner's current 50-foot speed this suggests 75 feet before adjudicating stacking. | Jon Brazer Enterprises, *Book of Magic: Pirate Spells*, printed p. 6 / PDF p. 7. |
| A ship defense | **Dwarven Stone Plating** | 6th-level wizard spell; grants a vehicle DR 20/adamantine for 10 minutes/level until it has prevented 20 damage/caster level, maximum 400. | Jon Brazer Enterprises, *Book of Magic: Pirate Spells*, printed p. 5 / PDF p. 6. |
| A exploration | **Sodden Ship** | 7th-level oracle/wizard spell; lets a ship travel underwater with a dry interior for 1 hour/level while deck occupants breathe water near the vessel. | Jon Brazer Enterprises, *Book of Magic: Pirate Spells*, printed p. 7 / PDF p. 8. |
| B+ | **Calm the Waves** | 6th-level oracle/wizard spell; calms rough water in a large area for 30 minutes/level and adds 1 mph to sailing-ship speed. | Open Design, *Deep Magic*, printed p. 138 / PDF p. 139. |
| B tactical | **Kelp Grapples** | 4th-level wizard spell that grapples two vessels with durable magical kelp and pulls the lower-CMD vessel toward the other. | Jon Brazer Enterprises, *Book of Magic: Pirate Spells*, printed p. 5 / PDF p. 6. |
| B tactical | **Barnacle Growth** | 4th-level wizard spell that halves one enemy vessel's maximum speed and acceleration and imposes -4 on its driving checks. | Jon Brazer Enterprises, *Book of Magic: Pirate Spells*, printed p. 4 / PDF p. 5. |

These speed effects should not be assumed to stack. *Shadow sails* modifies the ship's maximum speed, *water snakes* creates a current that carries vessels at up to 60 feet, *calm the waves* adds 1 mph, and the already-noted *wandering weather* changes travel conditions. Their interaction needs one ship-movement ruling before a final Dawnrunner speed package is published.

## Crafting findings

Rogue Genius's mythic item-creation feats allow one use of mythic power at the beginning of a workday to produce eight additional hours of progress; the crafter may then work another eight hours normally. Individual feats add other benefits, such as rechargeable three-use-per-day wands, flexible property changes, or combining wondrous items. See *Mythic Options: The Missing Core Feats*, PDF pp. 6-7.

Aristea already has Mythic Crafting Mastery. These feats are therefore **comparison candidates, not automatic recommendations**: they may duplicate her present crafting acceleration, and spending additional mythic feats on separate item categories is unlikely to be efficient unless one of the special riders is specifically desired.

## Options filtered out in this pass

- Luckbringer feats generally require Luckbringer class features and are not plug-in options for Demidius.
- Strange Revelation does not state that it may be selected more than once. Demidius already used it for Sidestep Secret, so the new Arcana and Luck revelations are not presently legal without another access mechanism.
- Permanent Magic is a wizard-20 class feature and is not a near-term option for Aristea's multiclass progression.
- Mythic Quicken Spell in the reviewed Rogue Genius book requires mythic tier 10, above the characters' current tier.
- Egyptian-deity mythic feat chains contain powerful Charisma, abjuration, and leadership effects, but their deity prerequisites do not naturally fit Hermes, Aphrodite, or Nereus and need setting-level approval before build analysis.

## Ruling and verification queue

1. Decide whether Strange Revelation can be selected more than once or whether another approved ability can grant an off-mystery revelation.
2. Decide whether *torn muscle* is allowed as printed; its permanent flat-footed rider is exceptionally strong for a 2nd-level spell.
3. Confirm whether Master of the Unseen Spell adds sneak attack once to the spell's total damage or to each ray under the campaign's multi-ray ruling. The printed feat says it adds the damage “dealt by the spell,” not explicitly per attack roll.
4. Decide how *shadow sails*, *St. Mirolch's water snakes*, *calm the waves*, *wandering weather*, and the ship's base speed interact.
5. Compare Mythic Crafting Mastery against the individual Rogue Genius mythic item-creation feats before recommending any feat expenditure.
6. Confirm whether Demidius's campaign wizard-spell access includes the third-party wizard spells approved from this library.
7. Verify the Mythic Mystery (Power) interaction with Juju and Demidius's exact revelations before assigning final numerical gains.

## Next content passes

1. Complete the remaining oracle, luck, Charisma, dispel, and Leadership books outside the already-reviewed publishers.
2. Build a spell-level shortlist for Aristea organized around rays, explicit flat-footed setup, cold/water descriptors, and Benthic compatibility.
3. Review transformation and animal-lord-adjacent material for Aristea's narwhal identity without replacing her current class progression.
4. Review remaining naval sourcebooks for ship templates, speed multipliers, crew actions, and galleon upgrades.
5. Search item-creation subsystems specifically for cost reduction, parallel crafting, portable workshops, and constructs that can assist without duplicating Mythic Crafting Mastery.

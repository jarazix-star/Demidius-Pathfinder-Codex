# Mythic Spell Compendium: Full Demidius Relevance Sweep

**Rules extraction status:** Verified full-text extraction.

**Evaluation status:** Every entry received a structured Demidius relevance score and rating. Build-critical/high-tier entries were manually reviewed; the remainder are explicitly marked `Automated first-pass` and should be manually promoted before becoming a permanent build recommendation.

## Scope

- **2,100 unique mythic spell entries** extracted from *Mythic Spell Compendium*.
- **393 entries** extracted from *Mythic Magic: Core Spells*.
- **392 exact-name matches** between the books.
- **1 Core-only exact-name entry:** *Charm Persona*.
- **1,708 Compendium entries** have no exact-name counterpart in *Core Spells*.

Every spell row includes rating, relevance score, PDF page, tags, rules summary, Demidius-specific recommendation, rules-verification status, evaluation method, and full bibliographic citation.

## Rating Distribution

| Rating | Count | Meaning |
|---|---:|---|
| S+ | 1 | Build-defining, manually reviewed |
| S | 5 | Excellent, manually reviewed |
| A+ | 15 | Very strong, manually reviewed |
| A | 74 | Strong/manual or top automated candidate |
| B+ | 104 | Good situational |
| B | 419 | Situational |
| C | 1389 | Niche |
| D | 93 | Usually skip |

## Manually Reviewed Priority Spells

| Spell | Rating | PDF page | Why it matters |
|---|---:|---:|---|
| Dispel Magic, Greater | S+ | 76 | Build-defining mythic dispel and counterspell package; retain as Spell Perfection target. |
| Blessing Of Fervor | S | 34 | One of the best party buffs, offering flexible action, defense, and mobility benefits. |
| Euphoric Tranquility | S | 89 | Powerful encounter-ending enchantment after mental defenses are stripped. |
| Forcecage | S | 102 | Exceptional no-save battlefield partition and durable mythic control. |
| Overwhelming Presence | S | 168 | Top-tier mass enchantment/control once immunity and mind blank are removed. |
| Permanency | S | 171 | Protects long-term magical infrastructure and makes selected effects harder to remove. |
| Beacon Of Luck | A+ | 29 | Party-facing luck support with excellent thematic fit. |
| Borrow Fortune | A+ | 39 | Excellent reroll access and luck-theme synergy; manage the delayed penalty. |
| Death Ward | A+ | 67 | Essential protection against death effects, negative levels, and negative energy. |
| Discern Location | A+ | 75 | Top-tier target-finding and rescue utility. |
| Dominate Monster | A+ | 78 | Broad high-level domination; excellent post-dispel finisher. |
| Forbiddance | A+ | 102 | High-value headquarters, temple, demiplane, and planar-travel denial. |
| Freedom | A+ | 104 | Direct answer to imprisonment and related permanent incapacitation; highly relevant to rescue arcs. |
| Freedom Of Movement | A+ | 104 | Core defense against grapples, paralysis-like restraints, and movement denial. |
| Gate | A+ | 107 | Exceptional planar travel, rescue, and calling utility; expensive calling uses require caution. |
| Heroism, Greater | A+ | 119 | Excellent long-duration competence package for key allies. |
| Mind Blank | A+ | 156 | Essential high-level mental and divination defense; also a key enemy protection to identify and dispel. |
| Miracle | A+ | 157 | Divine flexibility and emergency problem-solving; central to Demidius's role. |
| Moment Of Prescience | A+ | 158 | Large flexible insight bonus for a decisive check, save, or defense. |
| Prismatic Wall | A+ | 179 | Extremely durable battlefield denial with layered effects. |
| True Resurrection | A+ | 254 | Best conventional restoration after soul recovery, though it cannot free a trapped soul. |
| Binding | A | 31 | Flexible long-duration/permanent containment, preparation-heavy but powerful. |
| Blessed Chance | A | 34 | Luck-focused reliability effect worth preparing when its trigger profile is useful. |
| Charm Monster, Mass | A | 51 | Mass social and combat control; immunity remains the limiting factor. |
| Commune | A | 54 | Reliable divine intelligence for planning and investigation. |
| Compelling Fate | A | 54 | Fate manipulation and control fit Demidius, subject to exact target/save profile. |
| Dimensional Anchor | A | 74 | Reliable single-target escape denial. |
| Embrace Destiny | A | 85 | Pre-roll storage/manipulation fits the luck engine and decisive-check playstyle. |
| Exalted Chance | A | 90 | Strong luck/reliability support for critical rolls. |
| Imprisonment | A | 128 | Potent no-save-on-hit permanent removal, but touch range and reversibility matter. |
| Legend Lore | A | 140 | Strong investigation tool for legendary creatures, places, and items. |
| Mage’S Magnificent Mansion | A | 151 | Safe mobile headquarters and high-level expedition support. |
| Resurrection | A | 197 | Important restoration once a trapped soul is freed; mythic version reduces cost and penalties. |
| Reverse Scry | A | 197 | Strong counter-divination and intelligence tool; mythic version bypassing SR is notable. |
| Spell Turning | A | 226 | Strong high-level spell defense, though less reliable against areas and indirect effects. |
| Teleport | A | 245 | Strong strategic mobility and emergency extraction. |
| Contact Other Plane | B+ | 55 | Powerful information with risk; improved by planar-focused abilities. |
| Raise Dead | B+ | 187 | Useful lower-cost restoration but weaker than resurrection options at this tier. |
| Spell Resistance | B+ | 225 | Useful defense but can impede allied magic and becomes less reliable at mythic levels. |

## Demidius Use Doctrine

1. **Open with anti-magic:** identify and strip mind blank, freedom of movement, death ward, spell turning, contingencies, and escape protections.
2. **Exploit the opening:** follow with no-save control, durable force effects, or enchantment after immunity-granting effects are removed.
3. **Prefer tempo over damage:** immediate, swift, contingency, and time-manipulation effects outrank direct damage because the party already has overwhelming DPR.
4. **Use Inspired Spell and broad wizard-as-divine access for niche entries:** many B/C spells are excellent situational answers without deserving permanent build investment.
5. **Treat infrastructure spells as strategic assets:** permanency, forbiddance, dimensional lock, mansion effects, and planar travel matter more in this campaign than in a standard adventuring game.

## Search and filtering

Use the CSV in a spreadsheet or run `python scripts/search_spells.py` with a keyword, rating, or tag. The `evaluation_method` column distinguishes manual conclusions from automated first-pass triage.

## Files

- `mythic_spell_compendium_demidius_sweep.csv` - searchable 2,100-spell audit.
- `mythic_spell_compendium_demidius_sweep.json` - machine-readable equivalent.
- `mythic_magic_core_spells_demidius_sweep.csv` - 393-spell Core Spells audit.
- `mythic_magic_core_vs_compendium_difference_audit.csv` - exact-name and text-difference audit.
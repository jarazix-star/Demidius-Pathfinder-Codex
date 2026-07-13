---
title: Campaign Rules Appendix
version: 2.0.0
status: canonical
last_updated: 2026-07-13
---

# Campaign Rules Appendix

This appendix is the canonical source for campaign-specific rulings used throughout the Demidius Pathfinder Research Codex. Each rule has a stable identifier so dependent chapters and database entries can cite it without restating the ruling.

## Verification labels

- **Verified Campaign Rule:** confirmed by the player as the table's current ruling.
- **GM Review:** application to a new edge case still requires adjudication.
- **Superseded:** retained for history but no longer used.

## Luck Engine rules

### CR-01 — Fortune's Child

- **Status:** Verified Campaign Rule
- **Ruling:** Fortune's Child increases every applicable luck bonus Demidius receives by **+1**.
- **Affected systems:** Luck Engine, Dispel Engine, ability scores, saves, skills, caster-level checks, and converted luck bonuses.

### CR-02 — Fate's Favored

- **Status:** Verified Campaign Rule
- **Ruling:** Fate's Favored increases every applicable luck bonus Demidius receives by **+1**.
- **Stacking:** It stacks with Fortune's Child under CR-03.

### CR-03 — Separate modifiers to the same luck bonus

- **Status:** Verified Campaign Rule
- **Ruling:** Fortune's Child and Fate's Favored are separate modifiers. Both increase the same qualifying luck bonus.
- **Standard formula:** `final luck bonus = base luck bonus + 1 (Fortune's Child) + 1 (Fate's Favored)`.

### CR-04 — Make Your Own Luck conversion

- **Status:** Verified Campaign Rule
- **Ruling:** When Make Your Own Luck converts a competence, insight, or morale bonus into a luck bonus, both Fortune's Child and Fate's Favored increase the converted bonus by **+1 each**.
- **Net effect:** A converted bonus is normally **2 points larger** than its original value, subject to ordinary non-stacking rules for multiple luck bonuses.

### CR-05 — Seven-Pipped Gem

- **Status:** Verified Campaign Rule
- **Base effect at 17 HD:** **+8 luck** to any d20 roll, equal to one-half Hit Dice.
- **Gambling or Sleight of Hand:** **+17 luck**, equal to full Hit Dice.
- **After CR-01 and CR-02:**
  - Standard d20 roll: **+10 luck**.
  - Gambling or Sleight of Hand: **+19 luck**.
- **Timing:** May be declared before or after seeing the die, but before the GM announces success or failure.
- **Action:** Immediate action; therefore normally once per round.
- **Uses:** Up to Demidius's Charisma-bonus uses.
- **Scope:** Any d20 roll, including caster-level and dispel checks.

### CR-06 — Luckstone

- **Status:** Verified Campaign Rule
- **Ruling:** The luckstone's base **+1 luck bonus** is increased by Fortune's Child and Fate's Favored.
- **Final value:** **+3 luck** to each roll or check covered by the item.

### CR-07 — Eyebrow Piercing of Confidence

- **Status:** Verified Campaign Rule
- **Item type:** Artifact and Demidius's **legendary item**.
- **Base effect:** **+4 luck bonus** to Intelligence, Wisdom, and Charisma.
- **After CR-01 and CR-02:** **+6 luck bonus** to all three mental ability scores.
- **Additional effect:** Increases the DC of Fatal Flaws by **5**.
- **Build consequences:** Raises oracle DCs, bonus spells, Charisma-based features and skills, Leadership, and Seven-Pipped Gem uses.

### CR-08 — Invoke Deity (Luck) and Ring of Continuation

- **Status:** Verified Campaign Rule
- **Ruling:** Demidius commonly casts Invoke Deity (Luck) and uses a Ring of Continuation to maintain it as an all-day effect.
- **Luck interaction:** Applicable luck bonuses granted by the spell are increased by CR-01 and CR-02.
- **Audit note:** Record the exact spell version and each granted bonus in the option database when source text is reverified.

## Spellcasting rules

### CR-09 — Wizard spells as divine spells

- **Status:** Verified Campaign Rule
- **Ruling:** Demidius can cast any wizard spell as a divine spell.
- **Optimization effect:** Wizard spells are valid recommendations and may interact with divine-only class features where the table permits.

### CR-10 — Spell Perfection interpretation

- **Status:** Verified Campaign Rule
- **Ruling:** Spell Perfection does not double Fate's Favored, obedience boons, traits, item bonuses, class features, or mythic path abilities merely because a feat participates in obtaining them.
- **Application:** Only bonuses that qualify under Spell Perfection's own wording are doubled.

## Character and campaign rules

### CR-11 — Custom obedience system

- **Status:** Verified Campaign Rule
- **Ruling:** Custom Hermes obedience/divine-power options replace part of the normal obedience framework.
- **Build consequence:** Diverse Obedience is retrainable if its remaining +2 effective boon progression is not uniquely needed.

### CR-12 — Epic Leadership

- **Status:** Verified Campaign Rule
- **Ruling:** The campaign uses Epic Leadership from the 3.5 Epic Level Handbook, including campaign-specific follower calculations and item-based follower multipliers.

### CR-13 — Post-20 and mythic progression

- **Status:** Verified Campaign Rule
- **Ruling:** The campaign progresses beyond level 20 and uses mythic rules and compatible 3PP material.

### CR-14 — Demidius's combat role

- **Status:** Verified Build Assumption
- **Ruling:** Optimize first for certainty, magical defense removal, battlefield control, party enablement, and social command—not personal weapon damage.
- **Consequence:** The rapier and Divine Fighting Technique are backup tools and retraining candidates.

## Dependency map

| Rule | Primary dependents |
|---|---|
| CR-01–CR-04 | Luck Engine, Make Your Own Luck, all converted bonuses |
| CR-05 | Dispel Engine, emergency d20 checks, action economy |
| CR-06 | Saves, skills, ability checks, general reliability |
| CR-07 | Character statistics, spell DCs, Leadership, legendary-item progression |
| CR-08 | Daily buff suite, Luck Engine |
| CR-09 | Spell recommendations, Inspired Spell, spell database |
| CR-10 | Spell Perfection analysis |
| CR-11 | Retraining and obedience chapters |
| CR-12 | Leadership Engine |
| CR-13 | Post-20 and mythic planning |
| CR-14 | Recommendation and retraining priorities |

## Change control

When a campaign ruling changes:

1. Update this appendix first.
2. Update `database/rules.json`.
3. Search the repository for the affected CR identifier.
4. Re-evaluate every dependent recommendation.
5. Record the change in `CHANGELOG.md`.

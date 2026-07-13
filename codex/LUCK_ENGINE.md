---
title: The Luck Engine
version: 2.0.0
status: canonical
depends:
  - CR-01
  - CR-02
  - CR-03
  - CR-04
  - CR-05
  - CR-06
  - CR-07
  - CR-08
---

# The Luck Engine

## Probability manipulation as a strategic resource

Demidius is optimized around **certainty**, not damage. His luck infrastructure supports dispelling, saving throws, spellcasting, social checks, Leadership, and the mental ability scores that power his oracle chassis.

Canonical rulings are maintained in [Campaign Rules Appendix](../appendices/campaign-rules.md), especially CR-01 through CR-08.

## Permanent infrastructure

### Eyebrow Piercing of Confidence — legendary item

- Base: +4 luck to Intelligence, Wisdom, and Charisma.
- Campaign value: **+6 luck** to each mental score through CR-01, CR-02, and CR-03.
- Other effect: +5 to the DC of Fatal Flaws.
- Strategic value: spell DCs, bonus spells, Charisma-based abilities and skills, Leadership, and Seven-Pipped Gem uses.
- **Verification:** Verified Campaign Rule.
- **Dependencies:** CR-01, CR-02, CR-03, CR-07.

### Luckstone

- Base: +1 luck to its covered rolls and checks.
- Campaign value: **+3 luck** through CR-01 and CR-02.
- Always-on reliability makes it the baseline layer of the Luck Engine.
- **Verification:** Verified Campaign Rule.
- **Dependencies:** CR-01, CR-02, CR-03, CR-06.

### Invoke Deity (Luck)

- Commonly maintained all day through a Ring of Continuation.
- Every applicable luck bonus granted by the spell receives +1 from Fortune's Child and +1 from Fate's Favored.
- Exact spell benefits remain a source-text audit item.
- **Verification:** Campaign use verified; exact spell extraction pending.
- **Dependencies:** CR-01, CR-02, CR-03, CR-08.

## Reactive certainty

### Seven-Pipped Gem

At 17 HD:

| Use | Base | Fortune's Child | Fate's Favored | Final |
|---|---:|---:|---:|---:|
| Any d20 roll | +8 | +1 | +1 | **+10 luck** |
| Gambling or Sleight of Hand | +17 | +1 | +1 | **+19 luck** |

Operational rules:

- May be used after seeing the die.
- Must be declared before the GM announces success or failure.
- Uses an immediate action, normally limiting it to once per round.
- Uses per day equal Demidius's Charisma bonus.
- Applies to any d20 roll, including dispel and caster-level checks.

**Verification:** Verified Campaign Rule.  
**Dependencies:** CR-01, CR-02, CR-03, CR-05, CR-07.

## Converted luck

### Make Your Own Luck

Make Your Own Luck can convert a competence, insight, or morale bonus into a luck bonus. Under CR-04, the converted bonus is then increased by Fortune's Child and Fate's Favored.

Example:

```text
+6 insight bonus
→ converted to +6 luck
→ +1 Fortune's Child
→ +1 Fate's Favored
= +8 luck
```

This does **not** make multiple luck bonuses stack. The converted effect must still be checked against existing luck bonuses applying to the same statistic or roll.

**Verification:** Printed option verified; campaign interaction verified.  
**Dependencies:** CR-01, CR-02, CR-03, CR-04.

## Tactical spending priorities

Use the Seven-Pipped Gem only after seeing the natural die unless the situation forces an earlier declaration.

Recommended priority:

1. A dispel or caster-level check that determines whether enemy immunity or escape magic remains.
2. A saving throw against domination, imprisonment, death, or loss of action economy.
3. A concentration or counterspell check that prevents an encounter-ending spell.
4. Initiative when acting first materially changes the encounter.
5. A decisive social, planar, or mission-critical skill check.
6. Attack or routine skill checks only when failure has exceptional consequences.

## Resource conflicts

The Gem uses an immediate action. It competes with:

- Immediate-action Mythic Greater Dispel Magic.
- Flexible Counterspell.
- Other immediate defenses.

Before each round, decide which reaction matters most: **guarantee your own roll** or **interrupt the enemy's action**.

## Luck synergy matrix

| Component | Function | Rules dependency | Verification |
|---|---|---|---|
| Fortune's Child | +1 to qualifying luck bonuses | CR-01 | Verified Campaign Rule |
| Fate's Favored | +1 to qualifying luck bonuses | CR-02 | Verified Campaign Rule |
| Separate stacking | Both modifiers apply | CR-03 | Verified Campaign Rule |
| Make Your Own Luck | Converts three bonus types into luck | CR-04 | Printed option + campaign ruling |
| Seven-Pipped Gem | Reactive +10/+19 luck burst at 17 HD | CR-05 | Verified Campaign Rule |
| Luckstone | Permanent +3 on covered rolls/checks | CR-06 | Verified Campaign Rule |
| Eyebrow Piercing | Permanent +6 mental scores | CR-07 | Verified Campaign Rule |
| Invoke Deity (Luck) | All-day luck package | CR-08 | Campaign use verified; spell audit pending |
| Bound by Honor | More mythic power for mythic luck/control options | Separate printed source | Verified; GM review on vow choice |
| Inexplicable Luck (Mythic) | Emergency d20 certainty | Printed source | Verified focused extraction |

## Research queue

Audit every source for:

- Explicit luck bonuses.
- Competence, insight, and morale bonuses eligible for Make Your Own Luck.
- Rerolls, roll-twice effects, die replacement, and post-roll modifiers.
- Immediate-action conflicts.
- Effects keyed to Charisma or legendary items.
- Effects that protect luck bonuses from dispelling or suppression.

# Mythic Magic: Core Spells vs. Mythic Spell Compendium

**Audit status:** Verified programmatic full-text comparison, with manual-review flags for low-overlap entries.

## Executive Result

The Compendium is the later and substantially broader source. It includes exact-name counterparts for 392 of the 393 extracted Core Spells entries, while adding approximately 1,708 exact-name-new entries.

| Difference class | Count | Interpretation |
|---|---:|---|
| Text-identical | 68 | Normalized rules text is identical. |
| Editorial / formatting-only | 86 | Rules appear materially unchanged; differences are layout, hyphenation, or very light editing. |
| Minor revision | 188 | Small clarifications or wording changes; later Compendium text should govern. |
| Substantive revision | 48 | Meaningful wording difference detected; review before relying on the older text. |
| Major rewrite / extraction review | 2 | Large difference or extraction-boundary issue; manual comparison required. |
| Core-only / absent by exact name | 1 | No exact-name Compendium entry found; check for rename or omission. |

## Flagged Entries

| Spell | Status | Core page | Compendium page | Similarity |
|---|---|---:|---:|---:|
| Analyze Dweomer | Major rewrite / extraction review | 34 | 18 | 90.8 |
| Animal Growth | Substantive revision | 34 | 19 | 97.0 |
| Arcane Eye | Substantive revision | 35 | 22 | 96.1 |
| Bless Water | Substantive revision | 37 | 34 | 96.4 |
| Call Lightning Storm | Substantive revision | 37 | 45 | 97.0 |
| Charm Persona | Core-only / absent by exact name | 38 | — | — |
| Control Water | Substantive revision | 41 | 57 | 96.1 |
| Create Undead | Substantive revision | 41 | 60 | 96.7 |
| Daze Monster | Substantive revision | 44 | 66 | 96.8 |
| Deeper Darkness | Substantive revision | 44 | 68 | 95.5 |
| Disguise Self | Substantive revision | 47 | 75 | 96.7 |
| Dispel Good | Substantive revision | 48 | 76 | 95.2 |
| Dispel Law | Major rewrite / extraction review | 48 | 76 | 90.8 |
| Doom | Substantive revision | 52 | 78 | 95.7 |
| Elemental Body (All) | Substantive revision | 52 | 83 | 96.4 |
| Eyebite | Substantive revision | 54 | 91 | 96.5 |
| Fabricate | Substantive revision | 54 | 93 | 95.6 |
| Gate | Substantive revision | 56 | 107 | 96.7 |
| Geas/Quest | Substantive revision | 56 | 108 | 94.0 |
| Ghost Sound | Substantive revision | 57 | 109 | 96.2 |
| Giant Form (All) | Substantive revision | 57 | 111 | 96.7 |
| Heal Mount | Substantive revision | 59 | 117 | 96.1 |
| Heal, Mass | Substantive revision | 59 | 117 | 93.9 |
| Heroes’ Feast | Substantive revision | 59 | 118 | 96.9 |
| Hypnotism | Substantive revision | 61 | 124 | 96.8 |
| Implosion | Substantive revision | 62 | 128 | 96.8 |
| Insanity | Substantive revision | 62 | 131 | 96.6 |
| Invisibility, Greater | Substantive revision | 63 | 133 | 95.4 |
| Keen Edge | Substantive revision | 64 | 137 | 94.7 |
| Know Direction | Substantive revision | 64 | 138 | 96.9 |
| Light | Substantive revision | 65 | 143 | 96.8 |
| Mage’S Magnificent Mansion | Substantive revision | 66 | 151 | 93.8 |
| Magic Circle Against Good | Substantive revision | 67 | 151 | 95.0 |
| Magic Circle Against Law | Substantive revision | 67 | 151 | 95.2 |
| Mind Blank | Substantive revision | 68 | 156 | 96.5 |
| Mind Fog | Substantive revision | 68 | 156 | 96.2 |
| Mount | Substantive revision | 70 | 159 | 96.1 |
| Owl’S Wisdom, Mass | Substantive revision | 71 | 168 | 94.2 |
| Persistent Image | Substantive revision | 72 | 172 | 96.6 |
| Planar Binding, Greater | Substantive revision | 72 | 174 | 96.6 |
| Plant Growth | Substantive revision | 73 | 175 | 96.7 |
| Ray Of Exhaustion | Substantive revision | 77 | 188 | 94.8 |
| Read Magic | Substantive revision | 77 | 189 | 96.7 |
| Repel Vermin | Substantive revision | 78 | 193 | 96.4 |
| Righteous Might | Substantive revision | 80 | 198 | 96.7 |
| Secure Shelter | Substantive revision | 81 | 209 | 96.6 |
| Shambler | Substantive revision | 82 | 213 | 96.4 |
| Simulacrum | Substantive revision | 84 | 218 | 95.1 |
| Slay Living | Substantive revision | 84 | 219 | 96.1 |
| Sleet Storm | Substantive revision | 84 | 219 | 95.1 |
| Sympathy | Substantive revision | 89 | 242 | 93.1 |

## Source Preference Rule

Use *Mythic Spell Compendium* as the default Legendary Games version when an entry appears in both books. Retain *Mythic Magic: Core Spells* for historical comparison, Core-only material, and any case where a GM explicitly adopted the earlier wording.

## Important Caveat

Two-column PDF extraction can occasionally attach adjacent text to an entry. The audit therefore uses token-set similarity and flags low-overlap results rather than asserting that every detected difference is a rules rewrite. All flagged substantive entries are suitable for a future page-image/manual audit.
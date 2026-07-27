# Wiki Art Coverage Audit

Audit date: 2026-07-24

The campaign wiki was reviewed page by page for visual coverage. Every substantive page now has at least one image, while the reference and administrative sections remain intentionally text-only. Existing artwork was retained when it already gave a page its own visual identity. New page-specific illustrations were added where art was missing or an overview page reused another page's lead image.

All new artwork was generated in built-in image-generation mode and is mirrored under `docs/assets/` in this repository and `images/` in the wiki repository.

## New page-specific artwork

| Wiki page | Repository asset | Prompt concept |
|---|---|---|
| Arverdon Palace | `docs/assets/locations/arverdon-palace.png` | Fortified white-and-lavender Nysian royal palace at dawn |
| Blood of the Lernaean Hydra | `docs/assets/artifacts/blood-lernaean-hydra.png` | Exactly two sealed hydra-blood vials beside a poisoned arrowhead |
| Build Philosophy | `docs/assets/engines/build-philosophy.png` | Demidius balancing five strategic disciplines, with one sheathed sword |
| Charisma Dependency Map | `docs/assets/engines/charisma-dependency-map.png` | Central charisma jewel linked to six dependent systems |
| Charisma Engine | `docs/assets/engines/charisma-engine.png` | Dark-haired Demidius channeling magic, command, and fortune |
| Council of Seven | `docs/assets/factions/council-of-seven.png` | Seven pirate thrones with Declan's seat standing empty |
| Dame Mathilda | `docs/assets/characters/dame-mathilda.png` | Veteran paladin of Apollo bearing a single solar sword |
| Divine Abilities | `docs/assets/engines/divine-abilities.png` | Seven-Pipped Gem branching into divine interventions |
| Divine Progression Engine | `docs/assets/engines/divine-progression.png` | Staged ascent from godling blood to apotheosis |
| Fatal Flaw Catalog | `docs/assets/systems/fatal-flaw-catalog.png` | Lorekeeper's ledger filled with supernatural flaw sigils |
| Fatal Flaws | `docs/assets/systems/fatal-flaws.png` | Four heroes visibly carrying the costs of divine power |
| Fetu'mana | `docs/assets/characters/fetumana-v2.png` | Elderly kobold lorekeeper beneath a star-filled sky |
| Godling Bloodlines | `docs/assets/systems/godling-bloodlines.png` | Luminous divine family tree branching through mortals |
| Hellknight Order of the Godclaw | `docs/assets/factions/hellknight-order-godclaw.png` | Authoritarian Hellknights examining a divine-blooded child |
| Kaelen Thorne | `docs/assets/characters/kaelen-thorne-character-reference-panel-canonical.png` | User-selected canonical visual panel for the elven druid and worshiper of Hermes; embedded mechanical labels remain unverified |
| Paradox | `docs/assets/characters/paradox-character-reference-panel-v5.png` | User-selected definitive panel preserving his red-and-blue heterochromia, shadow-sailor identity, isolated starknife detail, and pink-purple-orange one-shoulder plaid cloak |
| Siopi | `docs/assets/characters/siopi-character-reference-panel-v1.png` | Full character panel preserving their lavender skin, white bun, spectacles, and craft tools |
| Kiss from a Rose | `docs/assets/locations/kiss-from-a-rose-hostel.png` | Humble simulacra of Demidius and Aristea welcoming travelers in a warm suburban hostel |
| Motu Leilani | `docs/assets/locations/motu-leilani.png` | Lush Heavenly Island and secluded coastal settlement |
| Odysseus | `docs/assets/characters/odysseus.png` | Hard-eyed tactical rogue studying a sea chart and sabotage plan |
| Pat | `docs/assets/characters/pat-eris-revelation.png` | Pat's transformation into Eris after Declan's fall |
| Pillars of Demidius | `docs/assets/engines/five-pillars.png` | Exactly five monumental pillars supporting Demidius's strategy |
| Probability Engine | `docs/assets/engines/probability-engine.png` | Central d20 surrounded by branching possible outcomes |
| Risk Management Engine | `docs/assets/engines/risk-management.png` | The party planning around dangerous choices and consequences |
| Sly | `docs/assets/characters/sly.png` | Identity-obscured memorial portrait for Declan's fallen lieutenant |
| Stormspire | `docs/assets/locations/stormspire.png` | Floating city arrested above the sea by controlled weather |
| Tagata Fetu | `docs/assets/factions/tagata-fetu-v3.png` | Kobold community consulting a kobold ancestor and constellation dragon during a star-lit juju ceremony |
| The Storm King | `docs/assets/characters/storm-king.png` | Storm giant ruler above his floating city |
| Artifacts and Divine Gifts | `docs/assets/artifacts/artifacts-reliquary-overview.png` | Campaign reliquary giving the index its own overview image |
| Gods and Divine Factions | `docs/assets/factions/divine-factions-schism.png` | Divine factions arrayed against one another after the Schism |
| Notable Figures | `docs/assets/people/notable-figures-gallery.png` | Portrait gallery linking heroes, rulers, allies, and enemies |
| Campaign Setting | `docs/assets/locations/zatera-setting-panorama.png` | Panoramic Zatera landscape in the era of The Arrival |

## Intentional exceptions

The sidebar's Reference section does not require art: Campaign Rules, Boons, Campaign Assumptions, Epic Spells, Option Index, Getting Started, and Editorial Standards. Administrative pages, repository architecture, processing logs, scope documents, and legacy alias pages are likewise exempt because they are navigation or maintenance surfaces rather than campaign articles.

## Verification standard

- Every substantive non-exempt Markdown page has at least one image reference.
- Every local image reference resolves to an existing file.
- Overview pages may include thumbnails also used by the detailed article, but each overview has its own unique lead image.
- New lead images are assigned to one wiki page each.

## Revised page artwork

| Wiki page | Repository asset | Revision |
|---|---|---|
| Battle for Tradegulf | `docs/assets/scenes/battle-for-tradegulf-arrival-v2.png` | Corrected the backward hand on the fallen foreground figure while preserving the scene composition |
| Old Nysian Power Vacuum | `docs/assets/scenes/old-nysia-vigilante-conflict.png` | Canonical party-versus-vigilantes battle scene; opposing faction and outcome remain provisional |

## Link and duplicate-page audit — 2026-07-23

A full integrity pass covered all 188 active wiki pages after cleanup.

- Repaired 32 broken, reversed, or misleading internal wiki-link occurrences.
- Verified that every internal page target and referenced heading anchor resolves.
- Verified that every local Markdown link resolves.
- Verified that every local image reference resolves.
- Removed four obsolete text-only pages that duplicated or superseded illustrated canonical pages:
  - `Campaign Rules.md`
  - `Magical Supremacy Engine.md`
  - `Probability Engine.md`
  - `The Five Pillars.md`
- Confirmed that the 12 remaining text-only files are intentional exceptions: reference pages, navigation or maintenance files, and legacy ship-name redirects.

No new image generation was required during this pass. Every substantive article already had unique art; the apparent gaps were obsolete duplicates or intentional exceptions.

## Old Nysian expansion pass - 2026-07-24

Five substantial lore pages were added from the campaign's current unresolved
story threads, and Rickard's newer character page received its first artwork.
Each illustration uses a different combination of personnel from the
Dawnrunner and Matcha Frappuccino while clearly labeling combinations not yet
confirmed in play as interpretive.

| Wiki page | Repository asset | Scene |
|---|---|---|
| Tradegulf | `docs/assets/locations/tradegulf-recovery-crossroads.png` | Amparo, Filius, Tulip, and a fully helmeted Rickard help refugees rebuild |
| Champions | `docs/assets/factions/champions-tradegulf-garrison.png` | Maarin, Aelwyn, and Bix observe the occupied Tradegulf garrison |
| The Crafter's Bow | `docs/assets/factions/crafters-bow-warehouse.png` | Demidius, Vornix, and Alley examine a seized merchant warehouse |
| Cobras | `docs/assets/factions/cobras-old-nysia.png` | Roy, Aristea Enontie, and Okeanikos contain Cobra lookouts |
| Grand Artifact Auction | `docs/assets/events/arverdon-grand-artifact-auction.png` | Demidius, Maarin, Roy, and Aristea inspect guarded auction displays |
| Demidius's Speech to the Crafter's Bow | `docs/assets/events/demidius-speech-to-crafters-bow.png` | Demidius appeals to tradespeople and vigilantes in damaged Tradegulf while Maarin stands beside him, visibly unimpressed |
| Battle Beneath the Champions' Garrison | `docs/assets/events/false-oros-revealed.png`, `docs/assets/events/champions-recognized.png` | The false Oros is exposed as a kobold mortal god of Fel; Demidius and Amparo receive divine recognition after the basement victory |
| Rickard | `docs/assets/characters/rickard-dawnrunner-paladin.png` | Lilly and Bix welcome the closed-helmeted paladin aboard the Dawnrunner |

## Canonical Glistria map - 2026-07-24

| Wiki page | Repository asset | Treatment |
|---|---|---|
| Glistria | `docs/assets/locations/glistria-map-canonical.png` | Lossless 6144 × 4608 source retained without generative alteration to preserve all labels and spatial data |

## Tenor and Misthold bloodline arc - 2026-07-25

| Wiki page | Repository asset | Scene |
|---|---|---|
| Tenor | `docs/assets/events/tenors-bloodline-rite.png` | Interpretive rear-view depiction of the unknown-looking gunslinger performing the bloodline rite |
| Misthold Bloodline Tournament | `docs/assets/events/misthold-bloodline-tournament.png` | Monumental Misthold colosseum filled with spectators; anonymous mortal-god sibling amid defeated competitors, with the golden-peach prize displayed separately |

## Misthold escape and Stormspire diversion - 2026-07-25

| Wiki page | Repository asset | Scene |
|---|---|---|
| Escape from Misthold | `docs/assets/events/escape-from-misthold.png` | Maarin commands a catastrophic tsunami while the distinct Matcha Frappuccino and Dawnrunner escape the destruction of Misthold's pursuing fleet |
| Stormspire Festival Diversion | `docs/assets/events/stormspire-festival-diversion.png` | Elven Aristea trades, Demidius and Roy perform, and Amparo and Tulip conduct a cookoff while Odysseus approaches the final Scepter component |
| Gideon's Sunshot | `docs/assets/events/gideons-sunshot.png` | Gideon releases one sun-charged arrow from the Dawnrunner toward Bluebeard's flagship while two ships of the line pursue |
| Dawnrunner | `docs/assets/dawnrunner/dawnrunner-flag-canonical.png` | Canonical black, silver, crimson-rose, winged-fleur-de-lis, and thorn-vine flag of Demidius and the Dawnrunner |
| Quest to Rescue Odysseus | `docs/assets/events/quest-to-rescue-odysseus.png` | Queen Lidda Beaumont commissions Demidius and Maarin over a map of Misthold marked with Odysseus's portrait |
| Rescue of the Champions and Blessed | `docs/assets/events/rescue-of-the-champions-and-blessed.png` | Demidius opens Misthold's cells with the Key of Daedalus while Roy diverts guards and the divine prisoners escape |

## Tulip cookbook and wedding - 2026-07-25

| Wiki page | Repository asset | Scene |
|---|---|---|
| Wedding of Tulip and Alley | `docs/assets/events/tulip-and-alley-wedding-ceremony.png` | Tulip and Alley exchange rings aboard the Matcha Frappuccino |
| Wedding of Tulip and Alley | `docs/assets/events/tulip-and-alley-wedding-reception.png` | The newlyweds cut a matcha wedding tart in the ship's relaxed galley |
| Tulip's Top 10 Recipes | `docs/assets/recipes/` | Ten compact cookbook illustrations, one for each recorded signature dish |

The Stormspire Festival Diversion asset was also replaced with a cleaned
identity-preserving edit that removes the foreground haze and double-texture.

## Grand Artifact Auction catalog - 2026-07-26

Twenty unique artifact portraits and twenty dedicated artifact pages were
added, plus an illustrated catalog hub. Unknown appearances are explicitly
treated as interpretive visualizations rather than mechanical canon.

| Wiki page | Repository asset |
|---|---|
| Heartthorn Ward | `docs/assets/artifacts/auction/heartthorn-ward.png` |
| The Shard of First Light | `docs/assets/artifacts/auction/shard-of-first-light.png` |
| Rivenheart Crown | `docs/assets/artifacts/auction/rivenheart-crown.png` |
| Shard of the Shield of Ajax | `docs/assets/artifacts/auction/shard-of-shield-of-ajax.png` |
| Tiara of Decay | `docs/assets/artifacts/auction/tiara-of-decay.png` |
| Fate's Sword | `docs/assets/artifacts/auction/fates-sword.png` |
| Echo Blade | `docs/assets/artifacts/auction/echo-blade.png` |
| Halfhead's Halfblade | `docs/assets/artifacts/auction/halfheads-halfblade.png` |
| Horn of Resnik | `docs/assets/artifacts/auction/horn-of-resnik.png` |
| Grimoire of Honesty | `docs/assets/artifacts/auction/grimoire-of-honesty.png` |
| Aethereal Crown | `docs/assets/artifacts/auction/aethereal-crown.png` |
| Ichor of Virility | `docs/assets/artifacts/auction/ichor-of-virility.png` |
| Rod of Mending | `docs/assets/artifacts/auction/rod-of-mending.png` |
| Arch of Persecution | `docs/assets/artifacts/auction/arch-of-persecution.png` |
| Bawery Slab | `docs/assets/artifacts/auction/bawery-slab.png` |
| Grimoire of Doom | `docs/assets/artifacts/auction/grimoire-of-doom.png` |
| Gauntlet of Sentience | `docs/assets/artifacts/auction/gauntlet-of-sentience.png` |
| Ichor of Chaos | `docs/assets/artifacts/auction/ichor-of-chaos.png` |
| Obsidian Bracelet | `docs/assets/artifacts/auction/obsidian-bracelet.png` |
| Lifeblood Tome | `docs/assets/artifacts/auction/lifeblood-tome.png` |

Fate's Sword records two sale lots on one page because the known half and the
presumed-lost half of the former Scissors of the Fates were auctioned
separately.

## Dawnrunner interior expansion - 2026-07-26

| Interior | Repository assets |
|---|---|
| Captain's command suite | `docs/assets/dawnrunner/interiors/captains-quarters/` |
| Arcane workshop | `docs/assets/dawnrunner/interiors/arcane-workshop/dawnrunner-arcane-workshop.png` |
| Cargo hold | `docs/assets/dawnrunner/interiors/cargo-hold/` |
| General crew quarters | `docs/assets/dawnrunner/interiors/crew-quarters/dawnrunner-crew-quarters-canonical.jpg` |
| Officer and guest quarters | `docs/assets/dawnrunner/interiors/officer-guest-quarters/dawnrunner-officer-guest-quarters-canonical.jpg` |

The reader-facing descriptions and visual-authority notes are consolidated in
`docs/dawnrunner-interiors.md`. The user-approved crew and officer/guest views
supplement their matching Canonical Reference Packs rather than silently
superseding coordinated multi-view production packs.

The Battle Beneath the Champions' Garrison scene at
`docs/assets/events/false-oros-revealed.png` and its corresponding wiki asset
were corrected to remove Aristea Enontië's duplicate tail while preserving
the intended visible tail.

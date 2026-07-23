# Wiki Art Coverage Audit

Audit date: 2026-07-23

The campaign wiki was reviewed page by page for visual coverage. Every substantive page now has at least one image, while the reference and administrative sections remain intentionally text-only. Existing artwork was retained when it already gave a page its own visual identity. Thirty new page-specific illustrations were added where art was missing or an overview page reused another page's lead image.

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
| Kaelen Thorne | `docs/assets/characters/kaelen-thorne.png` | Elven druid listening to the forest beside one beaver |
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

The sidebar's Reference section does not require art: Campaign Rules, Boons, Campaign Assumptions, Mythic Spell Research, Epic Spells, Option Index, Getting Started, and Editorial Standards. Administrative pages, repository architecture, processing logs, scope documents, and legacy alias pages are likewise exempt because they are navigation or maintenance surfaces rather than campaign articles.

## Verification standard

- Every substantive non-exempt Markdown page has at least one image reference.
- Every local image reference resolves to an existing file.
- Overview pages may include thumbnails also used by the detailed article, but each overview has its own unique lead image.
- New lead images are assigned to one wiki page each.

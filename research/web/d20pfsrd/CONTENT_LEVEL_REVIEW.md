# d20PFSRD: Content-Level Review

## Scope and method

This pass built a resumable page-level discovery index of `https://www.d20pfsrd.com/`. The index combines the site's working sitemap entries with recursive internal-link discovery because most numbered page sitemaps advertised by the sitemap index returned HTTP 404. The local database preserves page text, headings, canonical URLs, Section 15 notices, attribution fields, and content hashes. Git retains only metadata, citations, and original campaign analysis.

This is a discovery corpus, not a substitute for a primary source. d20PFSRD combines Paizo rules, third-party rules, and community material. It also changes some Product Identity names, so the attributed book must be checked before recording an exact rule name or promoting a mechanic into the Codex.

## Corpus result

- 52,387 discovered URLs indexed
- 49,433 distinct canonical URLs
- 18,891,957 words retained in the local searchable corpus
- 45,561 HTTP 200 responses, including 44,974 pages with successfully extracted article content
- 20,544 pages classified as Paizo, 18,976 as third party, 1,360 as community, and 11,507 left unclassified pending contextual review
- 3,457 temporary failures remain queued for a future refresh after a conservative retry recovered additional pages

## Highest-value findings

### 1. Wandering weather is the verified mobile weather spell

*Wandering weather* works as *control weather* but can remain centered on a moving caster. That moving-center clause is the important shipboard distinction: ordinary *control winds* does not travel with a vessel under the site's naval-combat guidance. The spell is now verified against the local *Ultimate Wilderness* PDF as well as the web entry.

**Source:** *Ultimate Wilderness*, PDF p. 238 / printed p. 237; [d20PFSRD spell entry](https://www.d20pfsrd.com/magic/all-spells/w/wandering-weather/); [naval spell guidance](https://www.d20pfsrd.com/gamemastering/other-rules/ship-combat/spell-effects-in-naval-combat/).

**Disposition:** S for Demidius's next-spell planning. The spell supplies mobile weather control, but the campaign still needs a ruling before translating favorable wind into a numerical Dawnrunner speed increase.

### 2. Billow the sail is the cleanest direct speed mechanic

*Billow the sail* targets one ship, lasts 1 hour per caster level, creates a localized favorable wind, and explicitly increases a sailing ship's speed by 25%. This is much cleaner than inferring a speed value from a general weather spell.

**Source:** *Book of Lost Spells* (Frog God Games), PDF p. 26 / printed p. 25; [d20PFSRD spell entry](https://www.d20pfsrd.com/magic/3rd-party-spells/frog-god-games/billow-the-sail/).

**Disposition:** S if the GM approves third-party material. Confirm stacking and multiplication order with the Dawnrunner's existing Magic Swiftness and Profession (sailor) rules.

### 3. Calculated luck can cover repeated caster-level checks

*Calculated luck* can produce a +2 luck bonus on caster-level checks for several rounds. At least one desired result appears on 3d8 about 33% of the time. Under campaign rules CR-01 and CR-02, the qualifying luck bonus should become +4. It can cover repeated checks, unlike spending Seven-Pipped Gem's immediate-action benefit on one decisive roll, but the spell is random and imposes an assigned energy vulnerability.

**Source:** *Pathfinder Campaign Setting: Occult Mysteries*, PDF pp. 52-53 / printed pp. 50-51; [d20PFSRD spell entry](https://www.d20pfsrd.com/magic/all-spells/c/calculated-luck/).

**Disposition:** A, conditional preparation candidate for planned dispels, spell-resistance checks, or similar caster-level contests.

### 4. Scrying familiarity fits Alley's operational role

The talent improves saves against scrying through a roll-twice mechanic, permits Perception checks to notice magical sensors, supports caster-level checks against spell resistance for scrying effects, and can allow Stealth against a noticed sensor. It fits Alley's spymaster duties, subject to her current class-feature access and talent budget.

**Source:** *Spymaster's Handbook*, PDF p. 25 / printed p. 23; [d20PFSRD talent entry](https://www.d20pfsrd.com/classes/core-classes/rogue/rogue-talents/paizo-rogue-talents/scrying-familiarity-ex/).

**Disposition:** A for Alley's next legal rogue-talent review.

### 5. Fill the sails is a useful third-party benchmark, not a speed ruling

*Fill the sails* creates a localized 50-mph wind that can propel sails, but its text does not provide a numerical ship-speed conversion. It therefore supports a favorable-wind ruling but cannot be treated as a 50-mph ship speed.

**Source:** *Dead Man's Chest* (Necromancer Games), PDF pp. 112-113; [d20PFSRD spell entry](https://www.d20pfsrd.com/magic/3rd-party-spells/necromancer-games/fill-the-sails).

**Disposition:** B, third-party fallback if *billow the sail* is unavailable.

### 6. The Storm Pilot page demonstrates the naming hazard

The d20PFSRD entry called Storm Pilot corresponds to the Paizo trait *Abendego Pilot*. The trait reduces some personal wind penalties and improves Profession (sailor); it does not grant a direct ship-speed increase. This is a concrete example of why d20PFSRD names and setting references must be verified against the primary book.

**Source:** *Blood of the Elements*; [d20PFSRD trait entry](https://www.d20pfsrd.com/traits/regional-traits/storm-pilot/).

## Authority and reuse boundaries

- Classify every page as Paizo, third party, community/unknown, or mixed before using it.
- Preserve the page's Section 15 attribution and publisher metadata.
- Verify promoted mechanics against the attributed local book whenever available.
- Treat campaign rules and Zatera canon as authoritative over imported setting assumptions.
- The site's [legal declaration](https://www.d20pfsrd.com/extras/legal/) covers Open Game Content while excluding Product Identity such as artwork, logos, names, and trade dress. This repository therefore stores the full research text only in ignored local storage and commits metadata plus original analysis.

## Coverage limits

The site's sitemap infrastructure is partly stale: 22 declared sitemap documents failed during this pass. Recursive discovery recovered a much larger corpus, but an unlinked orphan page may still be absent. Server errors are retained in the catalog rather than silently counted as successful extractions.

The generated campaign shortlist is deliberately broad. A shortlist row means “worth contextual review,” not “legal, compatible, or recommended.”

## Files produced

- `research/web/d20pfsrd/PAGE_CATALOG.csv`
- `database/d20pfsrd_campaign_shortlist.csv`
- `database/source_registry_d20pfsrd.json`
- `scripts/extract_d20pfsrd_site.py`
- `scripts/search_d20pfsrd_index.py`
- `scripts/export_d20pfsrd_research.py`
- Local ignored database: `tmp/web/d20pfsrd/pages.sqlite3`

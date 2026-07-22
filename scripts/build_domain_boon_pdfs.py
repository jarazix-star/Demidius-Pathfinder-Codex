from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, PageBreak, Table, TableStyle,
    KeepTogether, HRFlowable
)


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf"
OUT.mkdir(parents=True, exist_ok=True)


SOURCES = {
    "Chaldira": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Chaldira",
    "Nivi Rhombodazzle": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Nivi+Rhombodazzle",
    "Cayden Cailean": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Cayden+Cailean",
    "Desna": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Desna",
    "Milani": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Milani",
    "Besmara": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Besmara",
    "Arshea": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Arshea",
    "Otolmens": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Otolmens",
    "Abraxas": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Abraxas",
    "Nethys": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Nethys",
    "Haagenti": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Haagenti",
    "Hanspur": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Hanspur",
    "Shyka": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Shyka",
    "Dagon": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Dagon",
    "Socothbenoth": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Socothbenoth",
    "Bharnarol": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Bharnarol",
    "Ylimancha": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Ylimancha",
    "Lymnieris": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Lymnieris",
    "Brigh": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Brigh",
    "Torag": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Torag",
    "Phlegyas": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Phlegyas",
    "Hei Feng": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Hei+Feng",
    "Xhamen-Dor": "https://www.aonprd.com/DeityDisplay.aspx?ItemName=Xhamen-Dor",
}


DEMIDIUS = {
    "title": "Demidius Thorne",
    "subtitle": "Domain-Constrained Hermes Obedience Guide",
    "tagline": "Luck first. Freedom second. Every boon must belong to Hermes.",
    "palette": (colors.HexColor("#17151A"), colors.HexColor("#8E2238"), colors.HexColor("#D6B566"), colors.HexColor("#F6F0E5")),
    "domains": "Trickery, Travel, Community, Liberation, Luck",
    "premise": (
        "Demidius is a level-17 Charisma-based Oracle, probability controller, party leader, "
        "buffer, dispeller, and Blessed of Hermes. This ranking treats Hermes's campaign domains "
        "as a hard eligibility rule. Raw power that does not fit those domains is excluded."
    ),
    "existing": [
        ("S", "Fortune's Child", "Acquired - printed tier 2", "Luck", "Chaldira", "Sentinel 2",
         "Increases every luck bonus Demidius receives by 1. It is a foundation of the current build and stacks with Fate's Favored under the campaign ruling."),
        ("S+", "Seven-Pipped Gem", "Acquired - printed tier 3", "Luck", "Nivi Rhombodazzle", "Exalted 3",
         "Immediate-action post-roll luck. At level 17 the campaign engine yields +10 on an ordinary d20 or +19 on Gambling and Sleight of Hand, with Charisma-modifier uses per day."),
    ],
    "tiers": {
        1: [
            ("A+", "Lucky Blessing", "Chaldira", "Exalted 1", "Luck, Community", "Divine favor 3/day, blessing of luck and resolve 2/day, or prayer 1/day. Directly feeds the luck engine and can support the whole party."),
            ("A", "Gambler's Essentials", "Nivi Rhombodazzle", "Evangelist 1", "Luck, Travel", "True strike 3/day, augury 2/day, or haste 1/day. Flexible, thematic, and useful in both preparation and combat."),
            ("A-", "Lucky Miss", "Chaldira", "Sentinel 1", "Luck, Trickery, Travel", "Blurred movement 3/day, self-only blur 2/day, or blink 1/day. A strong lucky-escape defense with excellent thematic fit."),
            ("B+", "Liberation", "Cayden Cailean", "Evangelist 1", "Liberation, Trickery", "Liberating command 3/day, knock 2/day, or dispel magic 1/day. Useful escape, access, and magical problem-solving."),
            ("B+", "Traveler's Tricks", "Desna", "Evangelist 1", "Travel", "Longstrider 3/day, darkvision 2/day, or phantom steed 1/day. Reliable travel utility, though less decisive in a level-17 fight."),
        ],
        2: [
            ("S", "Fortune's Child - ACQUIRED", "Chaldira", "Sentinel 2", "Luck", "Increases every luck bonus Demidius receives by 1. The best personal Luck-domain choice and already part of the character."),
            ("A+", "Fortunate Spells", "Chaldira", "Exalted 2", "Luck, Community", "Increases luck bonuses from Demidius's spells and spell-like abilities by 1. It stacks with Fortune's Child and makes the party's luck better."),
            ("A", "Gambler's Egress", "Nivi Rhombodazzle", "Evangelist 2", "Travel, Liberation, Luck", "Litany of escape 3/day as a swift-action spell-like ability, targeting Demidius or an ally. Excellent rescue action economy."),
            ("A-", "Alleyport", "Milani", "Exalted 2", "Travel, Liberation", "Once/day swift-action dimension door, but departure and arrival must be in tight spaces. Powerful and terrain-dependent."),
            ("B+", "Treacherous Mirage", "Besmara", "Exalted 2", "Trickery", "Once/day false vision or mirage arcana, changeable with concentration and lasting until replaced or dismissed. Excellent strategic deception."),
        ],
        3: [
            ("S+", "Seven-Pipped Gem - ACQUIRED", "Nivi Rhombodazzle", "Exalted 3", "Luck", "The defining post-roll certainty tool. It is the strongest Hermes-domain capstone for this build and is already acquired."),
            ("A+", "Blast of Motes", "Desna", "Exalted 3", "Luck, Community", "A healing channel grants allies a 10% miss-chance reduction and turns damage-die results of 1 into 2 for up to 6 rounds. Grants a healing-only channel 1/day if needed."),
            ("A+", "Invoke Uprising", "Milani", "Evangelist 3", "Liberation, Community", "Detects nearby charm, compulsion, and possession, then grants a new save 3/day as a swift action with a Charisma-based sacred bonus."),
            ("A", "Rally Crew", "Besmara", "Exalted 3", "Community, Travel", "Once/day, allies within 60 feet gain +10-foot speed and heroism for 1 hour/Hit Die and ignore water or weather penalties on benefited rolls."),
            ("A-", "Liberation", "Arshea", "Mystery Cultist 3", "Liberation", "Freedom 1/day. A direct answer to imprisonment, grapples, paralysis, petrification, and other restraints."),
        ],
    },
    "primary": "Lucky Blessing / Fortune's Child / Seven-Pipped Gem",
    "additive": "Lucky Blessing / Fortunate Spells / Blast of Motes",
    "decision": (
        "If the acquired gifts occupy obedience slots, the primary package is complete except for tier 1. "
        "If they remain separate divine gifts, use the additive package. Swap Blast of Motes for Invoke "
        "Uprising when hostile mind control is the campaign's greatest threat."
    ),
    "exclusions": [
        "Zura's Vampire Queen's Mystique is excluded: a raw Charisma increase does not fit any recorded Hermes domain.",
        "Desna's Starlit Caster is outside the top five: spell penetration and starlight are only an indirect Travel fit.",
        "Do not purchase Fortune's Child or Seven-Pipped Gem a second time if existing gifts are separate from the obedience slots.",
    ],
    "questions": [
        "Do Fortune's Child and Seven-Pipped Gem occupy tiers 2 and 3, or are they separate Hermes gifts?",
        "Does the campaign's category mixing remove source-patron moral baggage while retaining printed mechanics?",
        "Does the normal 12/16/20 Hit Die boon schedule apply, or is access accelerated?",
    ],
}


ARISTEA = {
    "title": "Aristea of the Shifting Tides",
    "subtitle": "Domain-Constrained Nereus Obedience Guide",
    "tagline": "Ancient knowledge. Fluid form. The strength of the sea.",
    "palette": (colors.HexColor("#082B36"), colors.HexColor("#177D88"), colors.HexColor("#B7E3E5"), colors.HexColor("#F2F8F7")),
    "domains": "Knowledge, Shapeshifting, Sea/Water",
    "premise": (
        "Aristea is a level-17 Intelligence-based Wizard/Arcane Trickster, water-and-cold specialist, "
        "primary crafter, merchant-mage, and accomplished shapeshifter. Knowledge and Shapeshifting "
        "are player-confirmed Nereus themes; Sea/Water follows the campaign record and Nereus's identity."
    ),
    "existing": [
        ("S", "Animal Lord of the Tides", "Acquired campaign template - not a published tier boon", "Sea/Water, Shapeshifting", "Nereus", "Campaign Boons",
         "Sacred narwhal form, underwater operation, senses, and transformation. This should shape the obedience choices but should not consume a tier unless the GM merges the systems."),
    ],
    "tiers": {
        1: [
            ("A+", "Creator", "Brigh", "Exalted 1", "Knowledge, Crafting", "Crafter's fortune 3/day, make whole 2/day, or minor creation 1/day. The best tier-1 package for Aristea's primary-crafter role."),
            ("A", "Discerning Mind", "Otolmens", "Monitor 1", "Knowledge", "Identify 3/day, investigative mind 2/day, or blink 1/day. The first two are strong knowledge tools; blink is useful defense."),
            ("A-", "Secret Lore", "Abraxas", "Demoniac/Exalted 1", "Knowledge", "Identify 3/day, augury 2/day, or illusory script 1/day. Strong divination access with an ancient-secret flavor."),
            ("A-", "Magical Essences", "Nethys", "Exalted 1", "Knowledge", "Magic aura 3/day, misdirection 2/day, or arcane sight 1/day. Arcane sight is the strongest direct magical-information option."),
            ("B+", "Truth in the Flesh", "Haagenti", "Demoniac/Exalted 1", "Shapeshifting", "Enlarge person 3/day, alter self 2/day, or beast shape I 1/day. Perfect fit, but partly redundant with Aristea's spellbook and Animal Lord form."),
            ("B+", "River Guide", "Hanspur", "Exalted 1", "Sea/Water", "Obscuring mist 3/day, haunting mists 2/day, or aqueous orb 1/day. Useful water control without prepared slots."),
            ("B+", "Creator's Whispers", "Phlegyas", "Monitor 1", "Knowledge, Crafting", "Crafter's fortune 3/day, object reading 2/day, or detect anxieties 1/day. A good blend of crafting and investigative knowledge."),
            ("B+", "River Sage", "Hanspur", "Evangelist 1", "Sea/Water", "Hydraulic push 3/day, river whip 2/day, or hydraulic torrent 1/day. Reusable thematic battlefield control."),
            ("B", "Enslave the Sea", "Dagon", "Evangelist 1", "Sea/Water", "Hydraulic push 3/day, slipstream 2/day, or water breathing 1/day. Useful at sea, but several effects overlap existing capabilities."),
            ("B", "Fearsome Boast", "Besmara", "Sentinel 1", "Sea/Water", "Monkey fish 3/day, slipstream 2/day, or water breathing 1/day. Practical maritime utility with substantial redundancy."),
        ],
        2: [
            ("S", "Rite of Passage", "Lymnieris", "Celestial Mystery Cultist 2", "Shapeshifting", "Greater polymorph 1/day on a willing creature, permanent until Aristea or the target dismisses it or Aristea uses the boon again. Perfect Nereus fit; only one active transformation is supported."),
            ("S", "Poisoned Mysticism", "Abraxas", "Evangelist 2", "Knowledge", "Adds Intelligence to concentration and caster-level checks for spell resistance and dispelling; printed poison benefits remain. Excellent for Intelligence 34, but adapt the toxic flavor as secret sea lore with GM approval."),
            ("A+", "Borrowed Memories", "Shyka", "Feysworn 2", "Knowledge", "Immediate, best-result legend lore 1/day regardless of the subject's location. The cleanest pure Knowledge-domain boon."),
            ("A+", "Aspect of Ishiar", "Dagon", "Evangelist 2", "Sea/Water, Shapeshifting", "Become seawater for 10 minutes/Hit Die/day: DR 10/slashing, +10-foot reach, infiltration through cracks, Stealth, water subtype, amphibious breathing, and swim 60 feet."),
            ("A", "Transformation Mastery", "Xhamen-Dor", "Sentinel 2", "Shapeshifting", "+2 DC to polymorph effects, doubled self-polymorph durations, shapechanger subtype, and +2 profane saves while transformed. The Charisma damage rider is minor for Aristea."),
            ("A", "Arcane Eye", "Nethys", "Evangelist 2", "Knowledge", "Arcane eye 3/day enhanced with arcane sight. Excellent remote reconnaissance and magical analysis."),
            ("A-", "Doom of Sailors", "Besmara", "Sentinel 2", "Sea/Water", "Control water or control winds 1/day. Naval-scale control with direct Nereus fit, though Aristea may already prepare similar spells."),
            ("A-", "Improve Item", "Bharnarol", "Mystery Cultist 2", "Knowledge, Crafting", "Three times/day as a swift action, apply Empower, Enlarge, or Extend to a consumed or charged magic item used that round."),
            ("A-", "Blessing of Sea and Storm", "Hei Feng", "Exalted 2", "Sea/Water, Crafting", "Turn rainwater or seawater into a temporary potion of a prepared qualifying spell of 4th level or lower. Uses/day equal Charisma modifier, minimum one."),
            ("B+", "River Traveler", "Hanspur", "Exalted 2", "Sea/Water", "Grant self and nearby allies swim 60 feet as a free action for Hit Dice rounds, plus +2 saves against water-descriptor spells."),
        ],
        3: [
            ("S+", "Sacred Crafting", "Torag", "Evangelist 3", "Knowledge, Crafting", "Reduce the calculated base cost of every crafted magic item by 10%; the boon explicitly reduces crafting time and final price as well. Also grants fabricate 1/day."),
            ("S+", "Rally Crew", "Besmara", "Exalted 3", "Sea/Water, Weather", "Once/day, every ally within 60 feet gains +10 feet of speed and heroism for 1 hour/Hit Die. Benefited attack rolls, saves, and skill checks ignore water- or weather-based penalties. At level 17 it lasts 17 hours and can cover a gathered crew."),
            ("S+", "Adaptive Flesh and Twisting Steel", "Haagenti", "Sentinel 3", "Shapeshifting", "Shapechange 1/day, expanded form options, and equipment alters so it continues functioning in polymorphed forms. The strongest combat capstone for Aristea."),
            ("S", "Truth in the Flesh", "Socothbenoth", "Demoniac/Exalted 3", "Shapeshifting", "Shapechange 1/day. Mechanically clean and extremely flexible, but without the equipment-preservation rider."),
            ("A+", "Transmogrify", "Bharnarol", "Mystery Cultist 3", "Shapeshifting, Knowledge", "Extended polymorph any object 1/day. Exceptional transformation, infiltration, utility, and problem-solving."),
            ("A+", "Inspired Crafting", "Brigh", "Exalted 3", "Knowledge, Crafting", "While adventuring, 4 hours of crafting produces 4 hours of progress instead of only 2. Also grants fabricate 1/day. Excellent aboard a traveling ship."),
            ("A", "Body of Water", "Ylimancha", "Mystery Cultist 3", "Sea/Water, Shapeshifting", "Permanent fluid body, immunity to critical hits and sneak attacks, and movement through extremely small spaces. Confirm polymorph and Animal Lord interactions."),
            ("A", "Pure Magic Aura", "Nethys", "Exalted 3", "Knowledge", "For up to 6 rounds/day, Aristea and allies within 20 feet gain +1d4 caster levels, affecting spell qualities and spell-resistance checks."),
            ("A-", "River's Embodiment", "Hanspur", "Evangelist 3", "Sea/Water, Shapeshifting", "Huge water elemental form 1/day for 1 minute/Hit Die. A clean Nereus expression, but less flexible than shapechange."),
            ("A-", "Revise Reality", "Otolmens", "Monitor 3", "Knowledge", "Limited wish 1/day. Broad problem-solving from a knowledge-and-calculation source, but less tied to Aristea's signature roles."),
            ("B+", "Horror of the Deep", "Dagon", "Sentinel 3", "Sea/Water, Shapeshifting", "Deep-sea hybrid form for 1 minute/Hit Die/day with pressure immunity, water breathing, doubled swim speed, bite, and grappling tentacle."),
        ],
    },
    "primary": "Creator / Rite of Passage / Sacred Crafting",
    "additive": "Discerning Mind / Poisoned Mysticism / Adaptive Flesh and Twisting Steel",
    "decision": (
        "The primary package is the strongest campaign-economy line for Aristea as primary crafter: Knowledge, "
        "Shapeshifting, then Knowledge/Crafting. Rally Crew replaces Sacred Crafting for the strongest fleet-command line, "
        "while the alternative is the strongest personal combat-caster line. Rally Crew is a direct Sea/Water and Weather fit, "
        "but its heroism bonuses do not stack with other morale bonuses of the same type."
    ),
    "exclusions": [
        "Tanagaar's Hunter's Edge is excluded: sneak attack does not fit Knowledge, Shapeshifting, or Sea/Water.",
        "Andirifkhu's Subtle Razor is excluded for the same reason, despite its excellent damage synergy.",
        "Sneak-attack boons remain excluded even though they would increase ray damage; they do not fit Nereus's domains.",
    ],
    "questions": [
        "Will the GM formally approve Knowledge, Shapeshifting, and Sea/Water as Nereus's custom domain list?",
        "Can Poisoned Mysticism be expressed as secret oceanic lore while retaining all printed mechanics?",
        "How do Body of Water and equipment-adapting polymorph effects interact with Animal Lord of the Tides?",
        "Can Aristea cast normally in the chosen permanent greater polymorph form, and can enemies dispel it?",
        "Does Sacred Crafting's 10% reduction apply after every other campaign crafting modifier, as its printed sequencing states?",
        "Does the normal 12/16/20 Hit Die boon schedule apply, or is access accelerated?",
    ],
}


def styles_for(palette):
    dark, accent, pale, paper = palette
    base = getSampleStyleSheet()
    return {
        "title": ParagraphStyle("title", parent=base["Title"], fontName="Helvetica-Bold", fontSize=27, leading=31, textColor=paper, alignment=TA_LEFT, spaceAfter=10),
        "subtitle": ParagraphStyle("subtitle", parent=base["Normal"], fontName="Helvetica", fontSize=13, leading=17, textColor=pale, spaceAfter=18),
        "tag": ParagraphStyle("tag", parent=base["Normal"], fontName="Helvetica-Oblique", fontSize=10.5, leading=15, textColor=paper, spaceAfter=8),
        "h1": ParagraphStyle("h1", parent=base["Heading1"], fontName="Helvetica-Bold", fontSize=18, leading=22, textColor=dark, spaceBefore=4, spaceAfter=8),
        "h2": ParagraphStyle("h2", parent=base["Heading2"], fontName="Helvetica-Bold", fontSize=14, leading=18, textColor=accent, spaceBefore=5, spaceAfter=6),
        "body": ParagraphStyle("body", parent=base["BodyText"], fontName="Helvetica", fontSize=9.3, leading=13.2, textColor=colors.HexColor("#20242A"), spaceAfter=7),
        "small": ParagraphStyle("small", parent=base["BodyText"], fontName="Helvetica", fontSize=7.5, leading=10.2, textColor=colors.HexColor("#414852")),
        "cardtitle": ParagraphStyle("cardtitle", parent=base["Heading3"], fontName="Helvetica-Bold", fontSize=10.4, leading=13, textColor=dark, spaceAfter=2),
        "cardbody": ParagraphStyle("cardbody", parent=base["BodyText"], fontName="Helvetica", fontSize=8.5, leading=11.6, textColor=colors.HexColor("#252930")),
        "white": ParagraphStyle("white", parent=base["BodyText"], fontName="Helvetica-Bold", fontSize=9, leading=12, textColor=paper),
        "source": ParagraphStyle("source", parent=base["BodyText"], fontName="Helvetica", fontSize=7, leading=9.2, textColor=colors.HexColor("#46515C")),
    }


def footer(canvas, doc, cfg):
    dark, accent, pale, paper = cfg["palette"]
    canvas.saveState()
    canvas.setFillColor(dark)
    canvas.rect(0, 0, letter[0], 0.33 * inch, fill=1, stroke=0)
    canvas.setFillColor(pale)
    canvas.setFont("Helvetica", 7.5)
    canvas.drawString(0.6 * inch, 0.13 * inch, cfg["subtitle"])
    canvas.drawRightString(letter[0] - 0.6 * inch, 0.13 * inch, f"Page {doc.page}")
    canvas.restoreState()


def rank_card(rank, item, styles, cfg, status=None):
    grade, name, deity, track, domain, text = item
    dark, accent, pale, paper = cfg["palette"]
    link = SOURCES.get(deity, "")
    source_name = f'<link href="{link}" color="#{accent.hexval()[2:]}">{deity}</link>' if link else deity
    badge = Table([[Paragraph(f"<b>{rank}</b>", styles["white"]), Paragraph(f"<b>{grade}</b>", styles["white"])]], colWidths=[0.38*inch, 0.46*inch])
    badge.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (0,0), accent),
        ("BACKGROUND", (1,0), (1,0), dark),
        ("ALIGN", (0,0), (-1,-1), "CENTER"),
        ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
        ("BOX", (0,0), (-1,-1), 0.5, accent),
        ("LEFTPADDING", (0,0), (-1,-1), 4),
        ("RIGHTPADDING", (0,0), (-1,-1), 4),
        ("TOPPADDING", (0,0), (-1,-1), 4),
        ("BOTTOMPADDING", (0,0), (-1,-1), 4),
    ]))
    title = Paragraph(f"{name}<br/><font size='7.6'>{source_name} - {track} | Fit: {domain}</font>", styles["cardtitle"])
    desc = Paragraph(text, styles["cardbody"])
    table = Table([[badge, title], ["", desc]], colWidths=[0.92*inch, 5.75*inch])
    table.setStyle(TableStyle([
        ("SPAN", (1,1), (1,1)),
        ("VALIGN", (0,0), (-1,-1), "TOP"),
        ("BACKGROUND", (0,0), (-1,-1), colors.HexColor("#F7F8FA")),
        ("BOX", (0,0), (-1,-1), 0.7, pale),
        ("LINEBEFORE", (0,0), (0,-1), 3, accent),
        ("LEFTPADDING", (0,0), (-1,-1), 7),
        ("RIGHTPADDING", (0,0), (-1,-1), 7),
        ("TOPPADDING", (0,0), (-1,-1), 6),
        ("BOTTOMPADDING", (0,0), (-1,-1), 6),
    ]))
    return KeepTogether([table, Spacer(1, 7)])


def existing_card(item, styles, cfg):
    grade, name, status, domain, deity, track, text = item
    return rank_card("OWN", (grade, name, deity, track, domain, f"<b>{status}.</b> {text}"), styles, cfg)


def build_pdf(cfg, filename):
    styles = styles_for(cfg["palette"])
    dark, accent, pale, paper = cfg["palette"]
    path = OUT / filename
    doc = SimpleDocTemplate(
        str(path), pagesize=letter,
        rightMargin=0.55*inch, leftMargin=0.55*inch,
        topMargin=0.55*inch, bottomMargin=0.52*inch,
        title=cfg["subtitle"], author="Demidius Pathfinder Codex"
    )
    story = []

    cover = Table([[Paragraph(cfg["title"], styles["title"])], [Paragraph(cfg["subtitle"], styles["subtitle"])], [Paragraph(cfg["tagline"], styles["tag"])]], colWidths=[7.0*inch], rowHeights=[1.25*inch, 0.58*inch, 0.82*inch])
    cover.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,-1), dark),
        ("LINEBELOW", (0,0), (-1,0), 5, accent),
        ("LEFTPADDING", (0,0), (-1,-1), 24),
        ("RIGHTPADDING", (0,0), (-1,-1), 24),
        ("TOPPADDING", (0,0), (-1,-1), 14),
        ("BOTTOMPADDING", (0,0), (-1,-1), 10),
        ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
    ]))
    story += [Spacer(1, 0.45*inch), cover, Spacer(1, 0.32*inch)]
    story.append(Paragraph("Decision summary", styles["h1"]))
    summary = Table([
        [Paragraph("Best package", styles["white"]), Paragraph(cfg["primary"], styles["white"])],
        [Paragraph("Alternative", styles["white"]), Paragraph(cfg["additive"], styles["white"])],
        [Paragraph("Eligible domains", styles["white"]), Paragraph(cfg["domains"], styles["white"])],
    ], colWidths=[1.35*inch, 5.65*inch])
    summary.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (0,-1), accent),
        ("BACKGROUND", (1,0), (1,-1), dark),
        ("GRID", (0,0), (-1,-1), 0.4, pale),
        ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
        ("LEFTPADDING", (0,0), (-1,-1), 9),
        ("RIGHTPADDING", (0,0), (-1,-1), 9),
        ("TOPPADDING", (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
    ]))
    story += [summary, Spacer(1, 12), Paragraph(cfg["premise"], styles["body"]), Paragraph(cfg["decision"], styles["body"])]
    story.append(Spacer(1, 0.45*inch))
    story.append(Paragraph("Prepared 22 July 2026 | Pathfinder 1e | Campaign-specific analysis", styles["small"]))
    story.append(PageBreak())

    story.append(Paragraph("Rules frame", styles["h1"]))
    story.append(Paragraph(
        "The campaign allows a custom obedience assembled from published boons: tier 1 must stay tier 1, tier 2 must stay tier 2, and tier 3 must stay tier 3, while source deity, category, and prestige path may be mixed. This guide adds the required domain-fit filter.", styles["body"]))
    story.append(Paragraph(f"<b>Admissible domains:</b> {cfg['domains']}", styles["body"]))
    story.append(Paragraph(
        "The printed action, uses, duration, target restrictions, bonus type, descriptor, and other mechanics remain intact unless the GM approves a change. The normal obedience feats generally grant boons at 12, 16, and 20 Hit Dice; prestige classes can accelerate access.", styles["body"]))
    if cfg is ARISTEA:
        story.append(Paragraph(
            "Nereus does not yet have a formal post-schism domain line in the campaign wiki. Knowledge and Shapeshifting are player-confirmed themes, and Sea/Water follows the campaign record and his identity as the Old Man of the Sea. Final GM confirmation is still required.", styles["body"]))
    story += [Spacer(1, 5), Paragraph("Rating scale", styles["h2"])]
    story.append(Paragraph("<b>S:</b> defining option. <b>A:</b> excellent. <b>B:</b> useful but narrower, redundant, or less efficient. Plus and minus signs distinguish choices inside a grade.", styles["body"]))
    story.append(HRFlowable(width="100%", thickness=1.2, color=accent, spaceBefore=6, spaceAfter=10))
    story.append(Paragraph("Already acquired divine rewards", styles["h1"]))
    for item in cfg["existing"]:
        story.append(existing_card(item, styles, cfg))
    story.append(Paragraph(
        "Acquired rewards are graded in place. They are not automatically assumed to consume obedience slots; that is a campaign ruling the GM must settle.", styles["small"]))
    story.append(PageBreak())

    for tier in (1, 2, 3):
        entries = cfg["tiers"][tier]
        label = f"Top {len(entries)}" if len(entries) >= 10 else "Top Five"
        story.append(Paragraph(f"Tier {tier} - {label}", styles["h1"]))
        intro = {
            1: "Tier 1 is about repeatable utility and thematic foundations. At level 17, flexibility matters more than low spell level.",
            2: "Tier 2 contains the build-shaping engines. These rankings weigh both domain purity and how often the boon changes play.",
            3: "Tier 3 is the capstone. These abilities should justify the slot in epic and mythic play, not merely imitate a routine spell.",
        }[tier]
        story.append(Paragraph(intro, styles["body"]))
        for rank, item in enumerate(entries, 1):
            if rank == 6:
                story.append(PageBreak())
                story.append(Paragraph(f"Tier {tier} - Ranks 6-{len(entries)}", styles["h1"]))
            story.append(rank_card(str(rank), item, styles, cfg))
        if tier != 3:
            story.append(PageBreak())

    story.append(PageBreak())
    story.append(Paragraph("Selection and order", styles["h1"]))
    story.append(Paragraph("Primary recommendation", styles["h2"]))
    story.append(Paragraph(f"<b>{cfg['primary']}</b>", styles["body"]))
    story.append(Paragraph("Alternative recommendation", styles["h2"]))
    story.append(Paragraph(f"<b>{cfg['additive']}</b>", styles["body"]))
    story.append(Paragraph(cfg["decision"], styles["body"]))
    story.append(Paragraph("Options removed by the domain rule", styles["h2"]))
    for x in cfg["exclusions"]:
        story.append(Paragraph(f"- {x}", styles["body"]))
    story.append(Paragraph("GM decisions before locking the package", styles["h2"]))
    for i, x in enumerate(cfg["questions"], 1):
        story.append(Paragraph(f"{i}. {x}", styles["body"]))
    story.append(Spacer(1, 8))
    story.append(Paragraph("Practical order", styles["h2"]))
    if cfg is DEMIDIUS:
        order = (
            "At the next available tier-1 selection, take Lucky Blessing. If acquired gifts occupy their printed tiers, keep Fortune's Child and Seven-Pipped Gem. "
            "If they are separate, take Fortunate Spells at tier 2 and Blast of Motes at tier 3; use Invoke Uprising instead when domination and possession are common."
        )
    else:
        order = (
            "At tier 1, take Creator if Aristea remains the party's main crafter; otherwise take Discerning Mind. At tier 2, take Rite of Passage for Nereus identity or Poisoned Mysticism for caster-level contests. "
            "At tier 3, take Sacred Crafting for campaign economy, Rally Crew for fleet-wide operations, or Adaptive Flesh and Twisting Steel for personal combat and transformation."
        )
    story.append(Paragraph(order, styles["body"]))
    story.append(PageBreak())

    story.append(Paragraph("Sources and boundaries", styles["h1"]))
    story.append(Paragraph(
        "Mechanics were checked against the Pathfinder 1e Archives of Nethys. The campaign's mix-and-match permission is a house rule; printed obedience feats normally preserve patron and category requirements. The following source pages contain every ranked boon in this guide.", styles["body"]))
    used = []
    for tier in cfg["tiers"].values():
        for _, _, deity, _, _, _ in tier:
            if deity not in used:
                used.append(deity)
    for item in cfg["existing"]:
        deity = item[4]
        if deity in SOURCES and deity not in used:
            used.append(deity)
    for deity in used:
        url = SOURCES[deity]
        story.append(Paragraph(f'<b>{deity}</b>: <link href="{url}" color="#{accent.hexval()[2:]}">{url}</link>', styles["source"]))
        story.append(Spacer(1, 3))
    story.append(Spacer(1, 8))
    story.append(Paragraph(
        "Character-state basis: campaign project records current as of 22 July 2026. This document is an optimization guide, not a character-sheet mutation or final GM ruling.", styles["small"]))

    doc.build(story, onFirstPage=lambda c, d: footer(c, d, cfg), onLaterPages=lambda c, d: footer(c, d, cfg))
    return path


if __name__ == "__main__":
    print(build_pdf(DEMIDIUS, "Demidius_Hermes_Domain_Boon_Guide.pdf"))
    print(build_pdf(ARISTEA, "Aristea_Nereus_Domain_Boon_Guide.pdf"))

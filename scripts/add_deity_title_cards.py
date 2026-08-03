#!/usr/bin/env python3
"""Add Aetherion-style lower title treatments to canonical deity portraits.

This is deliberately deterministic raster compositing. It does not regenerate,
restyle, crop, resize, or otherwise reinterpret the source artwork.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont


MAIN = Path(__file__).resolve().parents[1]
WIKI = MAIN / "Demidius-Pathfinder-Codex.wiki"
PROJECT_OUTPUT = MAIN / "tmp" / "deity-title-cards"
FONT_NAME = Path(r"C:\Windows\Fonts\georgia.ttf")
FONT_SMALL = Path(r"C:\Windows\Fonts\times.ttf")

TARGETS = [
    "Fel", "Apollo", "Artemis", "Hermes", "Vara", "Persephone", "Hades",
    "Hestia", "Athena", "Triton", "Leto", "Eleos", "Pik", "Zeus", "Hera",
    "Alexander", "Demeter", "Nike", "Rhea", "Hypnos", "The Silent Sister",
    "Styx", "Anteros", "Poseidon", "Amphitrite", "Hephaestus", "Aphrodite",
    "Harmonia", "Kronos", "Atlas", "Prometheus", "Calypso", "Oceanus",
    "Mnemosyne", "Iapetus", "Asteria", "Themis", "Eos", "Ares", "Eris",
    "Enyo", "Typhon", "Hecate", "Aite", "Eros", "Phobos", "Deimos",
    "Polemos", "Nyx", "Gaia", "Aether", "Hemera", "Tartarus", "Ouranos",
    "Chronos", "Ananke", "Erebus", "Eros (Primordial)", "Hydros", "Phusis",
    "Pontus", "Tethys", "Nereus", "Thanatos", "Morpheus", "The Fates",
    "Dionysus", "Asclepius", "Muses", "Harpocrates", "The Furies",
    "Cleomenes", "Perlot", "Galatea", "Peitho", "Ena", "Keto", "Echidna",
]

SLUGS = {
    "The Silent Sister": "The-Silent-Sister", "Eros (Primordial)": "Eros-Primordial",
    "The Fates": "The-Fates", "The Furies": "The-Furies",
}

LINEAGE = {
    "Fel": "FROM THE OUTER REALMS", "Apollo": "SON OF ZEUS", "Artemis": "DAUGHTER OF ZEUS",
    "Hermes": "SON OF ZEUS", "Vara": "LINEAGE UNRECORDED", "Persephone": "DAUGHTER OF ZEUS",
    "Hades": "SON OF KRONOS", "Hestia": "DAUGHTER OF KRONOS", "Athena": "DAUGHTER OF ZEUS",
    "Triton": "SON OF POSEIDON", "Leto": "DAUGHTER OF COEUS", "Eleos": "DAUGHTER OF NYX",
    "Pik": "LINEAGE UNRECORDED", "Zeus": "SON OF KRONOS", "Hera": "DAUGHTER OF KRONOS",
    "Alexander": "PRIMORDIAL OF UNKNOWN LINEAGE", "Demeter": "DAUGHTER OF KRONOS",
    "Nike": "DAUGHTER OF PALLAS", "Rhea": "DAUGHTER OF OURANOS", "Hypnos": "SON OF NYX",
    "The Silent Sister": "LINEAGE UNRECORDED", "Styx": "DAUGHTER OF OCEANUS",
    "Anteros": "SON OF ARES", "Poseidon": "SON OF KRONOS", "Amphitrite": "DAUGHTER OF NEREUS",
    "Hephaestus": "SON OF HERA", "Aphrodite": "BORN OF OURANOS", "Harmonia": "DAUGHTER OF ARES",
    "Kronos": "SON OF OURANOS", "Atlas": "SON OF IAPETUS", "Prometheus": "SON OF IAPETUS",
    "Calypso": "DAUGHTER OF ATLAS", "Oceanus": "SON OF OURANOS",
    "Mnemosyne": "DAUGHTER OF OURANOS", "Iapetus": "SON OF OURANOS",
    "Asteria": "DAUGHTER OF COEUS", "Themis": "DAUGHTER OF OURANOS", "Eos": "DAUGHTER OF HYPERION",
    "Ares": "SON OF ZEUS", "Eris": "DAUGHTER OF NYX", "Enyo": "DAUGHTER OF ZEUS",
    "Typhon": "SON OF TARTARUS", "Hecate": "DAUGHTER OF PERSES", "Aite": "DAUGHTER OF ERIS",
    "Eros": "SON OF ARES", "Phobos": "SON OF ARES", "Deimos": "SON OF ARES",
    "Polemos": "BORN OF ERIS", "Nyx": "BORN OF CHAOS", "Gaia": "PRIMORDIAL OF THE FIRST CREATION",
    "Aether": "SON OF EREBUS", "Hemera": "DAUGHTER OF EREBUS", "Tartarus": "PRIMORDIAL OF THE FIRST CREATION",
    "Ouranos": "BORN OF GAIA", "Chronos": "PRIMORDIAL OF UNKNOWN LINEAGE",
    "Ananke": "PRIMORDIAL OF UNKNOWN LINEAGE", "Erebus": "BORN OF CHAOS",
    "Eros (Primordial)": "PRIMORDIAL OF THE FIRST CREATION", "Hydros": "PRIMORDIAL OF UNKNOWN LINEAGE",
    "Phusis": "PRIMORDIAL OF UNKNOWN LINEAGE", "Pontus": "BORN OF GAIA",
    "Tethys": "DAUGHTER OF OURANOS", "Nereus": "SON OF PONTUS", "Thanatos": "SON OF NYX",
    "Morpheus": "SON OF HYPNOS", "The Fates": "DAUGHTERS OF ZEUS", "Dionysus": "SON OF ZEUS",
    "Asclepius": "SON OF APOLLO", "Muses": "DAUGHTERS OF ZEUS", "Harpocrates": "SON OF OSIRIS",
    "The Furies": "BORN OF OURANOS", "Cleomenes": "LINEAGE UNRECORDED",
    "Perlot": "LINEAGE UNRECORDED",
    "Galatea": "DAUGHTER OF NEREUS", "Peitho": "DAUGHTER OF OCEANUS",
    "Ena": "PATERNAL LINEAGE UNRECORDED", "Keto": "DAUGHTER OF PONTUS",
    "Echidna": "DAUGHTER OF PHORCYS",
}

PORTFOLIO = {
    "Fel": "MAGIC, DEATH, KNOWLEDGE, AND SCALYKIND",
    "Apollo": "SUN, HEALING, STRENGTH, AND GOODNESS",
    "Artemis": "LIBERATION, ANIMALS, PURITY, THE HUNT, AND THE MOON",
    "Hermes": "TRICKERY, TRAVEL, COMMUNITY, LIBERATION, AND LUCK",
    "Vara": "DREAMS, ESPIONAGE, THOUGHT, MEMORY, INDUSTRY, FATE, AND IMAGINATION",
    "Persephone": "PLANTS, LIFE, REPOSE, SEASONS, AND REDEMPTION",
    "Hades": "DEATH, LAW, EARTH, AND DARKNESS", "Hestia": "MAGIC, COMMUNITY, FIRE, HEALING, AND PROTECTION",
    "Athena": "WAR, LAW, ARTIFICE, KNOWLEDGE, AND PROTECTION",
    "Triton": "GLORY, WATER, WAR, AND LEADERSHIP", "Leto": "FAMILY, HEALING, RETRIBUTION, AND CURSES",
    "Eleos": "GOODNESS, HEALING, RENEWAL, AND PURITY", "Pik": "PORTFOLIO UNRECORDED",
    "Zeus": "NOBILITY, AIR, LAW, AND STRENGTH", "Hera": "WATER, NOBILITY, LAW, AND GLORY",
    "Alexander": "EARTH, PROTECTION, WAR, AND TYRANNY",
    "Demeter": "COMMUNITY, HEALING, ANIMALS, FAMINE, PLANTS, AND SEASONS",
    "Nike": "GLORY, WAR, LUCK, AND STRENGTH", "Rhea": "HEALING AND TRICKERY",
    "Hypnos": "AIR, DARKNESS, PROTECTION, AND DREAMS",
    "The Silent Sister": "PROTECTION, VENGEANCE, AND DEATH", "Styx": "DEATH, LAW, AND WATER",
    "Anteros": "LOVE AND JUDGMENT", "Poseidon": "WEATHER, WATER, CHAOS, EROSION, AND DESTRUCTION",
    "Amphitrite": "WATER, NOBILITY, AND ANIMALS", "Hephaestus": "ARTIFICE, FIRE, RUNES, AND SOLITUDE",
    "Aphrodite": "CHARM, CHAOS, FLOTSAM, AND GLORY", "Harmonia": "LAW AND HONOR",
    "Kronos": "TIME, DEATH, NOBILITY, ESPIONAGE, HUBRIS, DECAY, LAW, AND FATE",
    "Atlas": "WAR, ENDURANCE, STRENGTH, PROTECTION, LEGEND, AND RAGE",
    "Prometheus": "FIRE, FATE, KNOWLEDGE, MAGIC, CLOUDS, AND SOLITUDE",
    "Calypso": "CHARM, OCEANS, SOLITUDE, AND CURSES", "Oceanus": "WATER",
    "Mnemosyne": "MEMORY", "Iapetus": "MORTALITY, CRAFT, AND THE WEST",
    "Asteria": "FALLING STARS, NIGHT DIVINATION, AND DREAMS", "Themis": "DIVINE LAW, ORDER, AND PROPHECY",
    "Eos": "THE DAWN", "Ares": "WAR, CHAOS, STRENGTH, DESTRUCTION, FORTIFICATIONS, AND FEAR",
    "Eris": "DISCORD, DESTRUCTION, AND RIVALRY", "Enyo": "WAR, DESTRUCTION, AND REVELRY",
    "Typhon": "STORMS, VOLCANOES, AND MONSTERS", "Hecate": "MAGIC, UNDEATH, DARKNESS, AND EVIL",
    "Aite": "TRICKERY, RUIN, MADNESS, AND CHARM", "Eros": "CHARM, MADNESS, AND CHAOS",
    "Phobos": "MADNESS, RIOTS, AND CURSES", "Deimos": "DREAD AND TERROR", "Polemos": "WAR AND BATTLE",
    "Nyx": "DARKNESS, NIGHT, STARS, THOUGHT, AND MAGIC", "Gaia": "EARTH, NATURE, PLANTS, AND ANIMALS",
    "Aether": "CLOUDS, LIGHT, LIFE, AIR, AND THE HEAVENS", "Hemera": "DAYLIGHT",
    "Tartarus": "THE ABYSS AND DIVINE PUNISHMENT", "Ouranos": "THE SKY AND HEAVENS",
    "Chronos": "TIME", "Ananke": "NECESSITY, COMPULSION, AND FATE", "Erebus": "DARKNESS AND SHADOW",
    "Eros (Primordial)": "CREATION AND PRIMAL DESIRE", "Hydros": "PRIMORDIAL WATERS",
    "Phusis": "NATURE AND CREATION", "Pontus": "THE SEA", "Tethys": "NOURISHING WATERS",
    "Nereus": "THE SEA, KNOWLEDGE, AND PROPHECY", "Thanatos": "DEATH, REPOSE, LAW, AND DARKNESS",
    "Morpheus": "AIR, PROTECTION, GOODNESS, IMAGINATION, NIGHT, AND DREAMS",
    "The Fates": "LEGEND, FATE, TRUTH, AND REVELATION", "Dionysus": "MADNESS, CHAOS, PLANTS, AND TRAVEL",
    "Asclepius": "HEALING AND EDUCATION", "Muses": "ARTIFICE, KNOWLEDGE, LUCK, AND CHARM",
    "Harpocrates": "SOLITUDE, PURITY, AND KNOWLEDGE", "The Furies": "FAMILY, JUDGMENT, FEROCITY, AND BLOOD",
    "Cleomenes": "SCALYKIND, FIRE, AND SURVIVAL", "Perlot": "LAW, WAR, AND COMMUNITY",
    "Galatea": "WATER, CAPTIVATION, AND LOVE",
    "Peitho": "CHARM", "Ena": "HEALING, PHOENIX, INDUSTRY, HOME, COOPERATION, AND LIBERATION",
    "Keto": "SEA MONSTERS AND THE OCEAN DEPTHS", "Echidna": "MONSTERS, SERPENTS, AND WILD PLACES",
}

FEMALE = {
    "Artemis", "Vara", "Persephone", "Hestia", "Athena", "Leto", "Eleos", "Hera", "Demeter", "Nike",
    "Rhea", "The Silent Sister", "Styx", "Amphitrite", "Aphrodite", "Harmonia", "Calypso", "Mnemosyne",
    "Asteria", "Themis", "Eos", "Eris", "Enyo", "Hecate", "Aite", "Nyx", "Gaia", "Hemera", "Ananke",
    "Tethys", "The Fates", "Muses", "The Furies", "Galatea", "Peitho", "Ena", "Keto", "Echidna",
}

MOTIF = {
    "Fel":"dragon", "Apollo":"sun", "Artemis":"moon", "Hermes":"staff", "Vara":"eye", "Persephone":"fruit",
    "Hades":"bident", "Hestia":"flame", "Athena":"owl", "Triton":"trident", "Leto":"laurel", "Eleos":"healing",
    "Pik":"mushroom", "Zeus":"bolt", "Hera":"peacock", "Alexander":"mountain", "Demeter":"wheat", "Nike":"wings",
    "Rhea":"crown", "Hypnos":"moon", "The Silent Sister":"sword", "Styx":"wave", "Anteros":"heart",
    "Poseidon":"trident", "Amphitrite":"shell", "Hephaestus":"hammer", "Aphrodite":"rose", "Harmonia":"rings",
    "Kronos":"sickle", "Atlas":"globe", "Prometheus":"torch", "Calypso":"loom", "Oceanus":"wave",
    "Mnemosyne":"book", "Iapetus":"pillar", "Asteria":"star", "Themis":"scales", "Eos":"sun", "Ares":"spear",
    "Eris":"apple", "Enyo":"sword", "Typhon":"storm", "Hecate":"keys", "Aite":"spiral", "Eros":"bow",
    "Phobos":"mask", "Deimos":"mask", "Polemos":"swords", "Nyx":"moon", "Gaia":"tree", "Aether":"star",
    "Hemera":"sun", "Tartarus":"chains", "Ouranos":"stars", "Chronos":"hourglass", "Ananke":"spindle",
    "Erebus":"eclipse", "Eros (Primordial)":"spiral", "Hydros":"wave", "Phusis":"leaf", "Pontus":"wave",
    "Tethys":"river", "Nereus":"trident", "Thanatos":"torch", "Morpheus":"wing", "The Fates":"spindle",
    "Dionysus":"grapes", "Asclepius":"healing", "Muses":"lyre", "Harpocrates":"eye", "The Furies":"serpent",
    "Cleomenes":"dragon", "Perlot":"sword", "Galatea":"shell", "Peitho":"heart", "Ena":"phoenix", "Keto":"serpent", "Echidna":"serpent",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def page_and_image(name: str) -> tuple[Path, Path]:
    slug = SLUGS.get(name, name.replace(" ", "-"))
    page = WIKI / f"{slug}.md"
    text = page.read_text(encoding="utf-8")
    match = re.search(r"!\[[^\]]*\]\((images/deities/[^)]+)\)", text)
    if not match:
        raise RuntimeError(f"No deity image on {page}")
    return page, WIKI / match.group(1)


def spaced_width(draw: ImageDraw.ImageDraw, text: str, font: ImageFont.FreeTypeFont, spacing: int) -> float:
    return sum(draw.textlength(ch, font=font) for ch in text) + spacing * max(0, len(text) - 1)


def draw_spaced(draw: ImageDraw.ImageDraw, center_x: int, y: int, text: str, font: ImageFont.FreeTypeFont,
                spacing: int, fill: tuple[int, ...], stroke_width: int = 0, stroke_fill=(0, 0, 0, 220)) -> None:
    x = center_x - spaced_width(draw, text, font, spacing) / 2
    for ch in text:
        draw.text((x, y), ch, font=font, fill=fill, anchor="la", stroke_width=stroke_width, stroke_fill=stroke_fill)
        x += draw.textlength(ch, font=font) + spacing


def fit_spaced(draw: ImageDraw.ImageDraw, text: str, max_width: int, start_size: int, min_size: int, spacing_ratio=.16):
    for size in range(start_size, min_size - 1, -1):
        font = ImageFont.truetype(str(FONT_NAME), size)
        spacing = max(1, int(size * spacing_ratio))
        if spaced_width(draw, text, font, spacing) <= max_width:
            return font, spacing
    return ImageFont.truetype(str(FONT_NAME), min_size), max(1, int(min_size * spacing_ratio))


def wrap_words(draw: ImageDraw.ImageDraw, text: str, font: ImageFont.FreeTypeFont, max_width: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    line = ""
    for word in words:
        candidate = word if not line else f"{line} {word}"
        if draw.textlength(candidate, font=font) <= max_width:
            line = candidate
        else:
            if line:
                lines.append(line)
            line = word
    if line:
        lines.append(line)
    if len(lines) > 2:
        midpoint = len(words) // 2
        lines = [" ".join(words[:midpoint]), " ".join(words[midpoint:])]
    return lines


def line(draw, points, fill, width):
    draw.line(points, fill=fill, width=width, joint="curve")


def draw_sigel(layer: Image.Image, name: str, center: tuple[int, int], size: int) -> None:
    draw = ImageDraw.Draw(layer)
    cx, cy = center
    gold = (215, 176, 99, 235)
    pale = (245, 224, 177, 220)
    w = max(2, size // 36)
    r = size // 3
    motif = MOTIF[name]
    # Shared restrained crest: open circle, small side wings, and a unique motif.
    draw.arc((cx-r, cy-r, cx+r, cy+r), 205, 335, fill=gold, width=w)
    draw.arc((cx-r, cy-r, cx+r, cy+r), 25, 155, fill=gold, width=w)
    for side in (-1, 1):
        x0 = cx + side * (r - 2)
        line(draw, [(x0, cy), (cx + side*(r+size*.20), cy-size*.09), (cx + side*(r+size*.30), cy-size*.02)], gold, w)
        line(draw, [(x0, cy+size*.06), (cx + side*(r+size*.18), cy+size*.14), (cx + side*(r+size*.27), cy+size*.09)], gold, w)
    s = size
    if motif in {"bolt", "storm"}:
        pts=[(cx-s*.08,cy-s*.28),(cx+s*.05,cy-s*.08),(cx-s*.01,cy-s*.08),(cx+s*.09,cy+s*.28),(cx-s*.09,cy+s*.04),(cx-s*.01,cy+s*.04)]
        draw.polygon(pts, outline=pale, fill=(215,176,99,90))
    elif motif in {"sun", "star", "stars", "eclipse"}:
        draw.ellipse((cx-s*.11,cy-s*.11,cx+s*.11,cy+s*.11), outline=pale, width=w)
        for i in range(8):
            import math
            a=i*math.pi/4; line(draw,[(cx+math.cos(a)*s*.16,cy+math.sin(a)*s*.16),(cx+math.cos(a)*s*.27,cy+math.sin(a)*s*.27)],gold,w)
        if motif=="eclipse": draw.ellipse((cx-s*.04,cy-s*.11,cx+s*.16,cy+s*.11),fill=(15,15,25,220))
    elif motif in {"moon"}:
        draw.ellipse((cx-s*.13,cy-s*.2,cx+s*.13,cy+s*.2), outline=pale, width=w)
        draw.ellipse((cx-s*.02,cy-s*.22,cx+s*.19,cy+s*.18), fill=(10,12,22,230))
    elif motif in {"trident", "bident", "staff", "healing"}:
        line(draw,[(cx,cy+s*.24),(cx,cy-s*.22)],pale,w)
        arms=3 if motif in {"trident","staff"} else 2
        offsets=[-1,0,1] if arms==3 else [-1,1]
        for j in offsets:
            x=cx+j*s*.11; line(draw,[(cx,cy-s*.08),(x,cy-s*.2),(x-j*s*.04,cy-s*.13)],gold,w)
        if motif=="healing":
            draw.arc((cx-s*.12,cy-s*.13,cx+s*.08,cy+s*.12),70,285,fill=gold,width=w)
    elif motif in {"flame", "torch", "phoenix"}:
        draw.polygon([(cx,cy-s*.25),(cx+s*.13,cy-s*.02),(cx+s*.06,cy+s*.12),(cx,cy+s*.22),(cx-s*.09,cy+s*.08),(cx-s*.12,cy-s*.04)], outline=pale, fill=(215,140,55,90))
        if motif=="phoenix":
            line(draw,[(cx,cy),(cx-s*.25,cy-s*.09),(cx-s*.13,cy+s*.02)],gold,w); line(draw,[(cx,cy),(cx+s*.25,cy-s*.09),(cx+s*.13,cy+s*.02)],gold,w)
    elif motif in {"sword", "swords", "spear", "sickle", "hammer"}:
        if motif=="swords":
            line(draw,[(cx-s*.18,cy+s*.2),(cx+s*.18,cy-s*.2)],pale,w); line(draw,[(cx+s*.18,cy+s*.2),(cx-s*.18,cy-s*.2)],pale,w)
        elif motif=="sickle":
            line(draw,[(cx-s*.08,cy+s*.24),(cx+s*.04,cy-s*.18)],pale,w); draw.arc((cx-s*.02,cy-s*.25,cx+s*.24,cy+s*.01),210,70,fill=gold,width=w*2)
        elif motif=="hammer":
            line(draw,[(cx-s*.08,cy+s*.22),(cx+s*.06,cy-s*.1)],pale,w); draw.rectangle((cx-s*.08,cy-s*.2,cx+s*.19,cy-s*.08),outline=gold,width=w)
        else:
            line(draw,[(cx,cy+s*.23),(cx,cy-s*.22)],pale,w); line(draw,[(cx-s*.1,cy-s*.1),(cx+s*.1,cy-s*.1)],gold,w)
    elif motif in {"wave", "river", "shell"}:
        for j in range(3):
            y=cy+(j-1)*s*.09; draw.arc((cx-s*.22,y-s*.08,cx,y+s*.08),190,350,fill=gold,width=w); draw.arc((cx,y-s*.08,cx+s*.22,y+s*.08),10,170,fill=gold,width=w)
        if motif=="shell":
            for j in range(-2,3): line(draw,[(cx,cy+s*.17),(cx+j*s*.06,cy-s*.16)],pale,w)
    elif motif in {"heart", "rose", "fruit", "apple", "grapes"}:
        if motif=="grapes":
            for dx,dy in [(0,-.15),(-.07,-.05),(.07,-.05),(-.11,.05),(0,.05),(.11,.05),(0,.15)]:
                draw.ellipse((cx+s*(dx-.035),cy+s*(dy-.035),cx+s*(dx+.035),cy+s*(dy+.035)),outline=gold,width=w)
        elif motif in {"fruit","apple"}:
            draw.ellipse((cx-s*.14,cy-s*.12,cx+s*.14,cy+s*.18),outline=gold,width=w); line(draw,[(cx,cy-s*.12),(cx+s*.06,cy-s*.24)],pale,w)
        else:
            draw.polygon([(cx,cy+s*.22),(cx-s*.2,cy),(cx-s*.13,cy-s*.16),(cx,cy-s*.05),(cx+s*.13,cy-s*.16),(cx+s*.2,cy)],outline=gold,fill=(215,176,99,45))
    elif motif in {"eye", "owl", "mask", "peacock"}:
        draw.ellipse((cx-s*.22,cy-s*.12,cx+s*.22,cy+s*.12),outline=gold,width=w); draw.ellipse((cx-s*.06,cy-s*.06,cx+s*.06,cy+s*.06),outline=pale,width=w)
        if motif=="owl":
            draw.ellipse((cx-s*.18,cy-s*.1,cx-s*.02,cy+s*.08),outline=gold,width=w); draw.ellipse((cx+s*.02,cy-s*.1,cx+s*.18,cy+s*.08),outline=gold,width=w)
    elif motif in {"scales", "rings", "chains"}:
        line(draw,[(cx,cy-s*.22),(cx,cy+s*.2)],pale,w); line(draw,[(cx-s*.2,cy-s*.08),(cx+s*.2,cy-s*.08)],gold,w)
        if motif=="rings":
            draw.ellipse((cx-s*.18,cy-s*.1,cx+s*.02,cy+s*.1),outline=gold,width=w); draw.ellipse((cx-s*.02,cy-s*.1,cx+s*.18,cy+s*.1),outline=pale,width=w)
        else:
            for side in (-1,1): draw.arc((cx+side*s*.12-s*.08,cy-s*.03,cx+side*s*.12+s*.08,cy+s*.16),0,180,fill=gold,width=w)
    elif motif in {"tree", "leaf", "wheat", "laurel"}:
        line(draw,[(cx,cy+s*.23),(cx,cy-s*.2)],pale,w)
        for j in range(-2,3):
            y=cy+j*s*.08; draw.ellipse((cx-s*.16,y-s*.05,cx,y+s*.05),outline=gold,width=w); draw.ellipse((cx,y-s*.05,cx+s*.16,y+s*.05),outline=gold,width=w)
    elif motif in {"hourglass", "spindle", "loom"}:
        draw.polygon([(cx-s*.16,cy-s*.22),(cx+s*.16,cy-s*.22),(cx-s*.12,cy+s*.22),(cx+s*.12,cy+s*.22)],outline=gold); line(draw,[(cx-s*.16,cy-s*.22),(cx+s*.12,cy+s*.22)],pale,w)
    elif motif in {"book", "lyre", "keys"}:
        if motif=="book":
            draw.polygon([(cx,cy-s*.16),(cx-s*.22,cy-s*.2),(cx-s*.22,cy+s*.18),(cx,cy+s*.12)],outline=gold); draw.polygon([(cx,cy-s*.16),(cx+s*.22,cy-s*.2),(cx+s*.22,cy+s*.18),(cx,cy+s*.12)],outline=gold)
        elif motif=="keys":
            for side in (-1,1): draw.ellipse((cx+side*s*.09-s*.05,cy-s*.21,cx+side*s*.09+s*.05,cy-s*.11),outline=gold,width=w); line(draw,[(cx+side*s*.09,cy-s*.11),(cx-side*s*.08,cy+s*.21)],pale,w)
        else:
            draw.arc((cx-s*.2,cy-s*.2,cx+s*.2,cy+s*.25),20,160,fill=gold,width=w); line(draw,[(cx-s*.12,cy-s*.1),(cx-s*.08,cy+s*.18)],pale,w); line(draw,[(cx+s*.12,cy-s*.1),(cx+s*.08,cy+s*.18)],pale,w)
    elif motif in {"dragon", "serpent", "spiral"}:
        draw.arc((cx-s*.2,cy-s*.2,cx+s*.2,cy+s*.2),20,330,fill=gold,width=w*2)
        draw.arc((cx-s*.11,cy-s*.11,cx+s*.11,cy+s*.11),200,540,fill=pale,width=w)
        if motif=="dragon":
            line(draw,[(cx-s*.18,cy),(cx-s*.29,cy-s*.13),(cx-s*.26,cy+s*.05)],gold,w); line(draw,[(cx+s*.18,cy),(cx+s*.29,cy-s*.13),(cx+s*.26,cy+s*.05)],gold,w)
    elif motif in {"mountain", "pillar", "globe", "crown", "wings", "wing", "mushroom"}:
        if motif=="mountain": draw.polygon([(cx-s*.24,cy+s*.18),(cx,cy-s*.22),(cx+s*.24,cy+s*.18)],outline=gold)
        elif motif=="globe": draw.ellipse((cx-s*.2,cy-s*.2,cx+s*.2,cy+s*.2),outline=gold,width=w); line(draw,[(cx-s*.2,cy),(cx+s*.2,cy)],pale,w); draw.arc((cx-s*.1,cy-s*.2,cx+s*.1,cy+s*.2),90,270,fill=pale,width=w)
        elif motif=="mushroom": draw.arc((cx-s*.22,cy-s*.2,cx+s*.22,cy+s*.12),180,360,fill=gold,width=w*2); draw.rectangle((cx-s*.06,cy,cx+s*.06,cy+s*.22),outline=pale,width=w)
        elif motif=="crown": draw.polygon([(cx-s*.22,cy+s*.14),(cx-s*.18,cy-s*.15),(cx,cy+s*.02),(cx+s*.18,cy-s*.15),(cx+s*.22,cy+s*.14)],outline=gold)
        elif motif in {"wings","wing"}: line(draw,[(cx,cy+s*.15),(cx-s*.24,cy-s*.12),(cx-s*.12,cy+s*.08)],gold,w); line(draw,[(cx,cy+s*.15),(cx+s*.24,cy-s*.12),(cx+s*.12,cy+s*.08)],gold,w)
        else: draw.rectangle((cx-s*.08,cy-s*.24,cx+s*.08,cy+s*.24),outline=gold,width=w)
    else:
        font=ImageFont.truetype(str(FONT_NAME), int(size*.42)); initials="".join(w[0] for w in name.replace("The ","").split())[:2]
        draw.text((cx,cy),initials,font=font,fill=pale,anchor="mm")


def make_card(name: str, source: Path, output: Path) -> dict:
    original = Image.open(source).convert("RGBA")
    image = original.copy()
    w, h = image.size
    start_y = int(h * (0.62 if w / h > 1.2 else 0.70 if w / h > .9 else 0.76))
    overlay = Image.new("RGBA", image.size, (0, 0, 0, 0))
    mask = Image.new("L", image.size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle((int(w*.06), start_y, int(w*.94), h+80), radius=max(20,int(w*.05)), fill=178)
    mask = mask.filter(ImageFilter.GaussianBlur(max(18, int(w*.035))))
    dark = Image.new("RGBA", image.size, (3, 7, 16, 205))
    overlay = Image.composite(dark, overlay, mask)
    image = Image.alpha_composite(image, overlay)

    text_layer = Image.new("RGBA", image.size, (0,0,0,0))
    draw = ImageDraw.Draw(text_layer)
    cx = w // 2
    name_text = name.upper()
    name_font, name_spacing = fit_spaced(draw, name_text, int(w*.78), max(42,int(w*.055)), max(28,int(w*.034)))
    small = max(16, int(w*.019))
    small_font = ImageFont.truetype(str(FONT_SMALL), small)
    domain_font = ImageFont.truetype(str(FONT_SMALL), max(15,int(w*.017)))
    name_y = start_y + int((h-start_y)*.13)
    draw_spaced(draw, cx, name_y, name_text, name_font, name_spacing, (245,224,177,255), max(1,w//700))
    parent_y = name_y + int(name_font.size*1.18)
    draw_spaced(draw, cx, parent_y, LINEAGE[name], small_font, max(1,int(small*.16)), (242,235,220,250), 1)
    prefix = "GODDESSES OF " if name in {"The Fates","Muses","The Furies"} else ("GODDESS OF " if name in FEMALE else "GOD OF ")
    domain_lines = wrap_words(draw, prefix + PORTFOLIO[name], domain_font, int(w*.76))
    domain_y = parent_y + int(small*1.35)
    for i, domain_line in enumerate(domain_lines[:2]):
        draw_spaced(draw, cx, domain_y + i*int(domain_font.size*1.22), domain_line, domain_font, max(1,int(domain_font.size*.11)), (231,220,201,245), 1)
    sig_size = max(70, int(w*.09))
    sig_y = min(h-int(sig_size*.43), domain_y + len(domain_lines[:2])*int(domain_font.size*1.30) + int(sig_size*.45))
    draw_sigel(text_layer, name, (cx, sig_y), sig_size)
    image = Image.alpha_composite(image, text_layer)

    output.parent.mkdir(parents=True, exist_ok=True)
    image.convert("RGB").save(output, "PNG", optimize=True)
    rendered = Image.open(output).convert("RGBA")
    diff = ImageChops.difference(original.convert("RGB"), rendered.convert("RGB"))
    bbox = diff.getbbox()
    if not bbox or bbox[1] < max(0, start_y - int(w*.12)):
        raise RuntimeError(f"Unexpected modified bounds for {name}: {bbox}, start {start_y}")
    return {
        "name": name, "source": str(source), "output": str(output), "lineage": LINEAGE[name],
        "portfolio": PORTFOLIO[name], "motif": MOTIF[name], "source_sha256": sha256(source),
        "output_sha256": sha256(output), "modified_bbox": bbox, "dimensions": [w,h],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", action="append", default=[], help="Exact deity name; repeatable")
    parser.add_argument("--out-dir", type=Path)
    parser.add_argument("--apply", action="store_true", help="Replace Wiki images and any existing main-repo mirrors")
    args = parser.parse_args()
    selected = args.only or TARGETS
    unknown = sorted(set(selected) - set(TARGETS))
    if unknown:
        raise SystemExit(f"Unknown targets: {unknown}")
    if not args.apply and not args.out_dir:
        raise SystemExit("Use --out-dir for previews or --apply for canonical Wiki assets")

    records = []
    for name in selected:
        _, source = page_and_image(name)
        if args.apply:
            temp = source.with_name(source.stem + ".titlecard-tmp.png")
            record = make_card(name, source, temp)
            temp.replace(source)
            record["output"] = str(source)
            record["output_sha256"] = sha256(source)
            mirror = MAIN / "docs" / "assets" / "deities" / source.name
            if mirror.exists():
                mirror.write_bytes(source.read_bytes())
                record["main_mirror"] = str(mirror)
        else:
            output = args.out_dir / source.name
            record = make_card(name, source, output)
        records.append(record)

    manifest_dir = PROJECT_OUTPUT if args.apply else args.out_dir
    manifest_dir.mkdir(parents=True, exist_ok=True)
    manifest = manifest_dir / "deity-title-cards-manifest.json"
    if args.apply and manifest.exists() and set(selected) != set(TARGETS):
        existing = json.loads(manifest.read_text(encoding="utf-8"))
        by_name = {record["name"]: record for record in existing}
        by_name.update({record["name"]: record for record in records})
        records = [by_name[name] for name in TARGETS if name in by_name]
    manifest.write_text(json.dumps(records, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"WROTE {len(records)} title cards")
    print(manifest)


if __name__ == "__main__":
    main()

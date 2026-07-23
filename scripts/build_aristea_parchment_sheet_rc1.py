"""Build Aristea's full-page frost-and-tide edition of a Hero Lab PDF.

The source PDF remains the authority for every value and table. Each source
page is rendered at print resolution, cropped to its real content, and
multiplied onto parchment so white paper becomes texture without retyping any
statistics. Decorative art, borders, and page furniture are added underneath
the preserved sheet content.
"""

from __future__ import annotations

import argparse
import io
import math
import random
from pathlib import Path

from pdf2image import convert_from_path
from PIL import (
    Image,
    ImageChops,
    ImageDraw,
    ImageEnhance,
    ImageFilter,
    ImageFont,
    ImageOps,
)
from pypdf import PdfReader
from reportlab.lib.utils import ImageReader
from reportlab.pdfgen import canvas


PAGE_WIDTH = 2040
PAGE_HEIGHT = 2640
LETTER_WIDTH = 612
LETTER_HEIGHT = 792

PARCHMENT_LIGHT = (211, 225, 233)
PARCHMENT_MID = (166, 192, 205)
PARCHMENT_DARK = (46, 76, 94)
INK = (20, 43, 59)
BLACK = (8, 24, 37)
GOLD = (184, 202, 214)
BRIGHT_GOLD = (235, 245, 250)
CRIMSON = (42, 105, 145)
DEEP_RED = (16, 55, 84)
STANDARD_WATERMARK_OPACITY = 121

FONT_GOTHIC = Path(r"C:\Windows\Fonts\OLDENGL.TTF")
FONT_SERIF = Path(r"C:\Windows\Fonts\GARA.TTF")
FONT_SERIF_BOLD = Path(r"C:\Windows\Fonts\GARABD.TTF")
CORNER_ART = Path(__file__).resolve().parents[1] / "assets" / "joyOg01-corner.png"
BOTTOM_CENTER_ART = (
    Path(__file__).resolve().parents[1] / "assets" / "4Jmuv01-bottom-center.png"
)
BOTTOM_FILIGREE_CENTER_Y = PAGE_HEIGHT - 86


def font(path: Path, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(path), size=size)


def parchment_texture(width: int, height: int, seed: int) -> Image.Image:
    rng = random.Random(seed)
    low_w, low_h = max(100, width // 10), max(100, height // 10)
    noise = Image.new("L", (low_w, low_h))
    noise.putdata([rng.randrange(256) for _ in range(low_w * low_h)])
    noise = noise.resize((width, height), Image.Resampling.BICUBIC)
    noise = noise.filter(ImageFilter.GaussianBlur(8))

    base = Image.new("RGB", (width, height), PARCHMENT_LIGHT)
    warm = Image.new("RGB", (width, height), PARCHMENT_MID)
    mask = noise.point(lambda value: int(value * 0.32))
    base = Image.composite(warm, base, mask)

    # Broad age stains.
    stains = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    sd = ImageDraw.Draw(stains)
    for _ in range(36):
        x = rng.randint(-width // 8, width)
        y = rng.randint(-height // 8, height)
        rx = rng.randint(width // 18, width // 5)
        ry = rng.randint(height // 30, height // 9)
        sd.ellipse(
            (x - rx, y - ry, x + rx, y + ry),
            fill=(94, 50, 15, rng.randint(5, 18)),
        )
    stains = stains.filter(ImageFilter.GaussianBlur(48))
    base = Image.alpha_composite(base.convert("RGBA"), stains)

    # Fibers and hairline cracks.
    fibers = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    fd = ImageDraw.Draw(fibers)
    for _ in range(2400):
        x = rng.randrange(width)
        y = rng.randrange(height)
        length = rng.randint(2, 22)
        shade = rng.choice(((75, 42, 19, 10), (255, 242, 210, 9)))
        fd.line((x, y, x + length, y + rng.choice((-1, 0, 1))), fill=shade)
    fibers = fibers.filter(ImageFilter.GaussianBlur(0.4))
    base = Image.alpha_composite(base, fibers)

    # Burnt vignette around the full bleed edge.
    vignette = Image.new("L", (width, height), 0)
    vp = vignette.load()
    for y in range(height):
        dy = min(y, height - 1 - y) / (height * 0.12)
        for x in range(width):
            dx = min(x, width - 1 - x) / (width * 0.10)
            edge = max(0.0, 1.0 - min(dx, dy, 1.0))
            vp[x, y] = int(175 * edge * edge)
    dark = Image.new("RGBA", (width, height), (*PARCHMENT_DARK, 255))
    base = Image.composite(dark, base, vignette)
    return base.convert("RGB")


def draw_rose(draw: ImageDraw.ImageDraw, x: int, y: int, radius: int) -> None:
    for i in range(10):
        angle = math.radians(i * 36)
        px = x + int(math.cos(angle) * radius * 0.48)
        py = y + int(math.sin(angle) * radius * 0.48)
        draw.ellipse(
            (px - radius // 2, py - radius // 2, px + radius // 2, py + radius // 2),
            fill=CRIMSON,
            outline=INK,
            width=max(2, radius // 12),
        )
    draw.ellipse(
        (x - radius // 2, y - radius // 2, x + radius // 2, y + radius // 2),
        fill=DEEP_RED,
        outline=GOLD,
        width=max(2, radius // 14),
    )
    draw.ellipse(
        (x - radius // 7, y - radius // 7, x + radius // 7, y + radius // 7),
        fill=BRIGHT_GOLD,
    )


def draw_corner_rose_thorns(
    draw: ImageDraw.ImageDraw,
    anchor: tuple[int, int],
    direction: tuple[int, int],
    span: int,
) -> None:
    """Draw original rose-and-thorn baroque filigree in a page corner."""

    x, y = anchor
    sx, sy = direction

    def point(u: float, v: float) -> tuple[int, int]:
        return (x + int(sx * u), y + int(sy * v))

    def cubic(
        start: tuple[float, float],
        control_1: tuple[float, float],
        control_2: tuple[float, float],
        end: tuple[float, float],
    ) -> list[tuple[int, int]]:
        points: list[tuple[int, int]] = []
        for index in range(33):
            t = index / 32
            omt = 1 - t
            u = (
                omt**3 * start[0]
                + 3 * omt**2 * t * control_1[0]
                + 3 * omt * t**2 * control_2[0]
                + t**3 * end[0]
            )
            v = (
                omt**3 * start[1]
                + 3 * omt**2 * t * control_1[1]
                + 3 * omt * t**2 * control_2[1]
                + t**3 * end[1]
            )
            points.append(point(u, v))
        return points

    # Flowing corner stems and curled interior branches.
    horizontal = cubic((25, 25), (62, 8), (126, 8), (span, 18))
    vertical = [point(v, u) for u, v in (
        (
            (1 - t) ** 3 * 25
            + 3 * (1 - t) ** 2 * t * 62
            + 3 * (1 - t) * t**2 * 126
            + t**3 * span,
            (1 - t) ** 3 * 25
            + 3 * (1 - t) ** 2 * t * 8
            + 3 * (1 - t) * t**2 * 8
            + t**3 * 18,
        )
        for t in (i / 32 for i in range(33))
    )]
    curls = (
        cubic((55, 20), (72, 55), (115, 78), (124, 42)),
        cubic((76, 18), (102, 38), (105, 66), (82, 69)),
        [point(v, u) for u, v in (
            (
                (1 - t) ** 3 * 55
                + 3 * (1 - t) ** 2 * t * 72
                + 3 * (1 - t) * t**2 * 115
                + t**3 * 124,
                (1 - t) ** 3 * 20
                + 3 * (1 - t) ** 2 * t * 55
                + 3 * (1 - t) * t**2 * 78
                + t**3 * 42,
            )
            for t in (i / 32 for i in range(33))
        )],
        [point(v, u) for u, v in (
            (
                (1 - t) ** 3 * 76
                + 3 * (1 - t) ** 2 * t * 102
                + 3 * (1 - t) * t**2 * 105
                + t**3 * 82,
                (1 - t) ** 3 * 18
                + 3 * (1 - t) ** 2 * t * 38
                + 3 * (1 - t) * t**2 * 66
                + t**3 * 69,
            )
            for t in (i / 32 for i in range(33))
        )],
    )

    for stem in (horizontal, vertical, *curls):
        draw.line(stem, fill=INK, width=10, joint="curve")
        draw.line(stem, fill=GOLD, width=3, joint="curve")

    # Pointed leaves and thorns echo the supplied floral-filigree mood while
    # remaining an original Dawnrunner rose design.
    for u, v, horizontal_leaf in (
        (63, 20, True),
        (103, 16, True),
        (151, 16, True),
        (20, 63, False),
        (16, 103, False),
        (16, 151, False),
        (93, 52, True),
        (52, 93, False),
    ):
        cx, cy = point(u, v)
        if horizontal_leaf:
            polygon = (
                (cx - sx * 4, cy),
                (cx + sx * 14, cy - sy * 10),
                (cx + sx * 25, cy),
                (cx + sx * 14, cy + sy * 8),
            )
        else:
            polygon = (
                (cx, cy - sy * 4),
                (cx - sx * 10, cy + sy * 14),
                (cx, cy + sy * 25),
                (cx + sx * 8, cy + sy * 14),
            )
        draw.polygon(polygon, fill=INK, outline=GOLD)

    for u in (48, 82, 121, 162):
        hx, hy = point(u, 17)
        vx, vy = point(17, u)
        draw.polygon(
            ((hx, hy), (hx - sx * 9, hy + sy * 3), (hx - sx * 2, hy + sy * 15)),
            fill=INK,
            outline=GOLD,
        )
        draw.polygon(
            ((vx, vy), (vx + sx * 3, vy - sy * 9), (vx + sx * 15, vy - sy * 2)),
            fill=INK,
            outline=GOLD,
        )

    draw_rose(draw, *point(27, 27), 38)


def add_svg_corner_art(page: Image.Image, corner_art: Image.Image) -> None:
    """Place a frost-blue and silver treatment of the supplied corner motif."""

    size = 110
    inset = 38
    base = ImageOps.contain(
        corner_art.convert("RGBA"),
        (size, size),
        method=Image.Resampling.LANCZOS,
    )
    variants = (
        (base, (inset, inset)),
        (ImageOps.mirror(base), (PAGE_WIDTH - inset - base.width, inset)),
        (ImageOps.flip(base), (inset, PAGE_HEIGHT - inset - base.height)),
        (
            base.rotate(180, expand=False),
            (PAGE_WIDTH - inset - base.width, PAGE_HEIGHT - inset - base.height),
        ),
    )
    for ornament, position in variants:
        alpha = ornament.getchannel("A")
        frost_alpha = alpha.point(lambda value: int(value * 0.88))
        frost = Image.new("RGBA", ornament.size, (*CRIMSON, 0))
        frost.putalpha(frost_alpha)
        outline_alpha = alpha.filter(ImageFilter.MaxFilter(9)).point(
            lambda value: int(value * 0.68)
        )
        outline = Image.new("RGBA", ornament.size, (*GOLD, 0))
        outline.putalpha(outline_alpha)
        page.alpha_composite(outline, position)
        page.alpha_composite(frost, position)


def draw_ice_water_filigree(
    page: Image.Image,
    center_x: int,
    center_y: int,
    width: int,
    height: int,
) -> None:
    """Draw original wave-and-icicle filigree in blue and silver."""

    layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    mid_y = height // 2 - 2
    margin = 16

    wave: list[tuple[int, int]] = []
    for x in range(margin, width - margin):
        phase = (x - margin) / max(1, width - 2 * margin)
        y = mid_y + int(math.sin(phase * math.pi * 8) * max(2, height * 0.08))
        wave.append((x, y))
    draw.line(wave, fill=DEEP_RED, width=max(4, height // 10), joint="curve")
    draw.line(wave, fill=BRIGHT_GOLD, width=max(1, height // 28), joint="curve")

    # Hanging ice points alternate beneath the water line.
    step = max(42, width // 10)
    for index, x in enumerate(range(margin + step // 2, width - margin, step)):
        tip = mid_y + (12 if index % 2 == 0 else 18)
        draw.polygon(
            ((x - 7, mid_y + 2), (x + 7, mid_y + 2), (x, tip)),
            fill=(*CRIMSON, 210),
            outline=BRIGHT_GOLD,
        )

    # A central six-point ice star joins the mirrored currents.
    cx, cy = width // 2, mid_y
    radius = max(11, height // 4)
    for angle in range(0, 180, 30):
        radians = math.radians(angle)
        dx = int(math.cos(radians) * radius)
        dy = int(math.sin(radians) * radius)
        draw.line((cx - dx, cy - dy, cx + dx, cy + dy), fill=BRIGHT_GOLD, width=2)
    draw.ellipse((cx - 4, cy - 4, cx + 4, cy + 4), fill=CRIMSON, outline=BRIGHT_GOLD)

    # Small bubbles keep the motif watery rather than purely crystalline.
    for x, offset in ((width // 5, -10), (width * 4 // 5, -8), (width // 3, -5), (width * 2 // 3, -6)):
        draw.ellipse((x - 3, mid_y + offset - 3, x + 3, mid_y + offset + 3), outline=BRIGHT_GOLD, width=2)

    page.alpha_composite(layer, (center_x - width // 2, center_y - height // 2))


def add_bottom_center_art(page: Image.Image, bottom_art: Image.Image) -> None:
    """Place Aristea's custom water-and-ice flourish above the bottom frame."""

    draw_ice_water_filigree(
        page,
        PAGE_WIDTH // 2,
        BOTTOM_FILIGREE_CENTER_Y,
        440,
        52,
    )


def add_frame(
    page: Image.Image,
    page_number: int,
    corner_art: Image.Image,
    bottom_art: Image.Image,
) -> None:
    draw = ImageDraw.Draw(page)
    draw.rectangle((12, 12, PAGE_WIDTH - 13, PAGE_HEIGHT - 13), outline=BLACK, width=18)
    draw.rectangle((30, 30, PAGE_WIDTH - 31, PAGE_HEIGHT - 31), outline=GOLD, width=5)
    draw.rectangle((43, 43, PAGE_WIDTH - 44, PAGE_HEIGHT - 44), outline=INK, width=3)
    draw.rectangle(
        (55, 55, PAGE_WIDTH - 56, PAGE_HEIGHT - 56),
        outline=(70, 123, 151),
        width=2,
    )

    add_svg_corner_art(page, corner_art)

    # Interior pages retain the established centered campaign plaque. Page 1
    # incorporates the title into its illuminated-manuscript identity header.
    if page_number != 1:
        plaque = (250, 40, PAGE_WIDTH - 250, 128)
        draw.rounded_rectangle(plaque, radius=16, fill=(10, 31, 48), outline=GOLD, width=4)
        title_font = font(FONT_GOTHIC, 46)
        title = "The Arrival"
        box = draw.textbbox((0, 0), title, font=title_font)
        draw.text(
            ((PAGE_WIDTH - (box[2] - box[0])) // 2, 59),
            title,
            fill=BRIGHT_GOLD,
            font=title_font,
        )

    # Bottom-center filigree supplied for this edition.
    add_bottom_center_art(page, bottom_art)
    folio_font = font(FONT_SERIF_BOLD, 26)
    folio = f"{page_number:02d}"
    folio_box = draw.textbbox((0, 0), folio, font=folio_font, stroke_width=2)
    folio_width = folio_box[2] - folio_box[0]
    folio_height = folio_box[3] - folio_box[1]
    draw.text(
        (
            (PAGE_WIDTH - folio_width) // 2 - folio_box[0],
            BOTTOM_FILIGREE_CENTER_Y - folio_height // 2 - folio_box[1],
        ),
        folio,
        fill=BRIGHT_GOLD,
        font=folio_font,
        stroke_width=2,
        stroke_fill=INK,
    )


def draw_first_page_identity_banner(page: Image.Image, page_number: int) -> None:
    """Draw an unboxed illuminated-manuscript identity header."""

    if page_number != 1:
        return

    draw = ImageDraw.Draw(page)
    left, top, right = 78, 48, PAGE_WIDTH - 78
    split = 825

    # The campaign mark and name are printed directly onto the parchment.
    campaign_font = font(FONT_SERIF_BOLD, 24)
    campaign = "THE ARRIVAL"
    campaign_x, campaign_y = left + 48, top + 18
    campaign_box = draw.textbbox((0, 0), campaign, font=campaign_font)
    campaign_width = campaign_box[2] - campaign_box[0]
    draw.text((campaign_x, campaign_y), campaign, font=campaign_font, fill=INK)
    rule_y = campaign_y + 34

    def header_filigree(center_x: int, center_y: int, width: int) -> None:
        draw_ice_water_filigree(
            page,
            center_x,
            center_y,
            width,
            40,
        )

    header_center_x = left + 48 + 325
    header_filigree(header_center_x, rule_y + 2, 610)

    name_font = font(FONT_GOTHIC, 78)
    name_x, name_y = left + 48, top + 82
    draw.text(
        (name_x + 3, name_y + 3),
        "Aristea",
        font=name_font,
        fill=CRIMSON,
        stroke_width=2,
        stroke_fill=CRIMSON,
    )
    draw.text(
        (name_x, name_y),
        "Aristea",
        font=name_font,
        fill=BLACK,
        stroke_width=1,
        stroke_fill=BLACK,
    )
    title_font = font(FONT_SERIF_BOLD, 28)
    title = "THE SILVER TUSK OF NEREUS"
    title_box = draw.textbbox((0, 0), title, font=title_font)
    title_x = name_x + max(0, (650 - (title_box[2] - title_box[0])) // 2)
    draw.text((title_x, top + 185), title, font=title_font, fill=INK)
    header_filigree(name_x + 325, top + 238, 610)
    subtitle_font = font(FONT_SERIF_BOLD, 19)
    draw.text(
        (name_x, top + 275),
        "ISLAND WIZARD  |  DEVOTEE OF NEREUS",
        font=subtitle_font,
        fill=CRIMSON,
    )

    # Right-side fields use quiet manuscript rules rather than boxed form cells.
    label_font = font(FONT_SERIF_BOLD, 18)
    value_font = font(FONT_SERIF, 28)
    small_value_font = font(FONT_SERIF, 23)

    def manuscript_field(
        label_x: int,
        value_x: int,
        x2: int,
        y: int,
        label: str,
        value: str,
        *,
        small: bool = False,
    ) -> None:
        chosen = small_value_font if small else value_font
        size = 23 if small else 28
        available = x2 - value_x
        while draw.textbbox((0, 0), value, font=chosen)[2] > available and size > 16:
            size -= 1
            chosen = font(FONT_SERIF, size)
        draw.text((label_x, y), label.upper(), font=label_font, fill=INK)
        draw.text((value_x, y - 2), value, font=chosen, fill=BLACK)
        draw.line((label_x, y + 35, x2, y + 35), fill=(107, 64, 23), width=2)

    x1 = split + 38
    x_mid = 1450
    x_end = right - 38
    row1 = top + 24
    row_gap = 67

    manuscript_field(x1, x1 + 166, x_mid - 30, row1, "Alignment", "Neutral Good")
    manuscript_field(x_mid, x_mid + 110, x_end, row1, "Player", "-")
    manuscript_field(
        x1,
        x1 + 192,
        x_mid - 30,
        row1 + row_gap,
        "Class & Level",
        "Arcane Trickster 7 / Sorcerer 1 / Conjurer 9",
        small=True,
    )
    manuscript_field(x_mid, x_mid + 100, x_end, row1 + row_gap, "Size", "Huge")
    manuscript_field(x1, x1 + 116, x_mid - 30, row1 + 2 * row_gap, "Deity", "Nereus")
    manuscript_field(x_mid, x_mid + 118, x_end - 175, row1 + 2 * row_gap, "Gender", "Female")
    manuscript_field(x_end - 155, x_end - 92, x_end, row1 + 2 * row_gap, "Age", "24")
    manuscript_field(
        x1,
        x1 + 103,
        x_mid - 30,
        row1 + 3 * row_gap,
        "Race",
        "Mythic Half-Elf Animal Lord (Shoreborn)",
        small=True,
    )
    manuscript_field(x_mid, x_mid + 118, x_end - 175, row1 + 3 * row_gap, "Height", "5' 9\"")
    manuscript_field(x_end - 155, x_end - 70, x_end, row1 + 3 * row_gap, "Eyes", "Blue")
    manuscript_field(x1, x1 + 155, x_mid - 30, row1 + 4 * row_gap, "Homeland", "-")
    manuscript_field(x_mid, x_mid + 123, x_end - 175, row1 + 4 * row_gap, "Weight", "135 lb.")
    manuscript_field(x_end - 155, x_end - 70, x_end, row1 + 4 * row_gap, "Hair", "Silver")


def crop_reference_art(reference: Path) -> tuple[Image.Image, Image.Image]:
    source = Image.open(reference).convert("RGB")
    # Canonical front view and facial portrait from the reference sheet. The
    # tighter full-view crop excludes the printed panel labels.
    full = source.crop((25, 165, 370, 680))
    portrait = source.crop((14, 735, 344, 932))
    return full, portrait


def add_art_watermark(
    page: Image.Image,
    full_art: Image.Image,
    portrait_art: Image.Image,
    page_number: int,
) -> None:
    # Watermarked character art is a cover-page treatment only. Interior pages
    # retain parchment and campaign framing without figure artwork so dense
    # rules text remains as clean as possible.
    if page_number != 1:
        return

    art = full_art
    target_h = 1900
    opacity = STANDARD_WATERMARK_OPACITY
    x = (PAGE_WIDTH - int(target_h * art.width / art.height)) // 2
    y = 380

    target_w = int(target_h * art.width / art.height)
    art = art.resize((target_w, target_h), Image.Resampling.LANCZOS).convert("RGBA")
    alpha = Image.new("L", art.size, opacity)
    # Feather the rectangular panel edges into parchment.
    edge = Image.new("L", art.size, 0)
    ed = ImageDraw.Draw(edge)
    margin = max(28, min(art.size) // 5)
    ed.polygon(
        (
            (art.width * 0.34, margin // 2),
            (art.width * 0.66, margin // 2),
            (art.width * 0.78, art.height * 0.28),
            (art.width * 0.90, art.height * 0.62),
            (art.width - margin // 3, art.height - margin // 3),
            (margin // 3, art.height - margin // 3),
            (art.width * 0.10, art.height * 0.62),
            (art.width * 0.22, art.height * 0.28),
        ),
        fill=255,
    )
    edge = edge.filter(ImageFilter.GaussianBlur(margin))
    alpha = ImageChops.multiply(alpha, edge)
    art.putalpha(alpha)
    page.alpha_composite(art, (x, y))


def content_bbox(image: Image.Image) -> tuple[int, int, int, int]:
    gray = image.convert("L")
    ink_mask = gray.point(lambda value: 255 if value < 247 else 0)
    bbox = ink_mask.getbbox()
    if bbox is None:
        return (0, 0, image.width, image.height)
    left, top, right, bottom = bbox
    padding = max(8, image.width // 170)
    return (
        max(0, left - padding),
        max(0, top - padding),
        min(image.width, right + padding),
        min(image.height, bottom + padding),
    )


def remove_first_page_source_branding(sheet: Image.Image, page_number: int) -> Image.Image:
    """Remove source product logos and the duplicate name from page 1.

    Coordinates are expressed as fractions of the rendered Hero Lab page so
    they remain stable if the PDF rendering resolution changes.
    """

    if page_number != 1:
        return sheet

    cleaned = sheet.copy().convert("RGB")
    draw = ImageDraw.Draw(cleaned)
    width, height = cleaned.size

    def white_box(left: float, top: float, right: float, bottom: float) -> None:
        draw.rectangle(
            (
                int(width * left),
                int(height * top),
                int(width * right),
                int(height * bottom),
            ),
            fill="white",
        )

    # Pathfinder logo and “Character Sheet” product branding.
    # Stop above and to the left of the source HP tab; the previous mask
    # extended a few pixels into that tab and visibly clipped its heading.
    white_box(0.075, 0.025, 0.305, 0.090)
    # Replace the opaque source portrait with the canonical translucent art.
    white_box(0.425, 0.090, 0.825, 0.305)
    # Hero Lab and Pathfinder product logos at the foot of Aristea's first page.
    white_box(0.430, 0.918, 0.835, 0.985)
    return cleaned


def remove_first_page_source_identity(sheet: Image.Image, page_number: int) -> Image.Image:
    """Erase the original identity fields while preserving the established crop."""

    if page_number != 1:
        return sheet

    cleaned = sheet.copy().convert("RGB")
    draw = ImageDraw.Draw(cleaned)
    width, height = cleaned.size
    draw.rectangle(
        (
            int(width * 0.325),
            int(height * 0.028),
            int(width * 0.825),
            int(height * 0.094),
        ),
        fill="white",
    )
    return cleaned


def multiply_sheet_onto_page(
    page: Image.Image,
    sheet: Image.Image,
    page_number: int,
) -> tuple[int, int, int, int]:
    sheet = remove_first_page_source_branding(sheet, page_number)
    bbox = content_bbox(sheet)
    sheet = remove_first_page_source_identity(sheet, page_number)
    content = sheet.crop(bbox).convert("RGB")

    left = 88
    right = PAGE_WIDTH - 88
    top = 360 if page_number == 1 else 150
    bottom = PAGE_HEIGHT - (170 if page_number == 1 else 100)
    available_w = right - left
    available_h = bottom - top

    scale = min(available_w / content.width, available_h / content.height)
    # Avoid comically enlarging a nearly-empty final notes page.
    if content.height < sheet.height * 0.35:
        scale = min(scale, 1.55)
    width = max(1, int(content.width * scale))
    height = max(1, int(content.height * scale))
    content = content.resize((width, height), Image.Resampling.LANCZOS)
    content = ImageEnhance.Contrast(content).enhance(1.06)

    x = (PAGE_WIDTH - width) // 2
    y = top + max(0, (available_h - height) // 2)
    region = page.crop((x, y, x + width, y + height)).convert("RGB")
    # White source paper leaves parchment untouched; ink and colored fields
    # multiply cleanly onto the new background.
    composite = ImageChops.multiply(region, content)
    page.paste(composite, (x, y))
    return (x, y, x + width, y + height)


def multiply_first_page_columns_onto_page(
    page: Image.Image,
    sheet: Image.Image,
) -> tuple[int, int, int, int]:
    """Place Aristea's first-page statistics as two independently scaled columns.

    The Hero Lab source reserves a large central area for its portrait. Scaling
    that entire source as one object makes both information columns needlessly
    small. This layout extracts the left combat column and right skill column,
    enlarges each independently, and aligns their tops beneath the custom
    identity header.
    """

    sheet = remove_first_page_source_branding(sheet, 1)
    sheet = remove_first_page_source_identity(sheet, 1)
    source_w, source_h = sheet.size

    column_specs = (
        (
            (
                int(source_w * 0.045),
                int(source_h * 0.095),
                int(source_w * 0.430),
                int(source_h * 0.705),
            ),
            (82, 500, 958, 2360),
        ),
        (
            (
                int(source_w * 0.430),
                int(source_h * 0.292),
                int(source_w * 0.845),
                int(source_h * 0.918),
            ),
            (1010, 500, PAGE_WIDTH - 82, 2485),
        ),
    )

    placed_boxes: list[tuple[int, int, int, int]] = []
    for crop_box, target_box in column_specs:
        content = sheet.crop(crop_box).convert("RGB")
        content = content.crop(content_bbox(content))

        target_left, target_top, target_right, target_bottom = target_box
        available_w = target_right - target_left
        available_h = target_bottom - target_top
        scale = min(available_w / content.width, available_h / content.height)
        width = max(1, int(content.width * scale))
        height = max(1, int(content.height * scale))
        content = content.resize((width, height), Image.Resampling.LANCZOS)
        content = ImageEnhance.Contrast(content).enhance(1.06)

        x = target_left + max(0, (available_w - width) // 2)
        y = target_top
        region = page.crop((x, y, x + width, y + height)).convert("RGB")
        composite = ImageChops.multiply(region, content)
        page.paste(composite, (x, y))
        placed_boxes.append((x, y, x + width, y + height))

    return (
        min(box[0] for box in placed_boxes),
        min(box[1] for box in placed_boxes),
        max(box[2] for box in placed_boxes),
        max(box[3] for box in placed_boxes),
    )


def repair_first_page_hit_points_header(
    page: Image.Image,
    page_number: int,
) -> None:
    """Replace the source PDF's vertically clipped HP tab on page 1."""

    if page_number != 1:
        return

    draw = ImageDraw.Draw(page)
    left, top, right, bottom = 588, 438, 702, 503
    draw.rectangle((left, top, right, bottom), fill=BLACK)
    hp_font = font(FONT_SERIF_BOLD, 38)
    label_font = font(FONT_SERIF_BOLD, 13)
    hp = "HP"
    hp_box = draw.textbbox((0, 0), hp, font=hp_font)
    draw.text(
        (left + (right - left - (hp_box[2] - hp_box[0])) // 2, top - 2),
        hp,
        fill=(242, 229, 193),
        font=hp_font,
    )
    label = "HIT POINTS"
    label_box = draw.textbbox((0, 0), label, font=label_font)
    draw.text(
        (
            left + (right - left - (label_box[2] - label_box[0])) // 2,
            bottom - 20,
        ),
        label,
        fill=(242, 229, 193),
        font=label_font,
    )


def write_pdf(page_files: list[Path], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(output), pagesize=(LETTER_WIDTH, LETTER_HEIGHT))
    c.setTitle("Aristea - The Arrival Frost-and-Tide Character Sheet")
    c.setAuthor("Hero Lab data, The Arrival campaign presentation")
    c.setSubject("Full-page decorative edition preserving the current character sheet")
    for page_file in page_files:
        c.drawImage(
            ImageReader(str(page_file)),
            0,
            0,
            width=LETTER_WIDTH,
            height=LETTER_HEIGHT,
            preserveAspectRatio=False,
        )
        c.showPage()
    c.save()


def build(
    source_pdf: Path,
    reference_art: Path,
    output_pdf: Path,
    workdir: Path,
    poppler_path: Path,
    large_first_page_layout: bool = False,
) -> None:
    workdir.mkdir(parents=True, exist_ok=True)
    rendered = convert_from_path(
        str(source_pdf),
        dpi=240,
        poppler_path=str(poppler_path),
        fmt="png",
        thread_count=4,
    )
    full_art, portrait_art = crop_reference_art(reference_art)
    corner_art = Image.open(CORNER_ART).convert("RGBA")
    bottom_art = Image.open(BOTTOM_CENTER_ART).convert("RGBA")
    page_files: list[Path] = []
    base_parchment = parchment_texture(PAGE_WIDTH, PAGE_HEIGHT, seed=170317)

    for index, source_page in enumerate(rendered, start=1):
        page = base_parchment.copy()
        if index % 2 == 0:
            page = page.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        page = page.convert("RGBA")
        add_art_watermark(page, full_art, portrait_art, index)
        if index == 1 and large_first_page_layout:
            multiply_first_page_columns_onto_page(page, source_page)
        else:
            multiply_sheet_onto_page(page, source_page, index)
        draw_first_page_identity_banner(page, index)
        add_frame(page, index, corner_art, bottom_art)
        final = page.convert("RGB")
        page_path = workdir / f"styled-{index:02d}.jpg"
        final.save(page_path, quality=94, subsampling=0, optimize=True, dpi=(240, 240))
        page_files.append(page_path)

    write_pdf(page_files, output_pdf)

    # Structural guardrail: the decorative edition must have the same page count.
    if len(PdfReader(str(output_pdf)).pages) != len(PdfReader(str(source_pdf)).pages):
        raise RuntimeError("Output page count does not match source page count")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source_pdf", type=Path)
    parser.add_argument("reference_art", type=Path)
    parser.add_argument("output_pdf", type=Path)
    parser.add_argument(
        "--workdir",
        type=Path,
        default=Path("tmp/pdfs/aristea-sheet-rc1-build"),
    )
    parser.add_argument(
        "--poppler-path",
        type=Path,
        required=True,
        help="Directory containing pdftoppm.exe",
    )
    parser.add_argument(
        "--large-first-page-layout",
        action="store_true",
        help="Enlarge and independently align the two first-page information columns",
    )
    args = parser.parse_args()
    build(
        args.source_pdf,
        args.reference_art,
        args.output_pdf,
        args.workdir,
        args.poppler_path,
        args.large_first_page_layout,
    )


if __name__ == "__main__":
    main()

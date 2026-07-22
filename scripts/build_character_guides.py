from __future__ import annotations

import html
import re
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    Image,
    KeepTogether,
    LongTable,
    PageBreak,
    PageTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
GUIDE_SOURCES = ROOT / "guides"
OUTPUT = ROOT / "output" / "pdf"
WIKI_IMAGES = ROOT / "Demidius-Pathfinder-Codex.wiki" / "images"


GUIDES = [
    {
        "source": GUIDE_SOURCES / "DEMIDIUS_LEVEL_17_25_GUIDE.md",
        "output": OUTPUT / "Demidius_Thorne_Level_17_25_Guide.pdf",
        "image": WIKI_IMAGES / "demidius-reference-sheet.png",
        "title": "Demidius Thorne",
        "subtitle": "Level 17-25 Optimization and Advancement Guide",
        "tagline": "Probability. Magical supremacy. Leadership. Divine ascent.",
        "version": "1.0",
        "primary": colors.HexColor("#4A1838"),
        "secondary": colors.HexColor("#9C6B2F"),
        "pale": colors.HexColor("#F5ECEF"),
    },
    {
        "source": GUIDE_SOURCES / "ARISTEA_LEVEL_17_25_GUIDE.md",
        "output": OUTPUT / "Aristea_Level_17_25_Guide.pdf",
        "image": WIKI_IMAGES / "aristea-reference-sheet.png",
        "title": "Aristea of the Shifting Tides",
        "subtitle": "Level 17-25 Optimization and Advancement Guide",
        "tagline": "Tide. Frost. Form. Arcane craftsmanship.",
        "version": "2.0",
        "primary": colors.HexColor("#163F59"),
        "secondary": colors.HexColor("#3E8B9A"),
        "pale": colors.HexColor("#EAF4F5"),
    },
]


def inline(text: str) -> str:
    text = html.escape(text.strip())
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"\*(.+?)\*", r"<i>\1</i>", text)
    text = re.sub(r"`(.+?)`", r'<font name="Courier">\1</font>', text)
    return text


def fit_image(path: Path, max_w: float, max_h: float) -> Image:
    img = Image(str(path))
    scale = min(max_w / img.imageWidth, max_h / img.imageHeight)
    img.drawWidth = img.imageWidth * scale
    img.drawHeight = img.imageHeight * scale
    return img


def make_styles(primary, secondary):
    base = getSampleStyleSheet()
    return {
        "body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9.25,
            leading=13.2,
            textColor=colors.HexColor("#20242A"),
            spaceAfter=6,
        ),
        "h1": ParagraphStyle(
            "H1",
            parent=base["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=18,
            leading=21,
            textColor=primary,
            spaceBefore=14,
            spaceAfter=8,
            keepWithNext=True,
        ),
        "h2": ParagraphStyle(
            "H2",
            parent=base["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=13.5,
            leading=16,
            textColor=primary,
            spaceBefore=11,
            spaceAfter=6,
            keepWithNext=True,
        ),
        "h3": ParagraphStyle(
            "H3",
            parent=base["Heading3"],
            fontName="Helvetica-Bold",
            fontSize=10.5,
            leading=13,
            textColor=secondary,
            spaceBefore=8,
            spaceAfter=4,
            keepWithNext=True,
        ),
        "bullet": ParagraphStyle(
            "Bullet",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9,
            leading=12.5,
            leftIndent=16,
            firstLineIndent=-8,
            bulletIndent=7,
            spaceAfter=3,
        ),
        "small": ParagraphStyle(
            "Small",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=7.4,
            leading=9.4,
            textColor=colors.HexColor("#30343A"),
        ),
        "small_bold": ParagraphStyle(
            "SmallBold",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=7.5,
            leading=9.5,
            textColor=colors.white,
            alignment=TA_CENTER,
        ),
        "callout": ParagraphStyle(
            "Callout",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=10,
            leading=14,
            textColor=primary,
            leftIndent=8,
            rightIndent=8,
            spaceAfter=0,
        ),
    }


def table_widths(cols: int, available: float):
    patterns = {
        2: [0.28, 0.72],
        3: [0.18, 0.30, 0.52],
        4: [0.12, 0.22, 0.24, 0.42],
        5: [0.09, 0.17, 0.18, 0.28, 0.28],
    }
    ratios = patterns.get(cols, [1 / cols] * cols)
    return [available * r for r in ratios]


def parse_markdown(path: Path, styles, primary, secondary, pale, available):
    lines = path.read_text(encoding="utf-8").splitlines()
    story = []
    i = 0
    # Cover headings are rendered separately.
    while i < len(lines) and (not lines[i].strip() or lines[i].startswith("#") or lines[i].startswith("Version")):
        i += 1

    while i < len(lines):
        raw = lines[i].rstrip()
        stripped = raw.strip()
        if not stripped:
            i += 1
            continue
        if stripped.startswith("## "):
            story.append(Paragraph(inline(stripped[3:]), styles["h1"]))
            i += 1
            continue
        if stripped.startswith("### "):
            story.append(Paragraph(inline(stripped[4:]), styles["h2"]))
            i += 1
            continue
        if stripped.startswith("#### "):
            story.append(Paragraph(inline(stripped[5:]), styles["h3"]))
            i += 1
            continue
        if stripped.startswith("|"):
            table_lines = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                table_lines.append(lines[i].strip())
                i += 1
            rows = []
            for line in table_lines:
                cells = [c.strip() for c in line.strip("|").split("|")]
                if all(re.fullmatch(r":?-{3,}:?", c) for c in cells):
                    continue
                rows.append(cells)
            if rows:
                cols = len(rows[0])
                data = []
                for r_index, row in enumerate(rows):
                    style = styles["small_bold"] if r_index == 0 else styles["small"]
                    data.append([Paragraph(inline(cell), style) for cell in row])
                table = LongTable(
                    data,
                    colWidths=table_widths(cols, available),
                    repeatRows=1,
                    hAlign="LEFT",
                    splitByRow=1,
                    splitInRow=1,
                )
                table.setStyle(
                    TableStyle(
                        [
                            ("BACKGROUND", (0, 0), (-1, 0), primary),
                            ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                            ("BACKGROUND", (0, 1), (-1, -1), colors.white),
                            ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, pale]),
                            ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#A9ADB2")),
                            ("VALIGN", (0, 0), (-1, -1), "TOP"),
                            ("LEFTPADDING", (0, 0), (-1, -1), 4),
                            ("RIGHTPADDING", (0, 0), (-1, -1), 4),
                            ("TOPPADDING", (0, 0), (-1, -1), 4),
                            ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                        ]
                    )
                )
                story.extend([table, Spacer(1, 7)])
            continue
        if re.match(r"^\d+\.\s+", stripped):
            m = re.match(r"^(\d+)\.\s+(.*)$", stripped)
            story.append(Paragraph(inline(m.group(2)), styles["bullet"], bulletText=f"{m.group(1)}."))
            i += 1
            continue
        if stripped.startswith("- "):
            story.append(Paragraph(inline(stripped[2:]), styles["bullet"], bulletText="-"))
            i += 1
            continue
        if stripped.startswith("> "):
            box = Table([[Paragraph(inline(stripped[2:]), styles["callout"])]], colWidths=[available])
            box.setStyle(
                TableStyle(
                    [
                        ("BACKGROUND", (0, 0), (-1, -1), pale),
                        ("BOX", (0, 0), (-1, -1), 1, secondary),
                        ("LEFTPADDING", (0, 0), (-1, -1), 8),
                        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                        ("TOPPADDING", (0, 0), (-1, -1), 7),
                        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
                    ]
                )
            )
            story.extend([box, Spacer(1, 7)])
            i += 1
            continue
        para = [stripped]
        i += 1
        while i < len(lines):
            nxt = lines[i].strip()
            if not nxt:
                i += 1
                break
            if nxt.startswith(("#", "|", "- ", "> ")) or re.match(r"^\d+\.\s+", nxt):
                break
            para.append(nxt)
            i += 1
        story.append(Paragraph(inline(" ".join(para)), styles["body"]))
    return story


def build_guide(spec):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    page_w, page_h = letter
    left = right = 0.62 * inch
    top = 0.62 * inch
    bottom = 0.55 * inch
    frame = Frame(left, bottom, page_w - left - right, page_h - top - bottom, id="normal")

    def decorate(canvas, doc):
        canvas.saveState()
        canvas.setFillColor(spec["primary"])
        canvas.rect(0, page_h - 0.34 * inch, page_w, 0.34 * inch, stroke=0, fill=1)
        canvas.setFillColor(colors.HexColor("#F8F5EF"))
        canvas.setFont("Helvetica-Bold", 8)
        canvas.drawString(left, page_h - 0.22 * inch, spec["title"])
        canvas.setFont("Helvetica", 8)
        canvas.drawRightString(page_w - right, page_h - 0.22 * inch, f"Level 17-25 Guide  |  {doc.page}")
        canvas.setStrokeColor(spec["secondary"])
        canvas.setLineWidth(0.7)
        canvas.line(left, 0.38 * inch, page_w - right, 0.38 * inch)
        canvas.setFillColor(colors.HexColor("#555B62"))
        canvas.setFont("Helvetica", 6.7)
        canvas.drawString(left, 0.20 * inch, "Campaign-specific recommendations - verify unresolved choices with the GM")
        canvas.restoreState()

    doc = BaseDocTemplate(
        str(spec["output"]),
        pagesize=letter,
        leftMargin=left,
        rightMargin=right,
        topMargin=top,
        bottomMargin=bottom,
        title=f'{spec["title"]}: {spec["subtitle"]}',
        author="Demidius Pathfinder Research Codex",
        subject="Pathfinder 1e character advancement and optimization",
        allowSplitting=1,
    )
    doc.addPageTemplates([PageTemplate(id="guide", frames=[frame], onPage=decorate)])
    styles = make_styles(spec["primary"], spec["secondary"])
    available = page_w - left - right

    cover_title = ParagraphStyle(
        "CoverTitle",
        fontName="Helvetica-Bold",
        fontSize=26,
        leading=29,
        alignment=TA_CENTER,
        textColor=spec["primary"],
        spaceAfter=8,
    )
    cover_subtitle = ParagraphStyle(
        "CoverSubtitle",
        fontName="Helvetica",
        fontSize=14,
        leading=17,
        alignment=TA_CENTER,
        textColor=spec["secondary"],
        spaceAfter=10,
    )
    cover_tag = ParagraphStyle(
        "CoverTag",
        fontName="Helvetica-Oblique",
        fontSize=10,
        leading=13,
        alignment=TA_CENTER,
        textColor=colors.HexColor("#41464C"),
    )

    story = [Spacer(1, 0.32 * inch)]
    story.append(Paragraph(spec["title"], cover_title))
    story.append(Paragraph(spec["subtitle"], cover_subtitle))
    story.append(Spacer(1, 0.12 * inch))
    story.append(fit_image(spec["image"], available, 4.65 * inch))
    story.append(Spacer(1, 0.18 * inch))
    tag_box = Table([[Paragraph(spec["tagline"], cover_tag)]], colWidths=[available * 0.78], hAlign="CENTER")
    tag_box.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), spec["pale"]),
                ("BOX", (0, 0), (-1, -1), 1.1, spec["secondary"]),
                ("TOPPADDING", (0, 0), (-1, -1), 9),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 9),
            ]
        )
    )
    story.append(tag_box)
    story.append(Spacer(1, 0.18 * inch))
    story.append(Paragraph(f"Version {spec['version']}  |  22 July 2026", cover_tag))
    story.append(PageBreak())
    story.extend(parse_markdown(spec["source"], styles, spec["primary"], spec["secondary"], spec["pale"], available))
    doc.build(story)


if __name__ == "__main__":
    for guide in GUIDES:
        build_guide(guide)
        print(guide["output"])

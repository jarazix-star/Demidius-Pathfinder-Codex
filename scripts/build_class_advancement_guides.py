from __future__ import annotations

import re
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    HRFlowable,
    LongTable,
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "output" / "pdf"

GUIDES = [
    {
        "source": ROOT / "guides" / "DEMIDIUS_LEVEL_17_35_CLASS_ADVANCEMENT_GUIDE.md",
        "output": OUTPUT / "Demidius_Level_17_35_Class_Advancement_Guide.pdf",
        "name": "Demidius Thorne",
        "subtitle": "Class advancement and prestige-class analysis, levels 17-35",
        "count": "Eighteen prestige classes ranked and analyzed",
        "accent": colors.HexColor("#8C2633"),
        "dark": colors.HexColor("#24161A"),
        "pale": colors.HexColor("#F5E9E7"),
        "gold": colors.HexColor("#C99A3D"),
    },
    {
        "source": ROOT / "guides" / "ARISTEA_LEVEL_17_35_CLASS_ADVANCEMENT_GUIDE.md",
        "output": OUTPUT / "Aristea_Level_17_35_Class_Advancement_Guide.pdf",
        "name": "Aristea",
        "subtitle": "Class advancement and prestige-class analysis, levels 17-35",
        "count": "Twenty-one prestige classes ranked and analyzed",
        "accent": colors.HexColor("#167D8D"),
        "dark": colors.HexColor("#122A38"),
        "pale": colors.HexColor("#E6F4F5"),
        "gold": colors.HexColor("#89C7CF"),
    },
]


def markup(text: str) -> str:
    text = escape(text.strip())
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"\*(.+?)\*", r"<i>\1</i>", text)
    return text


def grade_color(grade: str):
    if grade.startswith("S"):
        return colors.HexColor("#D8B44A")
    if grade.startswith("A"):
        return colors.HexColor("#B7DDB9")
    if grade.startswith("B"):
        return colors.HexColor("#D8E8F4")
    if grade.startswith("C"):
        return colors.HexColor("#F1E6C9")
    if grade.startswith("D"):
        return colors.HexColor("#F3CCB3")
    if grade.startswith("F"):
        return colors.HexColor("#E7AAAA")
    return colors.white


def styles_for(theme):
    base = getSampleStyleSheet()
    return {
        "cover_name": ParagraphStyle(
            "CoverName",
            parent=base["Title"],
            fontName="Helvetica-Bold",
            fontSize=28,
            leading=33,
            alignment=TA_CENTER,
            textColor=theme["dark"],
            spaceAfter=12,
        ),
        "cover_subtitle": ParagraphStyle(
            "CoverSubtitle",
            parent=base["Normal"],
            fontSize=14,
            leading=19,
            alignment=TA_CENTER,
            textColor=theme["accent"],
        ),
        "h2": ParagraphStyle(
            "H2",
            parent=base["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=14,
            leading=17,
            textColor=theme["accent"],
            spaceBefore=12,
            spaceAfter=7,
            keepWithNext=True,
        ),
        "h3": ParagraphStyle(
            "H3",
            parent=base["Heading3"],
            fontName="Helvetica-Bold",
            fontSize=10.5,
            leading=13,
            textColor=theme["dark"],
            spaceBefore=9,
            spaceAfter=4,
            keepWithNext=True,
        ),
        "body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9.1,
            leading=12.5,
            textColor=colors.HexColor("#222222"),
            spaceAfter=6,
        ),
        "bullet": ParagraphStyle(
            "Bullet",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=8.8,
            leading=12,
            leftIndent=16,
            firstLineIndent=-9,
            bulletIndent=5,
            spaceAfter=3,
        ),
        "table_head": ParagraphStyle(
            "TableHead",
            parent=base["Normal"],
            fontName="Helvetica-Bold",
            fontSize=6.8,
            leading=8.1,
            alignment=TA_LEFT,
            textColor=colors.white,
        ),
        "table_cell": ParagraphStyle(
            "TableCell",
            parent=base["Normal"],
            fontName="Helvetica",
            fontSize=6.8,
            leading=8.2,
            textColor=colors.HexColor("#1B1B1B"),
        ),
        "table_center": ParagraphStyle(
            "TableCenter",
            parent=base["Normal"],
            fontName="Helvetica-Bold",
            fontSize=7.4,
            leading=8.4,
            alignment=TA_CENTER,
            textColor=theme["dark"],
        ),
        "callout": ParagraphStyle(
            "Callout",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=10,
            leading=14,
            alignment=TA_CENTER,
            textColor=theme["dark"],
        ),
    }


def page_decor(canvas, doc, theme):
    canvas.saveState()
    width, _ = letter
    canvas.setStrokeColor(theme["accent"])
    canvas.setLineWidth(0.7)
    canvas.line(doc.leftMargin, 0.54 * inch, width - doc.rightMargin, 0.54 * inch)
    canvas.setFont("Helvetica", 7.5)
    canvas.setFillColor(colors.HexColor("#555555"))
    canvas.drawString(doc.leftMargin, 0.34 * inch, f"{theme['name']} - Level 17-35 advancement")
    canvas.drawRightString(width - doc.rightMargin, 0.34 * inch, f"Page {doc.page}")
    canvas.restoreState()


def cover(story, theme, styles):
    story.extend(
        [
            Spacer(1, 1.2 * inch),
            HRFlowable(width="62%", thickness=2, color=theme["gold"], hAlign="CENTER", spaceAfter=28),
            Paragraph(markup(theme["name"]), styles["cover_name"]),
            Paragraph(markup(theme["subtitle"]), styles["cover_subtitle"]),
            Spacer(1, 0.38 * inch),
            Table(
                [[Paragraph(markup(theme["count"]), styles["callout"])]],
                colWidths=[5.35 * inch],
                style=TableStyle(
                    [
                        ("BACKGROUND", (0, 0), (-1, -1), theme["pale"]),
                        ("BOX", (0, 0), (-1, -1), 1, theme["accent"]),
                        ("LEFTPADDING", (0, 0), (-1, -1), 18),
                        ("RIGHTPADDING", (0, 0), (-1, -1), 18),
                        ("TOPPADDING", (0, 0), (-1, -1), 16),
                        ("BOTTOMPADDING", (0, 0), (-1, -1), 16),
                    ]
                ),
            ),
            Spacer(1, 2.1 * inch),
            Paragraph(
                "Prepared from the current character record, campaign rulings, and verified Pathfinder prestige-class text. "
                "Conditional epic options are separated from printed-rule fallbacks.",
                ParagraphStyle("CoverNote", parent=styles["body"], alignment=TA_CENTER, textColor=colors.HexColor("#555555")),
            ),
            PageBreak(),
        ]
    )


def parse_table(lines, start):
    rows = []
    i = start
    while i < len(lines) and lines[i].lstrip().startswith("|"):
        cells = [cell.strip() for cell in lines[i].strip().strip("|").split("|")]
        if not all(re.fullmatch(r":?-+:?", cell) for cell in cells):
            rows.append(cells)
        i += 1
    return rows, i


def table_flowable(rows, theme, styles):
    header = rows[0]
    is_ranked = header[0].lower() == "rank"
    converted = []
    for row_number, row in enumerate(rows):
        if row_number == 0:
            converted.append([Paragraph(markup(cell), styles["table_head"]) for cell in row])
        else:
            cells = []
            for column, cell in enumerate(row):
                style = styles["table_center"] if column < 2 else styles["table_cell"]
                cells.append(Paragraph(markup(cell), style))
            converted.append(cells)
    if is_ranked:
        widths = [0.38 * inch, 0.43 * inch, 1.35 * inch, 1.18 * inch, 3.66 * inch]
    else:
        widths = [0.43 * inch, 1.25 * inch, 1.15 * inch, 1.25 * inch, 2.92 * inch]
    table = LongTable(converted, colWidths=widths, repeatRows=1, hAlign="LEFT")
    commands = [
        ("BACKGROUND", (0, 0), (-1, 0), theme["dark"]),
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#B9B9B9")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]
    for index, row in enumerate(rows[1:], start=1):
        commands.append(("BACKGROUND", (0, index), (-1, index), colors.white if index % 2 else theme["pale"]))
        if is_ranked:
            commands.append(("BACKGROUND", (1, index), (1, index), grade_color(row[1])))
    table.setStyle(TableStyle(commands))
    return table


def markdown_story(path, theme, styles):
    lines = path.read_text(encoding="utf-8").splitlines()
    story = []
    i = 1
    page_break_headings = {
        "Recommended level-by-level path",
        "Ranked prestige-class summary",
        "In-depth prestige-class analysis",
        "Conservative fallback: no epic aligned-class advancement",
        "Confirmed Evangelist progression",
        "Epic Arcane Trickster proposal",
        "Confirmed Evangelist extension",
        "Source links",
    }
    while i < len(lines):
        line = lines[i].strip()
        if not line:
            i += 1
            continue
        if line.startswith("## "):
            heading = line[3:].strip()
            if heading in page_break_headings and story:
                story.append(PageBreak())
            story.append(Paragraph(markup(heading), styles["h2"]))
            i += 1
            continue
        if line.startswith("### "):
            story.append(Paragraph(markup(line[4:]), styles["h3"]))
            i += 1
            continue
        if line.startswith("|"):
            rows, i = parse_table(lines, i)
            story.append(table_flowable(rows, theme, styles))
            story.append(Spacer(1, 8))
            continue
        numbered = re.match(r"^(\d+)\.\s+(.*)", line)
        if numbered:
            story.append(Paragraph(markup(numbered.group(2)), styles["bullet"], bulletText=f"{numbered.group(1)}."))
            i += 1
            continue
        if line.startswith("- "):
            story.append(Paragraph(markup(line[2:]), styles["bullet"], bulletText="-"))
            i += 1
            continue
        paragraph = [line]
        i += 1
        while i < len(lines):
            next_line = lines[i].strip()
            if not next_line or next_line.startswith(("#", "|", "- ")) or re.match(r"^\d+\.\s+", next_line):
                break
            paragraph.append(next_line)
            i += 1
        story.append(Paragraph(markup(" ".join(paragraph)), styles["body"]))
    return story


def build(theme):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    styles = styles_for(theme)
    story = []
    cover(story, theme, styles)
    story.extend(markdown_story(theme["source"], theme, styles))
    document = SimpleDocTemplate(
        str(theme["output"]),
        pagesize=letter,
        rightMargin=0.5 * inch,
        leftMargin=0.5 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.68 * inch,
        title=f"{theme['name']} - Level 17-35 Class Advancement Guide",
        author="Demidius Pathfinder Codex",
        subject="Class advancement and ranked prestige-class analysis",
    )
    document.build(
        story,
        onFirstPage=lambda canvas, doc: page_decor(canvas, doc, theme),
        onLaterPages=lambda canvas, doc: page_decor(canvas, doc, theme),
    )
    print(theme["output"])


if __name__ == "__main__":
    for guide in GUIDES:
        build(guide)

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
    KeepTogether,
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
        "source": ROOT / "guides" / "DEMIDIUS_MYTHIC_FEATS_AND_ABILITIES_GUIDE.md",
        "output": OUTPUT / "Demidius_Ranked_Mythic_Feats_and_Abilities_Guide.pdf",
        "name": "Demidius Thorne",
        "subtitle": "Ranked mythic feats and path abilities",
        "accent": colors.HexColor("#8C2633"),
        "dark": colors.HexColor("#24161A"),
        "pale": colors.HexColor("#F5E9E7"),
        "gold": colors.HexColor("#C99A3D"),
    },
    {
        "source": ROOT / "guides" / "ARISTEA_MYTHIC_FEATS_AND_ABILITIES_GUIDE.md",
        "output": OUTPUT / "Aristea_Ranked_Mythic_Feats_and_Abilities_Guide.pdf",
        "name": "Aristea",
        "subtitle": "Ranked mythic feats and path abilities",
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


def parse_table(lines: list[str], start: int) -> tuple[list[list[str]], int]:
    rows = []
    i = start
    while i < len(lines) and lines[i].lstrip().startswith("|"):
        cells = [cell.strip() for cell in lines[i].strip().strip("|").split("|")]
        if not all(re.fullmatch(r":?-+:?", cell) for cell in cells):
            rows.append(cells)
        i += 1
    return rows, i


def build_styles(theme):
    base = getSampleStyleSheet()
    return {
        "cover_name": ParagraphStyle(
            "CoverName",
            parent=base["Title"],
            fontName="Helvetica-Bold",
            fontSize=29,
            leading=33,
            alignment=TA_CENTER,
            textColor=theme["dark"],
            spaceAfter=12,
        ),
        "cover_subtitle": ParagraphStyle(
            "CoverSubtitle",
            parent=base["Normal"],
            fontName="Helvetica",
            fontSize=15,
            leading=20,
            alignment=TA_CENTER,
            textColor=theme["accent"],
        ),
        "h1": ParagraphStyle(
            "H1",
            parent=base["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=20,
            leading=24,
            textColor=theme["dark"],
            spaceBefore=8,
            spaceAfter=10,
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
            spaceBefore=8,
            spaceAfter=4,
            keepWithNext=True,
        ),
        "body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9.1,
            leading=12.4,
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
            fontSize=7.1,
            leading=8.4,
            alignment=TA_LEFT,
            textColor=colors.white,
        ),
        "table_cell": ParagraphStyle(
            "TableCell",
            parent=base["Normal"],
            fontName="Helvetica",
            fontSize=7.05,
            leading=8.5,
            textColor=colors.HexColor("#1B1B1B"),
        ),
        "table_rank": ParagraphStyle(
            "TableRank",
            parent=base["Normal"],
            fontName="Helvetica-Bold",
            fontSize=8,
            leading=9,
            alignment=TA_CENTER,
            textColor=theme["dark"],
        ),
        "table_grade": ParagraphStyle(
            "TableGrade",
            parent=base["Normal"],
            fontName="Helvetica-Bold",
            fontSize=8,
            leading=9,
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


def page_decor(canvas, doc, theme, name):
    canvas.saveState()
    width, height = letter
    canvas.setStrokeColor(theme["accent"])
    canvas.setLineWidth(0.7)
    canvas.line(doc.leftMargin, 0.54 * inch, width - doc.rightMargin, 0.54 * inch)
    canvas.setFont("Helvetica", 7.5)
    canvas.setFillColor(colors.HexColor("#555555"))
    canvas.drawString(doc.leftMargin, 0.34 * inch, f"{name} - Mythic option guide")
    canvas.drawRightString(width - doc.rightMargin, 0.34 * inch, f"Page {doc.page}")
    canvas.restoreState()


def cover_page(story, theme, styles):
    story.extend(
        [
            Spacer(1, 1.25 * inch),
            HRFlowable(
                width="62%",
                thickness=2,
                color=theme["gold"],
                hAlign="CENTER",
                spaceAfter=28,
            ),
            Paragraph(markup(theme["name"]), styles["cover_name"]),
            Paragraph(markup(theme["subtitle"]), styles["cover_subtitle"]),
            Spacer(1, 0.38 * inch),
            Table(
                [[Paragraph(
                    "Thirty-six ranked mythic path abilities and thirty-six ranked mythic feats, "
                    "evaluated for the current character and campaign rules.",
                    styles["callout"],
                )]],
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
            Spacer(1, 2.2 * inch),
            Paragraph(
                "Prepared from the current character sheet, local campaign rulings, "
                "Paizo Mythic Adventures, and the approved local third-party research corpus.",
                ParagraphStyle(
                    "CoverNote",
                    parent=styles["body"],
                    alignment=TA_CENTER,
                    textColor=colors.HexColor("#555555"),
                ),
            ),
            PageBreak(),
        ]
    )


def table_flowable(rows, theme, styles):
    converted = []
    for row_index, row in enumerate(rows):
        if row_index == 0:
            converted.append([Paragraph(markup(cell), styles["table_head"]) for cell in row])
        else:
            converted.append(
                [
                    Paragraph(markup(row[0]), styles["table_rank"]),
                    Paragraph(markup(row[1]), styles["table_grade"]),
                    Paragraph(markup(row[2]), styles["table_cell"]),
                    Paragraph(markup(row[3]), styles["table_cell"]),
                    Paragraph(markup(row[4]), styles["table_cell"]),
                ]
            )
    widths = [0.43 * inch, 0.45 * inch, 1.34 * inch, 1.34 * inch, 3.44 * inch]
    table = LongTable(converted, colWidths=widths, repeatRows=1, hAlign="LEFT")
    style = [
        ("BACKGROUND", (0, 0), (-1, 0), theme["dark"]),
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#B9B9B9")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]
    for index, row in enumerate(rows[1:], start=1):
        style.append(("BACKGROUND", (0, index), (-1, index), colors.white if index % 2 else theme["pale"]))
        style.append(("BACKGROUND", (1, index), (1, index), grade_color(row[1])))
    table.setStyle(TableStyle(style))
    return table


def markdown_story(source: Path, theme, styles):
    lines = source.read_text(encoding="utf-8").splitlines()
    story = []
    i = 1  # H1 is represented by the cover.
    major_rank_sections = {"Ranked mythic path and universal abilities", "Ranked mythic feats"}
    while i < len(lines):
        line = lines[i].strip()
        if not line:
            i += 1
            continue
        if line.startswith("## "):
            heading = line[3:].strip()
            if heading in major_rank_sections:
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
        if re.match(r"^\d+\.\s+", line):
            text = re.sub(r"^\d+\.\s+", "", line)
            number = line.split(".", 1)[0]
            story.append(Paragraph(markup(text), styles["bullet"], bulletText=f"{number}."))
            i += 1
            continue
        if line.startswith("- "):
            story.append(Paragraph(markup(line[2:]), styles["bullet"], bulletText="-"))
            i += 1
            continue
        paragraph = [line]
        i += 1
        while i < len(lines):
            nxt = lines[i].strip()
            if not nxt or nxt.startswith(("#", "|", "- ")) or re.match(r"^\d+\.\s+", nxt):
                break
            paragraph.append(nxt)
            i += 1
        story.append(Paragraph(markup(" ".join(paragraph)), styles["body"]))
    return story


def build(theme):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    styles = build_styles(theme)
    story = []
    cover_page(story, theme, styles)
    story.extend(markdown_story(theme["source"], theme, styles))
    document = SimpleDocTemplate(
        str(theme["output"]),
        pagesize=letter,
        rightMargin=0.5 * inch,
        leftMargin=0.5 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.68 * inch,
        title=f"{theme['name']} - Mythic Feats and Abilities Guide",
        author="Demidius Pathfinder Codex",
        subject="Ranked mythic feats and mythic path abilities",
    )
    document.build(
        story,
        onFirstPage=lambda canvas, doc: page_decor(canvas, doc, theme, theme["name"]),
        onLaterPages=lambda canvas, doc: page_decor(canvas, doc, theme, theme["name"]),
    )
    print(theme["output"])


if __name__ == "__main__":
    for guide in GUIDES:
        build(guide)

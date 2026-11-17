from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import html

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "documentation"
W, H = 1800, 820
navy, blue, ink, pale = "#10243A", "#1677C8", "#24384B", "#F2F7FB"
font_path = "C:/Windows/Fonts/segoeui.ttf"
bold_path = "C:/Windows/Fonts/segoeuib.ttf"
title_font = ImageFont.truetype(bold_path, 34)
head_font = ImageFont.truetype(bold_path, 28)
body_font = ImageFont.truetype(font_path, 23)
small_font = ImageFont.truetype(font_path, 20)

entities = {
    "ETUDIANT": (70, 160, 515, 565, ["PK  id BIGINT", "nom VARCHAR(100) NOT NULL", "UK  email VARCHAR(120)", "mot_de_passe VARCHAR(60)", "role CHECK ETUDIANT | GESTIONNAIRE"]),
    "INSCRIPTION": (680, 160, 1120, 565, ["PK  id BIGINT", "FK  etudiant_id → Etudiant", "FK  atelier_id → Atelier", "date_inscription TIMESTAMP", "statut CHECK CONFIRMEE | ANNULEE", "UK  (etudiant_id, atelier_id)"]),
    "ATELIER": (1285, 160, 1730, 565, ["PK  id BIGINT", "titre VARCHAR(180) NOT NULL", "description VARCHAR(4000)", "date_heure TIMESTAMP NOT NULL", "capacite CHECK > 0"]),
}

im = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(im)
d.text((70, 42), "Modèle relationnel AtelierCampus", font=title_font, fill=navy)

for name, (x1, y1, x2, y2, fields) in entities.items():
    d.rounded_rectangle((x1, y1, x2, y2), radius=18, fill=pale, outline=navy, width=4)
    d.rounded_rectangle((x1, y1, x2, y1+60), radius=18, fill=navy)
    d.rectangle((x1, y1+35, x2, y1+60), fill=navy)
    d.text((x1+20, y1+10), name, font=head_font, fill="white")
    yy = y1 + 83
    for field in fields:
        d.text((x1+20, yy), field, font=small_font if len(field) > 31 else body_font, fill=ink)
        yy += 51

# Each inscription references exactly one student and one workshop; either parent can have many inscriptions.
mid_y = 360
d.line((515, mid_y, 680, mid_y), fill=blue, width=5)
d.line((1120, mid_y, 1285, mid_y), fill=blue, width=5)
# One marker on each parent side and crow's feet on the many-side (Inscription).
d.line((515, mid_y-18, 515, mid_y+18), fill=blue, width=4)
d.line((680, mid_y, 662, mid_y-13), fill=blue, width=4)
d.line((680, mid_y, 662, mid_y+13), fill=blue, width=4)
d.line((1120, mid_y, 1138, mid_y-13), fill=blue, width=4)
d.line((1120, mid_y, 1138, mid_y+13), fill=blue, width=4)
d.line((1285, mid_y-18, 1285, mid_y+18), fill=blue, width=4)
d.text((555, mid_y-42), "1", font=body_font, fill=navy)
d.text((635, mid_y-42), "0..N", font=body_font, fill=navy)
d.text((1158, mid_y-42), "0..N", font=body_font, fill=navy)
d.text((1240, mid_y-42), "1", font=body_font, fill=navy)
d.text((70, 625), "Contraintes : clés étrangères · unicité étudiant/atelier · suppression atelier refusée si confirmations existantes.", font=body_font, fill=ink)
d.text((70, 680), "Légende : PK clé primaire · FK clé étrangère · UK contrainte UNIQUE.", font=small_font, fill="#53687A")
im.save(OUT / "erd_ateliercampus.png", optimize=True)

svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
       '<rect width="100%" height="100%" fill="white"/>',
       f'<text x="70" y="85" font-family="Segoe UI, sans-serif" font-size="34" font-weight="700" fill="{navy}">Modèle relationnel AtelierCampus</text>']
for name, (x1, y1, x2, y2, fields) in entities.items():
    svg.extend([f'<rect x="{x1}" y="{y1}" width="{x2-x1}" height="{y2-y1}" rx="18" fill="{pale}" stroke="{navy}" stroke-width="4"/>',
                f'<path d="M{x1+18} {y1} H{x2-18} Q{x2} {y1} {x2} {y1+18} V{y1+60} H{x1} V{y1+18} Q{x1} {y1} {x1+18} {y1}Z" fill="{navy}"/>',
                f'<text x="{x1+20}" y="{y1+40}" font-family="Segoe UI, sans-serif" font-size="28" font-weight="700" fill="white">{html.escape(name)}</text>'])
    for i, field in enumerate(fields):
        svg.append(f'<text x="{x1+20}" y="{y1+108+i*51}" font-family="Segoe UI, sans-serif" font-size="21" fill="{ink}">{html.escape(field)}</text>')
svg.extend([f'<path d="M515 360 H680 M1120 360 H1285" stroke="{blue}" stroke-width="5" fill="none"/>',
            f'<path d="M515 342 V378 M662 347 L680 360 L662 373 M1138 347 L1120 360 L1138 373 M1285 342 V378" stroke="{blue}" stroke-width="4" fill="none"/>',
            f'<text x="555" y="318" font-family="Segoe UI" font-size="23" fill="{navy}">1</text><text x="635" y="318" font-family="Segoe UI" font-size="23" fill="{navy}">0..N</text>',
            f'<text x="1158" y="318" font-family="Segoe UI" font-size="23" fill="{navy}">0..N</text><text x="1240" y="318" font-family="Segoe UI" font-size="23" fill="{navy}">1</text>',
            f'<text x="70" y="660" font-family="Segoe UI" font-size="23" fill="{ink}">Contraintes : clés étrangères · unicité étudiant/atelier · suppression atelier refusée si confirmations existantes.</text>',
            '<text x="70" y="710" font-family="Segoe UI" font-size="20" fill="#53687A">Légende : PK clé primaire · FK clé étrangère · UK contrainte UNIQUE.</text>', '</svg>'])
(OUT / "erd_ateliercampus.svg").write_text("\n".join(svg), encoding="utf-8")
print(OUT / "erd_ateliercampus.png")

from pathlib import Path
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_CELL_VERTICAL_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'rapport'/'Rapport_Partie_2_AtelierCampus.docx'
D=Document()
sec=D.sections[0]
sec.top_margin=Inches(.62); sec.bottom_margin=Inches(.62); sec.left_margin=Inches(.72); sec.right_margin=Inches(.72)
sec.header_distance=Inches(.28); sec.footer_distance=Inches(.3)
styles=D.styles
styles['Normal'].font.name='Aptos'; styles['Normal'].font.size=Pt(9.4); styles['Normal'].font.color.rgb=RGBColor(34,48,64)
styles['Normal'].paragraph_format.space_after=Pt(5); styles['Normal'].paragraph_format.line_spacing=1.08
for name,size,color in [('Heading 1',17,'10243A'),('Heading 2',12,'1677C8'),('Heading 3',10,'10243A')]:
    s=styles[name]; s.font.name='Aptos Display'; s.font.size=Pt(size); s.font.bold=True; s.font.color.rgb=RGBColor.from_string(color); s.paragraph_format.space_before=Pt(7); s.paragraph_format.space_after=Pt(4); s.paragraph_format.keep_with_next=True
# header/footer
h=sec.header.paragraphs[0]; h.alignment=WD_ALIGN_PARAGRAPH.RIGHT
r=h.add_run('ATELIERCAMPUS  |  DÉVELOPPEMENT JEE'); r.font.size=Pt(8); r.font.color.rgb=RGBColor(90,110,130)
f=sec.footer.paragraphs[0]; f.alignment=WD_ALIGN_PARAGRAPH.CENTER
f.add_run('Université Centrale  •  Partie 2  |  Page ').font.size=Pt(8)
fld=OxmlElement('w:fldSimple'); fld.set(qn('w:instr'),'PAGE'); f._p.append(fld)

def p(text='',bold_start=None,align=None):
    x=D.add_paragraph()
    if align is not None:x.alignment=align
    if bold_start and text.startswith(bold_start):x.add_run(bold_start).bold=True;x.add_run(text[len(bold_start):])
    else:x.add_run(text)
    return x

def shade(cell,fill):
    tcPr=cell._tc.get_or_add_tcPr(); shd=OxmlElement('w:shd'); shd.set(qn('w:fill'),fill); tcPr.append(shd)

def table(headers,rows,widths=None,font=8):
    t=D.add_table(rows=1, cols=len(headers)); t.alignment=WD_TABLE_ALIGNMENT.CENTER; t.style='Table Grid'
    for i,htext in enumerate(headers):
        c=t.rows[0].cells[i]; c.text=htext; shade(c,'10243A'); c.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
        for rr in c.paragraphs[0].runs:rr.font.bold=True;rr.font.color.rgb=RGBColor(255,255,255);rr.font.size=Pt(font)
    for row in rows:
        cells=t.add_row().cells
        for i,val in enumerate(row):
            cells[i].text=str(val);cells[i].vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
            for para in cells[i].paragraphs:
                para.paragraph_format.space_after=Pt(1)
                for rr in para.runs:rr.font.size=Pt(font)
    return t

def code(text):
    x=D.add_paragraph(); x.paragraph_format.left_indent=Inches(.18); x.paragraph_format.right_indent=Inches(.1); x.paragraph_format.space_before=Pt(2); x.paragraph_format.space_after=Pt(5)
    pp=x._p.get_or_add_pPr(); shd=OxmlElement('w:shd'); shd.set(qn('w:fill'),'F1F5F9');pp.append(shd)
    rr=x.add_run(text);rr.font.name='Consolas';rr.font.size=Pt(8);rr.font.color.rgb=RGBColor(30,55,75)
    return x

def figure(path,num,title,explain,width=3.02):
    cell=D.add_table(rows=1,cols=1).cell(0,0); cell.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
    para=cell.paragraphs[0];para.alignment=WD_ALIGN_PARAGRAPH.CENTER
    para.add_run().add_picture(str(ROOT/'documentation'/'captures'/path),width=Inches(width))
    cap=D.add_paragraph();cap.alignment=WD_ALIGN_PARAGRAPH.CENTER;cap.paragraph_format.space_after=Pt(1)
    rr=cap.add_run(f'Figure {num} — {title}.');rr.bold=True;rr.font.size=Pt(8)
    desc=D.add_paragraph(explain);desc.alignment=WD_ALIGN_PARAGRAPH.CENTER;desc.paragraph_format.space_after=Pt(4)
    for rr in desc.runs:rr.font.size=Pt(7.5);rr.font.italic=True

# COVER
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER;x.paragraph_format.space_before=Pt(70)
r=x.add_run('UNIVERSITÉ CENTRALE');r.bold=True;r.font.size=Pt(15);r.font.color.rgb=RGBColor(22,119,200)
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER;x.paragraph_format.space_before=Pt(36)
r=x.add_run('AtelierCampus');r.bold=True;r.font.size=Pt(31);r.font.color.rgb=RGBColor(16,36,58)
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER
r=x.add_run('Rapport de conception et d’implémentation');r.bold=True;r.font.size=Pt(18);r.font.color.rgb=RGBColor(16,36,58)
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER
r=x.add_run('Partie 2 — Servlets, JDBC et sécurité');r.font.size=Pt(14);r.font.color.rgb=RGBColor(22,119,200)
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER;x.paragraph_format.space_before=Pt(24)
x.add_run('Gestion sécurisée des inscriptions aux ateliers de cybersécurité').font.size=Pt(11)
x=D.add_paragraph();x.alignment=WD_ALIGN_PARAGRAPH.CENTER;x.paragraph_format.space_before=Pt(60)
x.add_run('Développement JEE  •  Cycle ingénieur en Cyber Security\n').bold=True
x.add_run('Enseignant : Dr Riadh Bouslimi\n')
x.add_run('Dépôt local : 17 novembre 2026\n')
x.add_run('Université Centrale — Tunis').font.color.rgb=RGBColor(90,110,130)
D.add_page_break()

# PAGE 2
D.add_heading('1. Introduction',level=1)
p('AtelierCampus accompagne l’organisation des ateliers de cybersécurité de l’Université Centrale. La Partie 1 présentait le parcours catalogue, détail, formulaire et récapitulatif à partir de données en mémoire. Cette Partie 2 transforme la simulation en application Web persistante : les étudiants s’authentifient, réservent et annulent une place, tandis que le gestionnaire administre les ateliers et leurs participants.')
p('Le périmètre demandé reste volontairement celui de Jakarta Servlets, JSP et JDBC. La migration vers Spring Boot et JPA est réservée à la Partie 3. L’application conserve le WAR Maven, Java 17, Tomcat 10.1, les JSP, JSTL et le style de la première livraison.')
D.add_heading('2. Analyse de l’architecture',level=1)
p('Le code initial contenait les modèles Atelier, Etudiant et Inscription, un singleton DataStore et un servlet de validation de demande simulée. Les JSP lisaient directement le magasin mémoire. Aucun compte ni DAO n’existait. L’architecture P2 sépare maintenant contrôleurs HTTP, services métier, DAO JDBC et modèles.')
table(['Couche','Responsabilité implémentée'],[
('model','Atelier, Etudiant et Inscription; rôle et statut explicites.'),
('dao','Connexions H2, requêtes préparées, ResultSet et transactions.'),
('service','Authentification BCrypt, validation date/capacité et règles d’inscription.'),
('controller','AtelierCampusServlet reçoit les requêtes, gère sessions, vues et redirections.'),
('vues JSP','EL/JSTL pour le rendu; données utilisateur échappées avec c:out/fn:escapeXml.')],font=8)
p('Le filtre SecuriteFilter impose l’authentification et le rôle sur les URL étudiant/gestionnaire. Le parcours public passe par /catalogue, puis /atelier?id=…; l’étudiant ouvre une session avant les actions d’inscription. Après les POST réussis, une redirection applique le modèle PRG et évite la répétition au rafraîchissement.')
D.add_page_break()

# PAGE 3
D.add_heading('3. Conception et persistance des données',level=1)
p('La base choisie est H2 2.3 en mode fichier. Elle fournit une base relationnelle JDBC reproductible sans serveur externe et persiste dans le répertoire utilisateur. L’URL JDBC et les identifiants H2 sont configurables; le pilote livré et chargé par l’application reste H2.')
table(['Table','Principales contraintes'],[
('Etudiant','PK générée; nom, email et condensat requis; email unique; rôle ETUDIANT/GESTIONNAIRE.'),
('Atelier','PK générée; titre, description et date requis; capacité CHECK > 0.'),
('Inscription','PK générée; FK étudiant/atelier; statut limité à CONFIRMEE/ANNULEE; paire unique; index atelier/statut.')],font=8)
p('Les scripts database/schema.sql et database/data.sql créent les tables et les quatre ateliers fictifs : deux sessions à venir disponibles, une complète et une déjà commencée. Cinq étudiants, un compte gestionnaire et des inscriptions représentatives sont insérés au premier démarrage. La marque d’initialisation empêche d’écraser les ateliers après modification ou suppression par le gestionnaire.')
D.add_picture(str(ROOT/'documentation'/'erd_ateliercampus.png'),width=Inches(6.45))
cap=D.add_paragraph('Figure ERD — Cardinalités et contraintes reprises de database/schema.sql.');cap.alignment=WD_ALIGN_PARAGRAPH.CENTER;cap.paragraph_format.space_after=Pt(3)
for rr in cap.runs:rr.font.size=Pt(8);rr.font.italic=True
p('database/data.sql insère les ateliers fictifs; AppContextListener/Database initialise les six comptes avec BCrypt et les inscriptions de démonstration au premier démarrage. Le marqueur d’initialisation évite de réinsérer les ateliers supprimés ou modifiés.')
D.add_heading('Accès JDBC paramétré',level=2)
code('try (PreparedStatement p = c.prepareStatement(\n    "SELECT * FROM Atelier WHERE LOWER(titre) LIKE LOWER(?)")) {\n    p.setString(1, "%" + recherche + "%");\n    try (ResultSet r = p.executeQuery()) { /* mapping DAO */ }\n}')
p('Les ressources JDBC sont fermées par try-with-resources. Les valeurs utilisateur ne sont jamais assemblées dans le SQL. Les identifiants sont générés par H2; une contrainte d’unicité prévient deux inscriptions pour la même paire étudiant/atelier.')
D.add_page_break()

# PAGE 4
D.add_heading('4. Fonctionnalités et règles métier',level=1)
p('Le catalogue est public et permet la recherche par titre, le détail, la capacité totale, le nombre d’inscriptions confirmées et les places restantes. Les statuts « complet » et « déjà commencé » sont calculés côté serveur. L’étudiant consulte son propre historique, s’inscrit avant le début, annule avant le début et peut réactiver la même ligne après annulation.')
p('Le gestionnaire crée, modifie et supprime un atelier lorsqu’aucune inscription confirmée ne l’empêche; il consulte la liste et le statut de chaque participant. Les opérations administratives sont protégées par le rôle vérifié au serveur. Les opérations d’écriture utilisent POST et un jeton CSRF.')
D.add_heading('Transaction de réservation',level=2)
p('La réservation utilise une seule transaction JDBC. Le service commence la transaction, verrouille la ligne de l’atelier, vérifie existence et date, contrôle la paire existante, compte les confirmations et compare ce total à la capacité. Une nouvelle ligne est créée ou la ligne annulée existante est réactivée; l’échec déclenche un rollback.')
code('SELECT date_heure, capacite FROM Atelier WHERE id = ? FOR UPDATE\n-- contrôle date, doublon et nombre CONFIRMEE\nINSERT INTO Inscription(etudiant_id, atelier_id, date_inscription, statut)\nVALUES (?, ?, CURRENT_TIMESTAMP, \'CONFIRMEE\')\n-- COMMIT; en exception : ROLLBACK')
p('Le verrouillage de la ligne Atelier sérialise deux demandes concurrentes, y compris lorsque la dernière place est demandée au même instant. La capacité ne peut pas être réduite sous le compte confirmé : DAO et service appliquent le contrôle pendant la mise à jour. La suppression vérifie les inscriptions et retire seulement les lignes annulées lorsque la suppression est permise.')
D.add_page_break()

# PAGE 5
D.add_heading('5. Sécurité de l’application',level=1)
table(['Risque / contrôle','Mécanisme appliqué'],[
('Mots de passe','BCrypt avec coût 12; seuls les condensats sont stockés; aucune donnée sensible dans les journaux.'),
('Session','Session invalidée puis recréée à la connexion; expiration 30 min; cookie HttpOnly et SameSite Strict.'),
('Autorisation','Filtre serveur par rôle; requêtes d’annulation limitées à l’identifiant étudiant de session.'),
('CSRF','Jeton aléatoire lié à la session sur tous les POST; jeton manquant ou invalide rejeté par HTTP 403.'),
('Injection SQL','PreparedStatement pour recherche, connexion, réservation, annulation et gestion.'),
('XSS','c:out et fn:escapeXml dans les JSP pour descriptions, titres et paramètres réaffichés.'),
('Méthodes HTTP','Écriture par POST; les GET d’action ne réalisent aucune mutation.')],font=7.6)
D.add_heading('6. Tests et résultats',level=1)
p('Le build Maven et les 30 tests automatisés se terminent avec 0 échec : 24 tests de validation et servlet conservés de Partie 1 et 6 tests JDBC de Partie 2. Les tests d’intégration couvrent inscription/annulation/réactivation avec conservation de la clé primaire, atelier complet ou passé, propriété d’inscription, réduction de capacité, suppression conditionnelle, recherche paramétrée et concurrence à une place.')
p('Le script HTTP local vérifie catalogue, recherche, charges XSS/SQL, accès anonyme, mauvais identifiants, jetons CSRF absent et invalide, parcours étudiant, propriété d’inscription et restriction de rôle. Un contrôle HTTP séparé a effectué le CRUD du gestionnaire; le script de redémarrage réel de Tomcat retrouve une inscription ANNULEE dans la base fichier.')
p('Les preuves automatisées et leurs limites sont consignées dans documentation/RESULTATS_TESTS.md. Les captures de l’interface ci-dessous sont des images réelles de l’application déployée sur localhost; les contrôles HTTP/JUnit sont référencés séparément, sans capture fabriquée.')
D.add_page_break()

# PAGE 6 figures
D.add_heading('7. Captures de l’application locale',level=1)
t=D.add_table(rows=1,cols=2);t.alignment=WD_TABLE_ALIGNMENT.CENTER
items=[
('04_catalogue/01_catalogue_public.png',1,'Catalogue public','Quatre ateliers chargés depuis H2; capacité et inscriptions confirmées visibles.'),
('04_catalogue/02_atelier_complet.png',2,'Atelier complet','Le détail signale la capacité atteinte et masque l’action de réservation.'),
('04_catalogue/03_atelier_commence.png',3,'Atelier déjà commencé','La date passée est indiquée et aucune action d’inscription n’est proposée.'),
('05_inscriptions/01_mes_inscriptions.png',4,'Espace étudiant','L’historique est filtré sur l’étudiant connecté et expose ses statuts.')]
for idx,item in enumerate(items):
    cell=t.cell(idx//2,idx%2) if idx<2 else t.add_row().cells[idx%2]
    cell.text='';cell.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
    para=cell.paragraphs[0];para.alignment=WD_ALIGN_PARAGRAPH.CENTER
    para.add_run().add_picture(str(ROOT/'documentation'/'captures'/item[0]),width=Inches(2.45))
    cp=cell.add_paragraph();cp.alignment=WD_ALIGN_PARAGRAPH.CENTER;cp.paragraph_format.space_after=Pt(1)
    rr=cp.add_run(f'Figure {item[1]} — {item[2]}.');rr.bold=True;rr.font.size=Pt(8)
    ep=cell.add_paragraph(item[3]);ep.alignment=WD_ALIGN_PARAGRAPH.CENTER
    for rr in ep.runs:rr.font.size=Pt(7.2);rr.font.italic=True
D.add_page_break()

# PAGE 7 figures + conclusion
D.add_heading('7. Captures de l’application locale',level=1)
t=D.add_table(rows=1,cols=2);t.alignment=WD_TABLE_ALIGNMENT.CENTER
items=[
('05_inscriptions/03_places_actualisees.png',5,'Capacité après inscription','La réservation confirmée réduit les places disponibles.'),
('06_gestionnaire/01_tableau_gestionnaire.png',6,'Tableau du gestionnaire','Les ateliers et les opérations d’administration sont réservés au rôle gestionnaire.'),
('06_gestionnaire/06_liste_participants.png',7,'Participants','La page affiche le nom, l’adresse et le statut des inscriptions à l’atelier.'),
('07_securite/01_acces_gestionnaire_refuse.png',8,'Accès protégé','Un visiteur anonyme est redirigé vers la connexion avant le tableau de gestion.')]
for idx,item in enumerate(items):
    cell=t.cell(idx//2,idx%2) if idx<2 else t.add_row().cells[idx%2]
    cell.text='';cell.vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
    para=cell.paragraphs[0];para.alignment=WD_ALIGN_PARAGRAPH.CENTER
    para.add_run().add_picture(str(ROOT/'documentation'/'captures'/item[0]),width=Inches(2.45))
    cp=cell.add_paragraph();cp.alignment=WD_ALIGN_PARAGRAPH.CENTER;cp.paragraph_format.space_after=Pt(1)
    rr=cp.add_run(f'Figure {item[1]} — {item[2]}.');rr.bold=True;rr.font.size=Pt(8)
    ep=cell.add_paragraph(item[3]);ep.alignment=WD_ALIGN_PARAGRAPH.CENTER
    for rr in ep.runs:rr.font.size=Pt(7.2);rr.font.italic=True
D.add_heading('8. Conclusion et perspectives',level=2)
p('La Partie 2 met en place la persistance JDBC, les responsabilités MVC, les comptes à mots de passe hachés, le contrôle des rôles et les règles de réservation atomiques. Les scénarios métier majeurs ont été vérifiés par tests automatisés et parcours locaux, y compris le redémarrage et la demande concurrente de la dernière place.')
p('Les prochaines évolutions peuvent remplacer H2 fichier par une base de données administrée, externaliser les secrets de déploiement, enrichir le modèle de présentation et préparer la migration vers Spring Boot/JPA prévue en Partie 3. Les comptes livrés sont des identifiants de démonstration uniquement.')

# PAGE 8 — evidence trail from real local HTTP and Surefire runs
D.add_page_break()
D.add_heading('9. Preuves des vérifications ciblées',level=1)
p('Les deux images ci-dessous ont été capturées dans le navigateur sur l’application Tomcat locale après soumission des charges de recherche. La valeur SQL ne renvoie aucun atelier; la balise script reste du texte inerte dans le champ de recherche.')
t=D.add_table(rows=1,cols=2);t.alignment=WD_TABLE_ALIGNMENT.CENTER
for i,(img,title,desc) in enumerate([
    ('08_audit_final/01_sql_injection_sans_resultat.png','Injection SQL','La charge « ’ OR 1=1-- » ne révèle aucun résultat.'),
    ('08_audit_final/02_xss_texte_echappe.png','XSS échappée','La balise script apparaît comme texte et ne s’exécute pas.')]):
    cell=t.rows[0].cells[i];cell.text=''
    para=cell.paragraphs[0];para.alignment=WD_ALIGN_PARAGRAPH.CENTER
    para.add_run().add_picture(str(ROOT/'documentation'/'captures'/img),width=Inches(3.0))
    cap=cell.add_paragraph(title);cap.alignment=WD_ALIGN_PARAGRAPH.CENTER
    for rr in cap.runs:rr.bold=True;rr.font.size=Pt(8)
    exp=cell.add_paragraph(desc);exp.alignment=WD_ALIGN_PARAGRAPH.CENTER
    for rr in exp.runs:rr.font.size=Pt(7.5);rr.font.italic=True
D.add_heading('Résultats complémentaires sans capture navigateur',level=2)
table(['Contrôle exécuté','Résultat observé et source'],[
('CSRF absent / invalide','Deux POST locaux rejetés en HTTP 403; vérifié par scripts/verification-locale.ps1.'),
('Concurrence, dernière place','Test JdbcBusinessIntegrationTest.deuxDemandesConcurentesNeDepassentPasLaCapacite réussi; assertions : un succès et une confirmation.'),
('Persistance après redémarrage','Tomcat arrêté puis relancé; le compte Sami retrouve son inscription ANNULEE; scripts/verification-redemarrage.ps1.'),
('CRUD gestionnaire','Création, modification et suppression d’un atelier temporaire vérifiées via POST avec session et CSRF valides; script verification-crud-gestionnaire.ps1.')],font=8)
p('Ces quatre lignes sont des résultats de scripts et d’assertions exécutés, pas des captures d’écran. Le tableau les distingue des deux vues réelles ci-dessus.',bold_start='Ces quatre lignes')

# Keep title plain, all content in French
for para in D.paragraphs:
    for run in para.runs:
        if run.font.name is None:run.font.name='Aptos'
D.save(OUT)
print(OUT)

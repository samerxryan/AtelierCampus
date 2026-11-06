<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="atelier" value="${dataStore.getAtelierById(param.id)}" />

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="${atelier != null ? atelier.titre : 'Atelier non trouvé'} — AtelierCampus" />
    <jsp:param name="activeNav" value="catalogue" />
</jsp:include>

<section class="page-banner">
    <div class="page-banner-container">
        <nav class="breadcrumb-nav" aria-label="Fil d'Ariane">
            <a href="${pageContext.request.contextPath}/index.jsp">Accueil</a>
            <span class="breadcrumb-sep">/</span>
            <a href="${pageContext.request.contextPath}/catalogue.jsp">Catalogue des ateliers</a>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current">
                <c:choose>
                    <c:when test="${not empty atelier}">
                        <c:out value="${atelier.titre}" />
                    </c:when>
                    <c:otherwise>Atelier non trouvé</c:otherwise>
                </c:choose>
            </span>
        </nav>

        <c:if test="${not empty atelier}">
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                <span class="workshop-ref-tag">Référence #<c:out value="${atelier.id}" /></span>
                <span class="status-pill status-${dataStore.getCodeStatut(atelier.id)}">
                    <span class="status-dot"></span>
                    <c:out value="${dataStore.getStatutDisponibilite(atelier.id)}" />
                </span>
            </div>
            <h1 class="banner-title"><c:out value="${atelier.titre}" /></h1>
        </c:if>
    </div>
</section>

<section class="section-content">
    <div class="content-container">

        <c:choose>
            <%-- Cas 1 : Identifiant inexistant ou invalide --%>
            <c:when test="${empty atelier}">
                <div class="error-card-wrapper">
                    <div class="error-svg-icon">
                        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" x2="12" y1="8" y2="12"/>
                            <line x1="12" x2="12.01" y2="16"/>
                        </svg>
                    </div>
                    <h2 class="error-title-h2">Atelier Non Trouvé</h2>
                    <p class="error-text-desc">
                        L'atelier correspondant à l'identifiant 
                        <span class="error-code-badge"><c:out value="${empty param.id ? 'non renseigné' : param.id}" /></span> 
                        n'existe pas ou n'est plus répertorié dans le catalogue de formation.
                    </p>
                    <div style="display: flex; justify-content: center; gap: 1rem;">
                        <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="m15 18-6-6 6-6"/>
                            </svg>
                            <span>Retourner au catalogue</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                            Page d'accueil
                        </a>
                    </div>
                </div>
            </c:when>

            <%-- Cas 2 : Atelier trouvé et valide --%>
            <c:otherwise>
                <div class="detail-layout-grid">
                    <%-- Colonne principale --%>
                    <div class="detail-main-column">
                        <div class="info-panel">
                            <div class="panel-header">
                                <h2 class="panel-header-title">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                                    </svg>
                                    Objectifs &amp; Programme Détaillé
                                </h2>
                            </div>
                            <div class="panel-body">
                                <p class="panel-text-block"><c:out value="${atelier.description}" /></p>
                            </div>
                        </div>

                        <div class="info-panel">
                            <div class="panel-header">
                                <h2 class="panel-header-title">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="12" cy="12" r="10"/>
                                        <polyline points="12 6 12 12 16 14"/>
                                    </svg>
                                    Modalités Pratiques &amp; Logistique
                                </h2>
                            </div>
                            <div class="panel-body">
                                <div class="logistics-grid">
                                    <div class="logistic-tile">
                                        <span class="tile-label">Intervenant / Formateur</span>
                                        <span class="tile-value"><c:out value="${atelier.animateur}" /></span>
                                    </div>
                                    <div class="logistic-tile">
                                        <span class="tile-label">Lieu &amp; Laboratoire</span>
                                        <span class="tile-value"><c:out value="${atelier.salle}" /></span>
                                    </div>
                                    <div class="logistic-tile">
                                        <span class="tile-label">Niveau Technique Requis</span>
                                        <span class="tile-value"><c:out value="${atelier.niveau}" /></span>
                                    </div>
                                    <div class="logistic-tile">
                                        <span class="tile-label">Capacité Totale</span>
                                        <span class="tile-value"><c:out value="${atelier.capacite}" /> places</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Tableau des participants inscrits --%>
                        <div class="info-panel">
                            <div class="panel-header">
                                <h2 class="panel-header-title">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                                        <circle cx="9" cy="7" r="4"/>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                    </svg>
                                    Inscriptions Enregistrées pour cette Session
                                </h2>
                            </div>
                            <div class="panel-body" style="padding: 0;">
                                <c:set var="inscriptionsList" value="${dataStore.getInscriptionsByAtelier(atelier.id)}" />
                                <c:choose>
                                    <c:when test="${empty inscriptionsList}">
                                        <div style="padding: 1.5rem; color: var(--text-secondary);">
                                            Aucune inscription enregistrée pour cette session actuellement.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="university-table">
                                            <thead>
                                                <tr>
                                                    <th>Étudiant</th>
                                                    <th>Adresse Email</th>
                                                    <th>Date de Demande</th>
                                                    <th>Statut</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${inscriptionsList}" var="insc">
                                                    <tr>
                                                        <td><strong><c:out value="${insc.etudiant.nom}" /></strong></td>
                                                        <td><c:out value="${insc.etudiant.email}" /></td>
                                                        <td><c:out value="${insc.dateInscriptionFormattee}" /></td>
                                                        <td>
                                                            <span class="status-tag tag-${insc.statut.name().toLowerCase()}">
                                                                <c:out value="${insc.statut}" />
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <%-- Colonne latérale (Encadré inscription) --%>
                    <aside class="detail-sidebar-column">
                        <div class="sidebar-sticky-box">
                            <div class="sidebar-session-title">Session Programmée</div>
                            <div class="sidebar-date-highlight">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                                    <line x1="16" x2="16" y1="2" y2="6"/>
                                    <line x1="8" x2="8" y1="2" y2="6"/>
                                    <line x1="3" x2="21" y1="10" y2="10"/>
                                </svg>
                                <span><c:out value="${atelier.dateHeureFormattee}" /></span>
                            </div>

                            <div class="sidebar-facts-list">
                                <div class="sidebar-fact-row">
                                    <span>Capacité maximale :</span>
                                    <span class="sidebar-fact-val"><c:out value="${atelier.capacite}" /> places</span>
                                </div>
                                <div class="sidebar-fact-row">
                                    <span>Inscrits confirmés :</span>
                                    <span class="sidebar-fact-val"><c:out value="${dataStore.getNombreInscriptionsConfirmees(atelier.id)}" /></span>
                                </div>
                                <div class="sidebar-fact-row">
                                    <span>Places disponibles :</span>
                                    <span class="sidebar-fact-val" style="color: var(--accent-blue); font-weight: 700;">
                                        <c:out value="${dataStore.getPlacesRestantes(atelier.id)}" />
                                    </span>
                                </div>
                                <div class="sidebar-fact-row">
                                    <span>Statut :</span>
                                    <span class="status-pill status-${dataStore.getCodeStatut(atelier.id)}">
                                        <c:out value="${dataStore.getStatutDisponibilite(atelier.id)}" />
                                    </span>
                                </div>
                            </div>

                            <div class="sidebar-actions-group">
                                <a href="inscription.jsp?id=${atelier.id}" class="btn btn-primary btn-block btn-lg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                                        <circle cx="9" cy="7" r="4"/>
                                        <line x1="19" x2="19" y1="8" y2="14"/>
                                        <line x1="22" x2="16" y1="11" y2="11"/>
                                    </svg>
                                    <span>Demander l'inscription</span>
                                </a>

                                <a href="catalogue.jsp" class="btn btn-secondary btn-block">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="m15 18-6-6 6-6"/>
                                    </svg>
                                    <span>Retour au catalogue</span>
                                </a>
                            </div>
                        </div>
                    </aside>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</section>

<jsp:include page="includes/footer.jsp" />

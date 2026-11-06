<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Confirmation de Demande — AtelierCampus" />
    <jsp:param name="activeNav" value="catalogue" />
</jsp:include>

<section class="page-banner">
    <div class="page-banner-container">
        <nav class="breadcrumb-nav" aria-label="Fil d'Ariane">
            <a href="${pageContext.request.contextPath}/index.jsp">Accueil</a>
            <span class="breadcrumb-sep">/</span>
            <a href="${pageContext.request.contextPath}/catalogue.jsp">Catalogue des ateliers</a>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current">Confirmation de demande</span>
        </nav>
        <h1 class="banner-title">Récapitulatif de la Demande d'Inscription</h1>
        <p class="banner-subtitle">
            Votre demande a bien été transmise et vérifiée par le portail de formation de l'Université Centrale.
        </p>
    </div>
</section>

<section class="section-content">
    <div class="content-container recap-wrapper-box">

        <c:choose>
            <%-- Cas d'accès direct sans données soumises --%>
            <c:when test="${empty requestScope.etudiantNom or empty requestScope.atelier}">
                <div class="error-card-wrapper">
                    <div class="error-svg-icon" style="background-color: #EBF5FB; color: var(--accent-blue);">
                        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" x2="12" y1="16" x2="12"/>
                            <line x1="12" x2="12.01" y2="8"/>
                        </svg>
                    </div>
                    <h2 class="error-title-h2">Aucune Demande Récente à Afficher</h2>
                    <p class="error-text-desc">
                        Cette page récapitulative affiche le bilan d'une demande soumise. Veuillez sélectionner un atelier dans le catalogue pour effectuer une inscription.
                    </p>
                    <div style="display: flex; justify-content: center; gap: 1rem;">
                        <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary">
                            <span>Consulter le catalogue des ateliers</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                            Page d'accueil
                        </a>
                    </div>
                </div>
            </c:when>

            <%-- Cas normal : affichage du récapitulatif complet --%>
            <c:otherwise>
                <%-- Mention obligatoire de simulation requise par le sujet --%>
                <div class="simulation-disclaimer-card" role="alert">
                    <div class="disclaimer-icon-wrap">
                        <svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" x2="12" y1="8" y2="12"/>
                            <line x1="12" x2="12.01" y2="16"/>
                        </svg>
                    </div>
                    <div>
                        <div class="disclaimer-headline">Demande simulée, non enregistrée.</div>
                        <p class="disclaimer-body-text">
                            Cette opération constitue une simulation d'enregistrement. Aucune réservation définitive de place 
                            n'a été effectuée et aucune donnée n'a été enregistrée de manière permanente dans le système.
                        </p>
                    </div>
                </div>

                <div class="recap-content-card">
                    <div class="recap-card-topbar">
                        <div class="recap-success-pill">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                            <span>Demande Traitée avec Succès</span>
                        </div>
                        <span class="recap-time-stamp">
                            Date de traitement : <c:out value="${requestScope.dateDemande}" />
                        </span>
                    </div>

                    <div class="recap-two-col">
                        <%-- Coordonnées Étudiant --%>
                        <div class="recap-data-panel">
                            <div class="recap-panel-header">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                                <span>Coordonnées du Candidat</span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Nom complet :</span>
                                <span class="recap-row-val recap-row-val-bold">
                                    <c:out value="${requestScope.etudiantNom}" />
                                </span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Adresse email :</span>
                                <span class="recap-row-val">
                                    <c:out value="${requestScope.etudiantEmail}" />
                                </span>
                            </div>
                        </div>

                        <%-- Détails Atelier --%>
                        <div class="recap-data-panel">
                            <div class="recap-panel-header">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                                </svg>
                                <span>Atelier Sélectionné</span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Intitulé :</span>
                                <span class="recap-row-val recap-row-val-bold">
                                    <c:out value="${requestScope.atelier.titre}" />
                                </span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Référence :</span>
                                <span class="recap-row-val">
                                    #<c:out value="${requestScope.atelier.id}" />
                                </span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Date et horaire :</span>
                                <span class="recap-row-val">
                                    <c:out value="${requestScope.atelier.dateHeureFormattee}" />
                                </span>
                            </div>
                            <div class="recap-row">
                                <span class="recap-row-label">Lieu &amp; Formateur :</span>
                                <span class="recap-row-val">
                                    <c:out value="${requestScope.atelier.salle}" /> — <c:out value="${requestScope.atelier.animateur}" />
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="recap-next-steps">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--accent-blue); flex-shrink: 0;">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" x2="12" y1="16" x2="12"/>
                            <line x1="12" x2="12.01" y2="8"/>
                        </svg>
                        <span>
                            Les informations récapitulatives ci-dessus confirment la bonne réception de vos paramètres. Vous pouvez retourner au catalogue pour explorer d'autres sessions.
                        </span>
                    </div>

                    <div class="recap-actions-cluster">
                        <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary btn-lg">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="m15 18-6-6 6-6"/>
                            </svg>
                            <span>Retourner au catalogue des ateliers</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary btn-lg">
                            Page d'accueil
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</section>

<jsp:include page="includes/footer.jsp" />

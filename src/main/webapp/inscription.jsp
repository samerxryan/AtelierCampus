<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="targetId" value="${not empty requestScope.atelierId ? requestScope.atelierId : (not empty param.id ? param.id : param.atelierId)}" />
<c:set var="atelier" value="${not empty requestScope.atelier ? requestScope.atelier : dataStore.getAtelierById(targetId)}" />
<c:set var="saisieNom" value="${not empty requestScope.nom ? requestScope.nom : param.nom}" />
<c:set var="saisieEmail" value="${not empty requestScope.email ? requestScope.email : param.email}" />

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Demande d'inscription — AtelierCampus" />
    <jsp:param name="activeNav" value="catalogue" />
</jsp:include>

<section class="page-banner">
    <div class="page-banner-container">
        <nav class="breadcrumb-nav" aria-label="Fil d'Ariane">
            <a href="${pageContext.request.contextPath}/index.jsp">Accueil</a>
            <span class="breadcrumb-sep">/</span>
            <a href="${pageContext.request.contextPath}/catalogue.jsp">Catalogue des ateliers</a>
            <c:if test="${not empty atelier}">
                <span class="breadcrumb-sep">/</span>
                <a href="${pageContext.request.contextPath}/detail.jsp?id=${atelier.id}"><c:out value="${atelier.titre}" /></a>
            </c:if>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current">Formulaire d'inscription</span>
        </nav>
        <h1 class="banner-title">Formulaire de Demande d'Inscription</h1>
        <p class="banner-subtitle">
            Veuillez renseigner vos coordonnées pour enregistrer votre demande de participation à l'atelier sélectionné.
        </p>
    </div>
</section>

<section class="section-content">
    <div class="content-container form-card-container">

        <%-- Bloc d'erreurs de validation --%>
        <c:if test="${not empty requestScope.erreurs}">
            <div class="alert-box alert-danger" role="alert" id="validationErrors">
                <span class="alert-danger-icon">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" x2="12" y1="8" y2="12"/>
                        <line x1="12" x2="12.01" y2="16"/>
                    </svg>
                </span>
                <div class="alert-body-content">
                    <div class="alert-heading-text">Erreur(s) de validation détectée(s) :</div>
                    <ul class="alert-error-list">
                        <c:forEach items="${requestScope.erreurs}" var="erreur">
                            <li><c:out value="${erreur}" /></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </c:if>

        <c:choose>
            <%-- Cas où aucun atelier n'a pu être identifié --%>
            <c:when test="${empty atelier and empty requestScope.erreurs}">
                <div class="error-card-wrapper">
                    <div class="error-svg-icon" style="background-color: #EBF5FB; color: var(--accent-blue);">
                        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/>
                            <path d="m21 21-4.3-4.3"/>
                        </svg>
                    </div>
                    <h2 class="error-title-h2">Aucun Atelier Sélectionné</h2>
                    <p class="error-text-desc">
                        Pour formuler une demande d'inscription, veuillez d'abord sélectionner un atelier dans le catalogue.
                    </p>
                    <div>
                        <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary">
                            <span>Consulter le catalogue des ateliers</span>
                        </a>
                    </div>
                </div>
            </c:when>

            <%-- Cas normal ou formulaire réaffiché après correction --%>
            <c:otherwise>
                <div class="form-grid-layout">
                    <%-- Récapitulatif atelier sélectionné --%>
                    <div class="selected-session-card">
                        <div class="session-badge-top">Atelier Sélectionné</div>

                        <c:choose>
                            <c:when test="${not empty atelier}">
                                <h2 class="selected-session-h3"><c:out value="${atelier.titre}" /></h2>
                                <p class="selected-session-desc"><c:out value="${atelier.descriptionCourte}" /></p>

                                <div class="session-key-data">
                                    <div class="key-data-row">
                                        <span class="key-data-label">Référence :</span>
                                        <span class="key-data-value">#<c:out value="${atelier.id}" /></span>
                                    </div>
                                    <div class="key-data-row">
                                        <span class="key-data-label">Date :</span>
                                        <span class="key-data-value"><c:out value="${atelier.dateHeureFormattee}" /></span>
                                    </div>
                                    <div class="key-data-row">
                                        <span class="key-data-label">Lieu :</span>
                                        <span class="key-data-value"><c:out value="${atelier.salle}" /></span>
                                    </div>
                                    <div class="key-data-row">
                                        <span class="key-data-label">Disponibilité :</span>
                                        <span class="status-pill status-${dataStore.getCodeStatut(atelier.id)}">
                                            <span class="status-dot"></span>
                                            <c:out value="${dataStore.getStatutDisponibilite(atelier.id)}" />
                                        </span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert-box alert-warning">
                                    L'identifiant d'atelier transmis (<code><c:out value="${targetId}"/></code>) est invalide.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Formulaire de saisie étudiant --%>
                    <div class="registration-form-box">
                        <div class="form-box-header">
                            <h2 class="form-box-title">Coordonnées de l'Étudiant</h2>
                            <p class="form-box-subtitle">Veuillez vérifier l'exactitude de vos informations personnelles.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/traitement" method="POST" class="registration-form" novalidate>
                            <%-- Identifiant caché de l'atelier préservé --%>
                            <input type="hidden" name="atelierId" value="<c:out value="${targetId}" />" />

                            <div class="field-group">
                                <label for="nom" class="field-label">
                                    Nom complet de l'étudiant <span class="label-required">*</span>
                                </label>
                                <div class="field-control-wrap">
                                    <span class="field-icon">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                                            <circle cx="12" cy="7" r="4"/>
                                        </svg>
                                    </span>
                                    <input 
                                        type="text" 
                                        id="nom" 
                                        name="nom" 
                                        class="form-input" 
                                        placeholder="Ex: Ahmed Ben Ali" 
                                        value="<c:out value="${saisieNom}" />" 
                                        required 
                                        autocomplete="name"
                                    />
                                </div>
                                <span class="field-helper">Indiquez votre prénom et nom complets.</span>
                            </div>

                            <div class="field-group">
                                <label for="email" class="field-label">
                                    Adresse email <span class="label-required">*</span>
                                </label>
                                <div class="field-control-wrap">
                                    <span class="field-icon">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect width="20" height="16" x="2" y="4" rx="2"/>
                                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                                        </svg>
                                    </span>
                                    <input 
                                        type="email" 
                                        id="email" 
                                        name="email" 
                                        class="form-input" 
                                        placeholder="Ex: etudiant@gmail.com" 
                                        value="<c:out value="${saisieEmail}" />" 
                                        required 
                                        autocomplete="email"
                                    />
                                </div>
                                <span class="field-helper">Une adresse email valide est obligatoire pour la prise de contact.</span>
                            </div>

                            <div style="margin-top: 0.5rem; display: flex; flex-direction: column; gap: 0.75rem;">
                                <button type="submit" class="btn btn-primary btn-block btn-lg" id="btnSubmit">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"/>
                                    </svg>
                                    <span>Confirmer la demande d'inscription</span>
                                </button>
                                
                                <c:choose>
                                    <c:when test="${not empty atelier}">
                                        <a href="${pageContext.request.contextPath}/detail.jsp?id=${atelier.id}" class="btn btn-secondary btn-block">
                                            Annuler et retourner
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-secondary btn-block">
                                            Retour au catalogue
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</section>

<jsp:include page="includes/footer.jsp" />

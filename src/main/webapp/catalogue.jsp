<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Catalogue des Ateliers — AtelierCampus" />
    <jsp:param name="activeNav" value="catalogue" />
</jsp:include>

<section class="page-banner">
    <div class="page-banner-container">
        <nav class="breadcrumb-nav" aria-label="Fil d'Ariane">
            <a href="${pageContext.request.contextPath}/index.jsp">Accueil</a>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current">Catalogue des ateliers</span>
        </nav>
        <h1 class="banner-title">Catalogue des Ateliers de Cybersécurité</h1>
        <p class="banner-subtitle">
            Consultez les sessions techniques proposées par l'Université Centrale. Sélectionnez un atelier pour découvrir 
            les objectifs pédagogiques, les modalités pratiques et formuler votre demande d'inscription.
        </p>
    </div>
</section>

<section class="section-content">
    <div class="content-container">

        <c:choose>
            <c:when test="${empty dataStore.ateliers}">
                <div class="alert-box alert-warning">
                    <p>Aucun atelier n'est actuellement programmé pour la période en cours.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="catalog-grid">
                    <c:forEach items="${dataStore.ateliers}" var="atelier">
                        <c:set var="statutCode" value="${dataStore.getCodeStatut(atelier.id)}" />
                        <c:set var="statutLibelle" value="${dataStore.getStatutDisponibilite(atelier.id)}" />
                        <c:set var="placesRestantes" value="${dataStore.getPlacesRestantes(atelier.id)}" />

                        <article class="workshop-card">
                            <div class="card-top">
                                <span class="workshop-ref-tag">Réf. #<c:out value="${atelier.id}" /></span>
                                <span class="status-pill status-${statutCode}">
                                    <span class="status-dot"></span>
                                    <c:out value="${statutLibelle}" />
                                </span>
                            </div>

                            <div class="card-content">
                                <h2 class="workshop-heading">
                                    <a href="detail.jsp?id=${atelier.id}">
                                        <c:out value="${atelier.titre}" />
                                    </a>
                                </h2>
                                
                                <p class="workshop-summary">
                                    <c:out value="${atelier.descriptionCourte}" />
                                </p>

                                <div class="workshop-meta-list">
                                    <div class="meta-item">
                                        <span class="meta-icon">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                                                <line x1="16" x2="16" y1="2" y2="6"/>
                                                <line x1="8" x2="8" y1="2" y2="6"/>
                                                <line x1="3" x2="21" y1="10" y2="10"/>
                                            </svg>
                                        </span>
                                        <span><c:out value="${atelier.dateHeureFormattee}" /></span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-icon">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                                                <circle cx="9" cy="7" r="4"/>
                                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                            </svg>
                                        </span>
                                        <span>
                                            Capacité : <strong><c:out value="${atelier.capacite}" /> participants</strong>
                                            <c:if test="${statutCode == 'disponible'}">
                                                (<c:out value="${placesRestantes}" /> restantes)
                                            </c:if>
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span class="meta-icon">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>
                                                <circle cx="12" cy="10" r="3"/>
                                            </svg>
                                        </span>
                                        <span><c:out value="${atelier.salle}" /> • <c:out value="${atelier.niveau}" /></span>
                                    </div>
                                </div>
                            </div>

                            <div class="card-action-bar">
                                <a href="detail.jsp?id=${atelier.id}" class="btn btn-secondary btn-block">
                                    <span>Voir les détails</span>
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M5 12h14"/>
                                        <path d="m12 5 7 7-7 7"/>
                                    </svg>
                                </a>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</section>

<jsp:include page="includes/footer.jsp" />

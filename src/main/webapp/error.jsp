<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Page Non Trouvée — AtelierCampus" />
    <jsp:param name="activeNav" value="" />
</jsp:include>

<section class="page-banner">
    <div class="page-banner-container">
        <h1 class="banner-title">Notification Système</h1>
        <p class="banner-subtitle">Portail officiel de formation de l'Université Centrale.</p>
    </div>
</section>

<section class="section-content">
    <div class="content-container">
        <div class="error-card-wrapper">
            <div class="error-svg-icon">
                <svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" x2="12" y1="8" y2="12"/>
                    <line x1="12" x2="12.01" y2="16"/>
                </svg>
            </div>
            
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    <h2 class="error-title-h2">Ressource Introuvable</h2>
                    <p class="error-text-desc">
                        La page que vous recherchez n'existe pas ou a été déplacée (Code d'erreur <span class="error-code-badge">404</span>).
                    </p>
                </c:when>
                <c:otherwise>
                    <h2 class="error-title-h2">Requête Non Aboutie</h2>
                    <p class="error-text-desc">
                        Le système n'a pas pu traiter votre requête. Par mesure de sécurité, aucun détail technique n'est exposé.
                    </p>
                </c:otherwise>
            </c:choose>

            <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m15 18-6-6 6-6"/>
                    </svg>
                    <span>Consulter le catalogue des ateliers</span>
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                    Retour à l'accueil
                </a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />

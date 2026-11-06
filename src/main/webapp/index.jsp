<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Portail des Ateliers de Cybersécurité — AtelierCampus" />
    <jsp:param name="activeNav" value="home" />
</jsp:include>

<section class="hero-portal">
    <div class="content-container">
        <div class="hero-grid">
            <div class="hero-text-content">
                <div class="hero-pill">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    <span>Université Centrale • Cycle Ingénieur</span>
                </div>

                <h1 class="hero-headline">
                    Formations pratiques et ateliers d'excellence en cybersécurité
                </h1>

                <p class="hero-description">
                    AtelierCampus est la plateforme officielle de l'Université Centrale dédiée au perfectionnement 
                    technique des étudiants. Explorez notre catalogue de sessions pratiques, consultez les programmes 
                    détaillés et inscrivez-vous aux ateliers animés par des enseignants et professionnels du secteur.
                </p>

                <div class="hero-cta-group">
                    <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-primary btn-lg">
                        <span>Découvrir les ateliers</span>
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </a>
                    <a href="#presentation" class="btn btn-secondary btn-lg">
                        <span>En savoir plus</span>
                    </a>
                </div>

                <div class="hero-features-list">
                    <div class="hero-feature-item">
                        <span class="hero-feature-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                        </span>
                        <span>Mises en situation réelles</span>
                    </div>
                    <div class="hero-feature-item">
                        <span class="hero-feature-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                        </span>
                        <span>Laboratoires spécialisés</span>
                    </div>
                    <div class="hero-feature-item">
                        <span class="hero-feature-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                        </span>
                        <span>Encadrement par des experts</span>
                    </div>
                </div>
            </div>

            <div class="hero-visual-card">
                <div class="portal-notice-header">
                    <div class="notice-badge-icon">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                            <line x1="16" x2="16" y1="2" y2="6"/>
                            <line x1="8" x2="8" y1="2" y2="6"/>
                            <line x1="3" x2="21" y1="10" y2="10"/>
                        </svg>
                    </div>
                    <div>
                        <div class="notice-title">Prochaines Sessions Ouvertes</div>
                        <div class="notice-subtitle">Programme officiel de formation</div>
                    </div>
                </div>

                <div class="sessions-preview-stack">
                    <c:forEach items="${dataStore.ateliers}" var="at" begin="0" end="2">
                        <div class="session-preview-item">
                            <div>
                                <div class="session-name"><c:out value="${at.titre}" /></div>
                                <div class="session-date">
                                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                                        <line x1="16" x2="16" y1="2" y2="6"/>
                                        <line x1="8" x2="8" y1="2" y2="6"/>
                                        <line x1="3" x2="21" y1="10" y2="10"/>
                                    </svg>
                                    <c:out value="${at.dateHeureFormattee}" />
                                </div>
                            </div>
                            <div>
                                <span class="status-pill status-${dataStore.getCodeStatut(at.id)}">
                                    <span class="status-dot"></span>
                                    <c:out value="${dataStore.getStatutDisponibilite(at.id)}" />
                                </span>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div style="margin-top: 1.25rem; text-align: center;">
                    <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn btn-outline btn-block">
                        <span>Consulter l'ensemble du catalogue</span>
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="presentation" class="section-overview">
    <div class="content-container">
        <div class="section-head-center">
            <div class="section-kicker">Excellence Pédagogique</div>
            <h2 class="section-h2">Une approche concrète de la sécurité numérique</h2>
            <p class="section-lead">
                Les ateliers proposés combinent apports théoriques ciblés et manipulations techniques intensives sur des environnements dédiés.
            </p>
        </div>

        <div class="pillars-grid">
            <div class="pillar-card">
                <div class="pillar-icon-box">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                </div>
                <h3 class="pillar-title">Formations Animées par des Experts</h3>
                <p class="pillar-desc">
                    Des sessions conçues et dispensées par des enseignants-chercheurs et des spécialistes reconnus en sécurité offensive et défensive.
                </p>
            </div>

            <div class="pillar-card">
                <div class="pillar-icon-box">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="20" height="14" x="2" y="3" rx="2"/>
                        <line x1="8" x2="16" y1="21" y2="21"/>
                        <line x1="12" x2="12" y1="17" y2="21"/>
                    </svg>
                </div>
                <h3 class="pillar-title">Mises en Situation Pratiques</h3>
                <p class="pillar-desc">
                    Exercices pratiques en laboratoire : identification de vulnérabilités, audits de code, analyse de traces d'incident et cryptographie appliquée.
                </p>
            </div>

            <div class="pillar-card">
                <div class="pillar-icon-box">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </div>
                <h3 class="pillar-title">Effectifs Maîtrisés</h3>
                <p class="pillar-desc">
                    Chaque session dispose d'un nombre de places calibré afin de garantir une proximité pédagogique et un accompagnement individualisé.
                </p>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty applicationScope.dataStore}">
    <c:set var="dataStore" value="<%= com.ateliercampus.data.DataStore.getInstance() %>" scope="application" />
</c:if>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><c:out value="${param.pageTitle != null ? param.pageTitle : 'AtelierCampus'}"/> — Université Centrale</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <header class="site-header">
        <div class="header-topbar">
            <div class="topbar-container">
                <div class="topbar-left">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/>
                        <path d="M2 12h20"/>
                    </svg>
                    <span>Université Centrale • Pôle Ingénierie &amp; Technologies de l'Information</span>
                </div>
                <div class="topbar-right">
                    <span class="topbar-link">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        </svg>
                        Centre de Formation Pratique en Cybersécurité
                    </span>
                </div>
            </div>
        </div>

        <div class="header-main">
            <a href="${pageContext.request.contextPath}/index.jsp" class="brand-wrapper" title="AtelierCampus — Accueil">
                <div class="brand-crest">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                </div>
                <div class="brand-text">
                    <span class="brand-name">Atelier<span class="brand-name-accent">Campus</span></span>
                    <span class="brand-sub">Université Centrale</span>
                </div>
            </a>

            <nav class="site-nav" aria-label="Navigation principale">
                <a href="${pageContext.request.contextPath}/index.jsp" class="nav-item ${param.activeNav == 'home' ? 'active' : ''}">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                    Accueil
                </a>
                <a href="${pageContext.request.contextPath}/catalogue.jsp" class="nav-item ${param.activeNav == 'catalogue' ? 'active' : ''}">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="7" height="7" x="3" y="3" rx="1"/>
                        <rect width="7" height="7" x="14" y="3" rx="1"/>
                        <rect width="7" height="7" x="14" y="14" rx="1"/>
                        <rect width="7" height="7" x="3" y="14" rx="1"/>
                    </svg>
                    Catalogue des ateliers
                </a>
            </nav>

            <div class="header-action">
                <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn-header-cta">
                    <span>S'inscrire à un atelier</span>
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M5 12h14"/>
                        <path d="m12 5 7 7-7 7"/>
                    </svg>
                </a>
            </div>
        </div>
    </header>

    <main class="main-wrapper">

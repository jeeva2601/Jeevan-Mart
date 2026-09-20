<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'JeevanMart — Curated Classical Marketplace'}" /></title>
    <meta name="description" content="JeevanMart - Premium Multi-Seller Marketplace built on Java Servlets, H2, and Tomcat.">
    <meta name="_csrf" content="${csrfToken}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <meta name="theme-color" content="#0a0403">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='7' fill='%230a0403'/%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0' y1='0' x2='0.3' y2='1'%3E%3Cstop offset='0' stop-color='%23ffcf8a'/%3E%3Cstop offset='0.5' stop-color='%23ff5a1f'/%3E%3Cstop offset='1' stop-color='%23c8110a'/%3E%3C/linearGradient%3E%3C/defs%3E%3Cpath d='M21 5 C21 5 21 17 21 19 C21 24 17 27 12 27 C8.4 27 5.9 25.3 5 22.2' fill='none' stroke='url(%23g)' stroke-width='3.3' stroke-linecap='round'/%3E%3Cpath d='M21 11.5 C25 9.6 28.5 10.3 30.5 7.4 C29 10.8 27 13.5 22.3 14.7 Z' fill='url(%23g)'/%3E%3Cpath d='M21 5 L25.6 2.2 L22.3 7.3 Z' fill='url(%23g)'/%3E%3Ccircle cx='22.7' cy='4.5' r='0.9' fill='%230a0403'/%3E%3C/svg%3E">
</head>
<body>

<!-- Top Prestige Status Ribbon -->
<div class="prestige-bar">
    <div class="container prestige-container">
        <div>
            <span class="prestige-badge">Curated Marketplace</span> &bull; Verified Merchants &bull; Secure Checkout
        </div>
        <div>
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <span>Signed in as <strong><c:out value="${sessionScope.currentUser.name}" /></strong> (<c:out value="${sessionScope.currentUser.role}" />)</span>
                </c:when>
                <c:otherwise>
                    <span>Customer Concierge &amp; Order Inquiries</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Main Header -->
<header class="site-header">
    <div class="container header-inner">
        <!-- Brand Logo -->
        <a href="${pageContext.request.contextPath}/home" class="brand-logo" aria-label="JeevanMart Home">
            <div class="brand-symbol">
                <svg class="brand-mark" viewBox="0 0 32 32" width="22" height="22" aria-hidden="true" focusable="false">
                    <defs>
                        <linearGradient id="phoenixGradHeader" x1="0" y1="0" x2="0.3" y2="1">
                            <stop offset="0" stop-color="#ffcf8a"/>
                            <stop offset="0.5" stop-color="#ff5a1f"/>
                            <stop offset="1" stop-color="#c8110a"/>
                        </linearGradient>
                    </defs>
                    <!-- tail flame wisps trailing off the hook -->
                    <path d="M5 22.4 C2.4 24.1 1 26.9 0.6 29.6" fill="none" stroke="url(#phoenixGradHeader)" stroke-width="1.2" stroke-linecap="round" opacity="0.55"/>
                    <path d="M7.4 24.8 C5.4 26.8 4.2 29.1 3.7 31.3" fill="none" stroke="url(#phoenixGradHeader)" stroke-width="0.9" stroke-linecap="round" opacity="0.4"/>
                    <!-- rear wing (layered, smaller) -->
                    <path d="M20.2 14.1 C22.9 13.1 24.9 13.7 26.4 12.1 C25.1 14.1 23.4 15.9 20.7 16.3 Z" fill="url(#phoenixGradHeader)" opacity="0.55"/>
                    <!-- J-shaped body / neck, doubling as the phoenix's spine -->
                    <path d="M21 5 C21 5 21 17 21 19 C21 24 17 27 12 27 C8.4 27 5.9 25.3 5 22.2" fill="none" stroke="url(#phoenixGradHeader)" stroke-width="3.3" stroke-linecap="round"/>
                    <!-- forward wing, flaring like a flame -->
                    <path d="M21 11.5 C25 9.6 28.5 10.3 30.5 7.4 C29 10.8 27 13.5 22.3 14.7 Z" fill="url(#phoenixGradHeader)"/>
                    <!-- head / beak -->
                    <path d="M21 5 L25.6 2.2 L22.3 7.3 Z" fill="url(#phoenixGradHeader)"/>
                    <!-- eye -->
                    <circle cx="22.7" cy="4.5" r="0.9" fill="#0a0403"/>
                </svg>
            </div>
            <span class="brand-wordmark">
                <span class="brand-name">Jeevan<span>Mart</span></span>
                <span class="brand-tagline">Rise. Shop. Reborn.</span>
            </span>
        </a>

        <!-- Universal Search Bar -->
        <div class="header-search">
            <form action="${pageContext.request.contextPath}/products" method="GET" class="search-bar-form" role="search">
                <select name="category" class="search-category-select" aria-label="Select Category">
                    <option value="">All Categories</option>
                    <option value="Electronics" ${selectedCategory == 'Electronics' ? 'selected' : ''}>Electronics</option>
                    <option value="Books" ${selectedCategory == 'Books' ? 'selected' : ''}>Books</option>
                    <option value="Clothing" ${selectedCategory == 'Clothing' ? 'selected' : ''}>Clothing</option>
                    <option value="Home" ${selectedCategory == 'Home' ? 'selected' : ''}>Home &amp; Kitchen</option>
                </select>
                <input type="search" name="keyword" value="<c:out value='${keyword}' />" class="search-input" placeholder="Search curated products by name or keyword..." aria-label="Search Catalog">
                <button type="submit" class="search-btn" aria-label="Submit Search">Search</button>
            </form>
        </div>

        <!-- Navigation Menu -->
        <nav aria-label="Main Navigation">
            <button class="mobile-toggle" aria-expanded="false" aria-label="Toggle navigation menu">&#9776;</button>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/products" class="nav-link">Products</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories" class="nav-link">Categories</a></li>

                <c:if test="${sessionScope.currentUser.role == 'SELLER' || sessionScope.currentUser.role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/seller/dashboard" class="nav-link">Seller Hub</a></li>
                </c:if>
                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Admin</a></li>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <li><a href="${pageContext.request.contextPath}/orders" class="nav-link">Orders</a></li>
                        <li>
                            <a href="${pageContext.request.contextPath}/cart" class="nav-link cart-indicator" aria-label="Shopping Cart">
                                Cart <span class="cart-count" style="display:none;">0</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li>
                            <a href="${pageContext.request.contextPath}/cart" class="nav-link cart-indicator" aria-label="Shopping Cart">
                                Cart <span class="cart-count" style="display:none;">0</span>
                            </a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/login" class="nav-link">Sign In</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Join</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</header>

<main class="main-content" id="main-content">

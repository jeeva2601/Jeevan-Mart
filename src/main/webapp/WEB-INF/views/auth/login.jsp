<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Sign In — JeevanMart" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="auth-wrapper" style="min-height: calc(100vh - 350px); display: flex; align-items: center; justify-content: center; padding: var(--space-8) var(--space-4);">
    <div class="card auth-card" style="width: 100%; max-width: 420px; padding: var(--space-8); box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: var(--space-6);">
            <div class="brand-symbol" style="margin: 0 auto var(--space-3); width: 54px; height: 54px; flex-basis: 54px;">
                <svg class="brand-mark" viewBox="0 0 32 32" width="28" height="28" aria-hidden="true" focusable="false">
                    <defs>
                        <linearGradient id="phoenixGradLogin" x1="0" y1="0" x2="0.3" y2="1">
                            <stop offset="0" stop-color="#ffcf8a"/>
                            <stop offset="0.5" stop-color="#ff5a1f"/>
                            <stop offset="1" stop-color="#c8110a"/>
                        </linearGradient>
                    </defs>
                    <!-- tail flame wisps trailing off the hook -->
                    <path d="M5 22.4 C2.4 24.1 1 26.9 0.6 29.6" fill="none" stroke="url(#phoenixGradLogin)" stroke-width="1.2" stroke-linecap="round" opacity="0.55"/>
                    <path d="M7.4 24.8 C5.4 26.8 4.2 29.1 3.7 31.3" fill="none" stroke="url(#phoenixGradLogin)" stroke-width="0.9" stroke-linecap="round" opacity="0.4"/>
                    <!-- rear wing (layered, smaller) -->
                    <path d="M20.2 14.1 C22.9 13.1 24.9 13.7 26.4 12.1 C25.1 14.1 23.4 15.9 20.7 16.3 Z" fill="url(#phoenixGradLogin)" opacity="0.55"/>
                    <!-- J-shaped body / neck, doubling as the phoenix's spine -->
                    <path d="M21 5 C21 5 21 17 21 19 C21 24 17 27 12 27 C8.4 27 5.9 25.3 5 22.2" fill="none" stroke="url(#phoenixGradLogin)" stroke-width="3.3" stroke-linecap="round"/>
                    <!-- forward wing, flaring like a flame -->
                    <path d="M21 11.5 C25 9.6 28.5 10.3 30.5 7.4 C29 10.8 27 13.5 22.3 14.7 Z" fill="url(#phoenixGradLogin)"/>
                    <!-- head / beak -->
                    <path d="M21 5 L25.6 2.2 L22.3 7.3 Z" fill="url(#phoenixGradLogin)"/>
                    <!-- eye -->
                    <circle cx="22.7" cy="4.5" r="0.9" fill="#0a0403"/>
                </svg>
            </div>
            <h1 style="font-size: 1.75rem; margin-bottom: var(--space-1);">Welcome Back</h1>
            <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Sign in to your JeevanMart account</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" style="background-color: var(--danger-bg); color: var(--danger-text); border: 1px solid var(--danger-border); padding: var(--space-3) var(--space-4); border-radius: var(--radius-sm); font-size: 0.875rem; margin-bottom: var(--space-4);">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>
        <c:if test="${param.loggedOut == 'true'}">
            <div class="alert alert-success" style="background-color: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); padding: var(--space-3) var(--space-4); border-radius: var(--radius-sm); font-size: 0.875rem; margin-bottom: var(--space-4);">
                You have successfully signed out.
            </div>
        </c:if>
        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success" style="background-color: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); padding: var(--space-3) var(--space-4); border-radius: var(--radius-sm); font-size: 0.875rem; margin-bottom: var(--space-4);">
                Account registered successfully! Please sign in below.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST" class="form-auth" id="loginForm" onsubmit="JeevanMart.showFormLoading(this)">
            <input type="hidden" name="_csrf" value="${csrfToken}">

            <div class="form-group">
                <label for="email" class="form-label">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" class="form-control" required autofocus placeholder="name@domain.com" autocomplete="email">
            </div>

            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: baseline;">
                    <label for="password" class="form-label">Password <span class="required">*</span></label>
                </div>
                <div style="position: relative; display: flex; align-items: center;">
                    <input type="password" id="password" name="password" class="form-control password-field" required placeholder="••••••••" autocomplete="current-password" style="padding-right: 60px;">
                    <button type="button" class="btn-text btn-password-toggle" onclick="JeevanMart.togglePassword('password', this)" style="position: absolute; right: 4px; padding: 4px 8px; font-size: 0.75rem; color: var(--text-muted);" aria-label="Toggle password visibility">
                        Show
                    </button>
                </div>
            </div>

            <div style="margin-top: var(--space-6);">
                <button type="submit" class="btn btn-primary btn-block btn-lg submit-btn">
                    Sign In &rarr;
                </button>
            </div>
        </form>

        <div style="margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--border-subtle); text-align: center; font-size: 0.875rem; color: var(--text-muted);">
            Don't have an account yet? 
            <a href="${pageContext.request.contextPath}/register" style="font-weight: 600; color: var(--color-accent);">Create an account</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Create Account — JeevanMart" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="auth-wrapper" style="min-height: calc(100vh - 350px); display: flex; align-items: center; justify-content: center; padding: var(--space-8) var(--space-4);">
    <div class="card auth-card" style="width: 100%; max-width: 460px; padding: var(--space-8); box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: var(--space-6);">
            <div class="brand-symbol" style="margin: 0 auto var(--space-3); width: 54px; height: 54px; flex-basis: 54px;">
                <svg class="brand-mark" viewBox="0 0 32 32" width="28" height="28" aria-hidden="true" focusable="false">
                    <defs>
                        <linearGradient id="phoenixGradRegister" x1="0" y1="0" x2="0.3" y2="1">
                            <stop offset="0" stop-color="#ffcf8a"/>
                            <stop offset="0.5" stop-color="#ff5a1f"/>
                            <stop offset="1" stop-color="#c8110a"/>
                        </linearGradient>
                    </defs>
                    <!-- tail flame wisps trailing off the hook -->
                    <path d="M5 22.4 C2.4 24.1 1 26.9 0.6 29.6" fill="none" stroke="url(#phoenixGradRegister)" stroke-width="1.2" stroke-linecap="round" opacity="0.55"/>
                    <path d="M7.4 24.8 C5.4 26.8 4.2 29.1 3.7 31.3" fill="none" stroke="url(#phoenixGradRegister)" stroke-width="0.9" stroke-linecap="round" opacity="0.4"/>
                    <!-- rear wing (layered, smaller) -->
                    <path d="M20.2 14.1 C22.9 13.1 24.9 13.7 26.4 12.1 C25.1 14.1 23.4 15.9 20.7 16.3 Z" fill="url(#phoenixGradRegister)" opacity="0.55"/>
                    <!-- J-shaped body / neck, doubling as the phoenix's spine -->
                    <path d="M21 5 C21 5 21 17 21 19 C21 24 17 27 12 27 C8.4 27 5.9 25.3 5 22.2" fill="none" stroke="url(#phoenixGradRegister)" stroke-width="3.3" stroke-linecap="round"/>
                    <!-- forward wing, flaring like a flame -->
                    <path d="M21 11.5 C25 9.6 28.5 10.3 30.5 7.4 C29 10.8 27 13.5 22.3 14.7 Z" fill="url(#phoenixGradRegister)"/>
                    <!-- head / beak -->
                    <path d="M21 5 L25.6 2.2 L22.3 7.3 Z" fill="url(#phoenixGradRegister)"/>
                    <!-- eye -->
                    <circle cx="22.7" cy="4.5" r="0.9" fill="#0a0403"/>
                </svg>
            </div>
            <h1 style="font-size: 1.75rem; margin-bottom: var(--space-1);">Create an Account</h1>
            <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Join JeevanMart as a Discerning Buyer or Artisan Seller</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" style="background-color: var(--danger-bg); color: var(--danger-text); border: 1px solid var(--danger-border); padding: var(--space-3) var(--space-4); border-radius: var(--radius-sm); font-size: 0.875rem; margin-bottom: var(--space-4);">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST" class="form-auth" id="registerForm" onsubmit="JeevanMart.showFormLoading(this)">
            <input type="hidden" name="_csrf" value="${csrfToken}">

            <div class="form-group">
                <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                <input type="text" id="name" name="name" class="form-control" required placeholder="Johnathan Doe" autocomplete="name">
            </div>

            <div class="form-group">
                <label for="email" class="form-label">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" class="form-control" required placeholder="name@domain.com" autocomplete="email">
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password <span class="required">*</span> <span style="font-size: 0.75rem; color: var(--text-muted);">(min 6 characters)</span></label>
                <div style="position: relative; display: flex; align-items: center;">
                    <input type="password" id="password" name="password" class="form-control password-field" required minlength="6" placeholder="••••••••" autocomplete="new-password" style="padding-right: 60px;">
                    <button type="button" class="btn-text btn-password-toggle" onclick="JeevanMart.togglePassword('password', this)" style="position: absolute; right: 4px; padding: 4px 8px; font-size: 0.75rem; color: var(--text-muted);" aria-label="Toggle password visibility">
                        Show
                    </button>
                </div>
            </div>

            <div class="form-group">
                <label for="role" class="form-label">Account Privilege <span class="required">*</span></label>
                <select id="role" name="role" class="form-select" required>
                    <option value="BUYER" ${param.role == 'BUYER' || empty param.role ? 'selected' : ''}>Buyer — Browse, Curate &amp; Purchase</option>
                    <option value="SELLER" ${param.role == 'SELLER' ? 'selected' : ''}>Seller — Publish Listings &amp; Manage Orders</option>
                </select>
                <span class="form-hint">Sellers gain instant access to merchant inventory management.</span>
            </div>

            <div style="margin-top: var(--space-6);">
                <button type="submit" class="btn btn-primary btn-block btn-lg submit-btn">
                    Complete Registration &rarr;
                </button>
            </div>
        </form>

        <div style="margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--border-subtle); text-align: center; font-size: 0.875rem; color: var(--text-muted);">
            Already possess an account? 
            <a href="${pageContext.request.contextPath}/login" style="font-weight: 600; color: var(--color-accent);">Sign in</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

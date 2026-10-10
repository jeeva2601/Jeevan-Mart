<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>

<!-- Multi-tier Classical Footer -->
<footer class="site-footer">
    <div class="footer-top">
        <div class="container footer-grid">
            <div class="footer-col">
                <div class="brand-logo" style="margin-bottom: var(--space-4);">
                    <div class="brand-symbol">
                        <svg class="brand-mark" viewBox="0 0 32 32" width="22" height="22" aria-hidden="true" focusable="false">
                    <defs>
                        <linearGradient id="phoenixGradFooter" x1="0" y1="0" x2="0.3" y2="1">
                            <stop offset="0" stop-color="#ffcf8a"/>
                            <stop offset="0.5" stop-color="#ff5a1f"/>
                            <stop offset="1" stop-color="#c8110a"/>
                        </linearGradient>
                    </defs>
                    <!-- tail flame wisps trailing off the hook -->
                    <path d="M5 22.4 C2.4 24.1 1 26.9 0.6 29.6" fill="none" stroke="url(#phoenixGradFooter)" stroke-width="1.2" stroke-linecap="round" opacity="0.55"/>
                    <path d="M7.4 24.8 C5.4 26.8 4.2 29.1 3.7 31.3" fill="none" stroke="url(#phoenixGradFooter)" stroke-width="0.9" stroke-linecap="round" opacity="0.4"/>
                    <!-- rear wing (layered, smaller) -->
                    <path d="M20.2 14.1 C22.9 13.1 24.9 13.7 26.4 12.1 C25.1 14.1 23.4 15.9 20.7 16.3 Z" fill="url(#phoenixGradFooter)" opacity="0.55"/>
                    <!-- J-shaped body / neck, doubling as the phoenix's spine -->
                    <path d="M21 5 C21 5 21 17 21 19 C21 24 17 27 12 27 C8.4 27 5.9 25.3 5 22.2" fill="none" stroke="url(#phoenixGradFooter)" stroke-width="3.3" stroke-linecap="round"/>
                    <!-- forward wing, flaring like a flame -->
                    <path d="M21 11.5 C25 9.6 28.5 10.3 30.5 7.4 C29 10.8 27 13.5 22.3 14.7 Z" fill="url(#phoenixGradFooter)"/>
                    <!-- head / beak -->
                    <path d="M21 5 L25.6 2.2 L22.3 7.3 Z" fill="url(#phoenixGradFooter)"/>
                    <!-- eye -->
                    <circle cx="22.7" cy="4.5" r="0.9" fill="#0a0403"/>
                </svg>
                    </div>
                    <span class="brand-name" style="color: var(--text-primary);">Jeevan<span style="color: var(--color-accent);">Mart</span></span>
                </div>
                <p style="color: #94a3b8; font-size: 0.875rem; line-height: 1.6;">
                    A curated multi-seller commerce destination engineered for discerning buyers and verified artisans. Built on enterprise Java, Servlets, HikariCP, and H2.
                </p>
            </div>
            <div class="footer-col">
                <h4>Collections</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/products?category=Electronics">Fine Electronics</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Books">Timeless Literature</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Clothing">Apparel &amp; Textiles</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Home">Home &amp; Sanctuary</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Marketplace</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/products">Browse Catalog</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">Track Orders</a></li>
                    <li><a href="${pageContext.request.contextPath}/seller/dashboard">Merchant Portal</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Integrity &amp; Standards</h4>
                <ul>
                    <li><span style="color: #cbd5e1; font-size: 0.875rem;">7-Day Refund Guarantee</span></li>
                    <li><span style="color: #cbd5e1; font-size: 0.875rem;">Verified Merchant Auditing</span></li>
                    <li><span style="color: #cbd5e1; font-size: 0.875rem;">Transactional Escrow</span></li>
                    <li><span style="color: #cbd5e1; font-size: 0.875rem;">Zero Injected Adware</span></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <p>&copy; 2026 JeevanMart. Academic Capstone Project. Engineered with classical precision.</p>
        </div>
    </div>
</footer>

<!-- Global Component Containers -->
<div id="toast-container" aria-live="polite"></div>
<div id="confirm-modal" class="modal-backdrop" role="dialog" aria-modal="true"></div>
<div id="global-loader"></div>

<!-- JeevanMart marketplace assistant (API key remains server-side) -->
<div id="jm-chatbot" class="jm-chatbot" data-context-path="${pageContext.request.contextPath}">
    <section class="jm-chat-panel" id="jm-chat-panel" role="dialog" aria-label="JeevanMart assistant" aria-modal="false" hidden>
        <header class="jm-chat-header">
            <div>
                <strong>JeevanMart Assistant</strong>
                <span>Product and marketplace help</span>
            </div>
            <button type="button" class="jm-chat-close" id="jm-chat-close" aria-label="Close chat">&times;</button>
        </header>
        <div class="jm-chat-messages" id="jm-chat-messages" aria-live="polite">
            <div class="jm-chat-bubble jm-chat-bot">Hello! Ask me about products, listings, your cart, checkout, orders, delivery, or reviews.</div>
        </div>
        <form class="jm-chat-form" id="jm-chat-form">
            <label class="jm-chat-sr-only" for="jm-chat-input">Your question</label>
            <textarea id="jm-chat-input" name="message" rows="2" maxlength="500" placeholder="Ask about JeevanMart..." required></textarea>
            <button type="submit" id="jm-chat-send">Send</button>
        </form>
        <p class="jm-chat-note">Please do not share passwords or payment details.</p>
    </section>
    <button type="button" id="jm-chat-launcher" class="jm-chat-launcher" aria-controls="jm-chat-panel" aria-expanded="false">
        <span aria-hidden="true">&#128172;</span> Chat with us
    </button>
</div>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chatbot.css">
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/chatbot.js" defer></script>
</body>
</html>

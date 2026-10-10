(function () {
    "use strict";
    document.addEventListener("DOMContentLoaded", function () {
        const root = document.getElementById("jm-chatbot");
        if (!root) return;
        const panel = document.getElementById("jm-chat-panel");
        const launcher = document.getElementById("jm-chat-launcher");
        const close = document.getElementById("jm-chat-close");
        const form = document.getElementById("jm-chat-form");
        const input = document.getElementById("jm-chat-input");
        const send = document.getElementById("jm-chat-send");
        const messages = document.getElementById("jm-chat-messages");
        const contextPath = root.dataset.contextPath || "";

        function appendMessage(text, kind) {
            const bubble = document.createElement("div");
            bubble.className = "jm-chat-bubble " + (kind === "user" ? "jm-chat-user" : "jm-chat-bot");
            bubble.textContent = text;
            messages.appendChild(bubble);
            messages.scrollTop = messages.scrollHeight;
            return bubble;
        }
        function setOpen(open) {
            panel.hidden = !open;
            launcher.setAttribute("aria-expanded", String(open));
            if (open) input.focus();
        }
        launcher.addEventListener("click", function () { setOpen(panel.hidden); });
        close.addEventListener("click", function () { setOpen(false); launcher.focus(); });
        form.addEventListener("submit", async function (event) {
            event.preventDefault();
            const message = input.value.trim();
            if (!message || send.disabled) return;
            appendMessage(message, "user");
            input.value = "";
            send.disabled = true;
            const status = document.createElement("div");
            status.className = "jm-chat-status";
            status.textContent = "JeevanMart Assistant is thinking…";
            messages.appendChild(status);
            messages.scrollTop = messages.scrollHeight;
            const controller = new AbortController();
            const timeoutId = window.setTimeout(function () { controller.abort(); }, 10000);
            try {
                const csrfMeta = document.querySelector('meta[name="_csrf"]');
                const headers = { "Content-Type": "application/json", "Accept": "application/json" };
                if (csrfMeta && csrfMeta.content) headers["X-CSRF-Token"] = csrfMeta.content;
                const response = await fetch(contextPath + "/api/v1/chat", {
                    method: "POST",
                    headers: headers,
                    credentials: "same-origin",
                    body: JSON.stringify({ message: message }),
                    signal: controller.signal
                });
                const payload = await response.json();
                if (!response.ok || !payload.success) {
                    const detail = payload && payload.error && payload.error.message;
                    throw new Error(detail || (response.status === 429
                        ? "Please wait a minute before sending more questions."
                        : "Chat is temporarily unavailable."));
                }
                const data = payload.data || {};
                appendMessage(data.reply || "Sorry, I couldn't create a reply. Please try again.", "bot");
            } catch (error) {
                appendMessage(error.name === "AbortError"
                    ? "The request took too long. Please try again."
                    : (error.message || "Chat is temporarily unavailable. Please try again."), "bot");
            } finally {
                window.clearTimeout(timeoutId);
                status.remove();
                send.disabled = false;
                input.focus();
            }
        });
    });
}());

package com.jeevan.jeevanmart.controller;

import com.jeevan.jeevanmart.dto.UserResponseDTO;
import com.jeevan.jeevanmart.service.ChatService;
import com.jeevan.jeevanmart.service.impl.ChatServiceImpl;
import com.jeevan.jeevanmart.exception.ValidationException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet(
    name = "ChatServlet",
    urlPatterns = {"/api/chat", "/api/v1/chat"}
)
public class ChatServlet extends BaseServlet {

    private static final int MAX_MESSAGE_LENGTH = 500;
    private static final int MAX_MESSAGES_PER_MINUTE = 10;
    private static final long RATE_WINDOW_MS = 60000L;

    private static final String RATE_KEY =
        ChatServlet.class.getName() + ".rate";

    private static final String CACHE_KEY =
        ChatServlet.class.getName() + ".cache";

    private final ChatService chatService;

    public ChatServlet() {
        this(new ChatServiceImpl());
    }

    public ChatServlet(ChatService chatService) {
        this.chatService = chatService;
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        try {
            String message = null;

            try {
                Map<String, Object> body =
                    readJsonBody(request, Map.class);

                if (body != null && body.get("message") != null) {
                    Object value = body.get("message");

                    if (!(value instanceof String)) {
                        throw new ValidationException(
                            "Message must be text",
                            "VALIDATION_ERROR"
                        );
                    }

                    message = (String) value;
                }
            } catch (ValidationException e) {
                throw e;
            } catch (Exception ignored) {
                // Allow form parameters if JSON parsing fails.
            }

            if (message == null) {
                message = request.getParameter("message");
            }

            if (message == null || message.trim().isEmpty()) {
                throw new ValidationException(
                    "Chat message cannot be empty",
                    "EMPTY_MESSAGE"
                );
            }

            message = message.trim();

            if (message.length() > MAX_MESSAGE_LENGTH) {
                throw new ValidationException(
                    "Chat message must be 500 characters or fewer",
                    "MESSAGE_TOO_LONG"
                );
            }

            HttpSession session = request.getSession(true);

            if (!allowRequest(session)) {
                writeJsonError(
                    response,
                    429,
                    "RATE_LIMITED",
                    "Chat limit reached. Please wait a minute."
                );
                return;
            }

            String cacheKey = message.toLowerCase(Locale.ROOT);
            Map<String, String> cache = getCache(session);
            String reply;

            synchronized (cache) {
                reply = cache.get(cacheKey);
            }

            if (reply == null) {
                UserResponseDTO currentUser = getSessionUser(request);
                Long userId = currentUser == null
                    ? null : currentUser.getId();

                reply = chatService.processMessage(message, userId);

                synchronized (cache) {
                    cache.put(cacheKey, reply);

                    while (cache.size() > 50) {
                        String oldest =
                            cache.keySet().iterator().next();
                        cache.remove(oldest);
                    }
                }
            }

            writeJsonResponse(
                response,
                HttpServletResponse.SC_OK,
                "Chat response generated successfully",
                Collections.singletonMap("reply", reply)
            );

        } catch (Exception e) {
            handleException(response, e, true);
        }
    }

    private boolean allowRequest(HttpSession session) {
        @SuppressWarnings("unchecked")
        Deque<Long> timestamps =
            (Deque<Long>) session.getAttribute(RATE_KEY);

        if (timestamps == null) {
            timestamps = new ArrayDeque<>();
            session.setAttribute(RATE_KEY, timestamps);
        }

        long now = System.currentTimeMillis();

        synchronized (timestamps) {
            while (!timestamps.isEmpty()
                    && now - timestamps.peekFirst() >= RATE_WINDOW_MS) {
                timestamps.removeFirst();
            }

            if (timestamps.size() >= MAX_MESSAGES_PER_MINUTE) {
                return false;
            }

            timestamps.addLast(now);
            return true;
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, String> getCache(HttpSession session) {
        synchronized (session) {
            Object existing = session.getAttribute(CACHE_KEY);

            if (existing instanceof Map) {
                return (Map<String, String>) existing;
            }

            Map<String, String> cache = new LinkedHashMap<>();
            session.setAttribute(CACHE_KEY, cache);
            return cache;
        }
    }
}
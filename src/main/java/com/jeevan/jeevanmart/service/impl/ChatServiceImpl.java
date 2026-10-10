package com.jeevan.jeevanmart.service.impl;

import com.jeevan.jeevanmart.service.ChatService;
import com.jeevan.jeevanmart.service.provider.ChatProvider;
import com.jeevan.jeevanmart.service.provider.GeminiChatProvider;
import com.jeevan.jeevanmart.service.provider.MockChatProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.util.Properties;

/**
 * Chat service enforcing the marketplace-only scope and providing a degraded fallback.
 */
public class ChatServiceImpl implements ChatService {
    private static final Logger LOGGER = LoggerFactory.getLogger(ChatServiceImpl.class);
    private static final String DOMAIN_CONTEXT =
            "You are JeevanMart's marketplace assistant. Answer only questions about "
            + "JeevanMart products, listings, categories, sellers, cart, checkout, orders, "
            + "delivery, returns, reviews, and account use. If asked about unrelated topics, "
            + "politely say you can only help with JeevanMart marketplace questions. "
            + "Do not claim access to private order/account data. Keep answers concise.";
    private final ChatProvider provider;
    private final ChatProvider fallbackProvider;

    public ChatServiceImpl() {
        this(createConfiguredProvider());
    }

    public ChatServiceImpl(ChatProvider provider) {
        this.provider = provider;
        this.fallbackProvider = new MockChatProvider();
    }

    private static ChatProvider createConfiguredProvider() {
        String selected = System.getenv("AI_CHATBOT_PROVIDER");
        if (selected == null || selected.trim().isEmpty()) {
            Properties properties = new Properties();
            try (InputStream input = ChatServiceImpl.class.getClassLoader()
                    .getResourceAsStream("config.properties")) {
                if (input != null) properties.load(input);
            } catch (Exception exception) {
                LoggerFactory.getLogger(ChatServiceImpl.class)
                        .warn("Could not load chatbot configuration; using mock provider");
            }
            selected = properties.getProperty("ai.chatbot.provider", "mock");
        }
        return "gemini".equalsIgnoreCase(selected.trim())
                ? new GeminiChatProvider() : new MockChatProvider();
    }

    @Override
    public String processMessage(String userMessage, Long userId) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Please enter a question about JeevanMart.";
        }
        String message = userMessage.trim();
        try {
            String reply = provider.getReply(message, DOMAIN_CONTEXT);
            if (reply != null && !reply.trim().isEmpty()) return reply.trim();
        } catch (Exception exception) {
            LOGGER.warn("Chat provider unavailable; returning marketplace FAQ fallback: {}",
                    exception.getClass().getSimpleName());
        }

try {
    return fallbackProvider.getReply(message, DOMAIN_CONTEXT);
} catch (Exception exception) {
    LOGGER.error("Chatbot fallback provider also failed: {}",
            exception.getClass().getSimpleName());
    return "Sorry, the JeevanMart chatbot is temporarily unavailable. Please try again.";
}
    }
}

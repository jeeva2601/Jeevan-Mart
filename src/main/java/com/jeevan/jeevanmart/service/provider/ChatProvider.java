package com.jeevan.jeevanmart.service.provider;

/**
 * Strategy interface for swappable server-side chatbot providers.
 */
public interface ChatProvider {
    /**
     * Gets a response for a product/listing-domain question.
     *
     * @param userMessage validated user question
     * @param context fixed server-side domain guidance
     * @return provider response
     * @throws Exception if the provider cannot generate a response
     */
    String getReply(String userMessage, String context) throws Exception;
}

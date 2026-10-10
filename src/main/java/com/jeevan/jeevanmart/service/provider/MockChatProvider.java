package com.jeevan.jeevanmart.service.provider;

import java.util.Locale;

/**
 * Offline provider with canned FAQ answers for development and demos.
 */
public class MockChatProvider implements ChatProvider {
    @Override
    public String getReply(String userMessage, String context) {
        String query = userMessage.toLowerCase(Locale.ROOT);
        if (query.contains("return") || query.contains("refund")) {
            return "For a return or refund, open your Orders page and review the options for that order. Return eligibility depends on the listing and order policy.";
        }
        if (query.contains("shipping") || query.contains("delivery")) {
            return "Delivery timing depends on the seller and destination. Check your order details for the latest status available in JeevanMart.";
        }
        if (query.contains("order") || query.contains("status") || query.contains("track")) {
            return "Sign in and open Orders to review your order history and current status.";
        }
        if (query.contains("product") || query.contains("search") || query.contains("buy") || query.contains("category")) {
            return "Open Products to browse listings. Use the category filter or search box to narrow results, then open a product to see its details and availability.";
        }
        if (query.contains("seller") || query.contains("list")) {
            return "Sellers can sign in and use the Seller Hub to manage their product listings, subject to their account role.";
        }
        if (query.contains("cart")) {
            return "Open a product and choose Add to Cart. You can review quantities and the total from the Cart page before checkout.";
        }
        if (query.contains("payment") || query.contains("checkout")) {
            return "JeevanMart checkout uses the project's mock payment confirmation flow. Review your cart and follow the checkout prompts to place an order.";
        }
        if (query.contains("review") || query.contains("rating")) {
            return "Reviews and star ratings are available for eligible completed purchases. Open the relevant product or order page to see the available review controls.";
        }
        if (query.contains("account") || query.contains("register") || query.contains("login") || query.contains("sign in")) {
            return "Use Join to create a Buyer or Seller account, or Sign In if you already have an account.";
        }
        return "I can help with JeevanMart products, listings, cart, checkout, orders, reviews, and seller accounts. What would you like to know?";
    }
}

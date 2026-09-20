package com.jeevan.jeevanmart.service;

import com.jeevan.jeevanmart.dao.BaseDAOTest;
import com.jeevan.jeevanmart.dao.CartDAO;
import com.jeevan.jeevanmart.dao.OrderDAO;
import com.jeevan.jeevanmart.dao.ProductDAO;
import com.jeevan.jeevanmart.dao.UserDAO;
import com.jeevan.jeevanmart.dao.impl.CartDAOImpl;
import com.jeevan.jeevanmart.dao.impl.OrderDAOImpl;
import com.jeevan.jeevanmart.dao.impl.ProductDAOImpl;
import com.jeevan.jeevanmart.dao.impl.UserDAOImpl;
import com.jeevan.jeevanmart.exception.AppException;
import com.jeevan.jeevanmart.exception.AuthorizationException;
import com.jeevan.jeevanmart.exception.DatabaseException;
import com.jeevan.jeevanmart.exception.InsufficientStockException;
import com.jeevan.jeevanmart.exception.OrderException;
import com.jeevan.jeevanmart.exception.ValidationException;
import com.jeevan.jeevanmart.model.Order;
import com.jeevan.jeevanmart.model.OrderStatus;
import com.jeevan.jeevanmart.model.Product;
import com.jeevan.jeevanmart.model.Role;
import com.jeevan.jeevanmart.model.User;
import com.jeevan.jeevanmart.service.impl.OrderServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class OrderServiceIntegrationTest extends BaseDAOTest {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    private OrderService orderService;

    private Long buyerId;
    private Long sellerId;
    private Long productId1;
    private Long productId2;

    @BeforeEach
    void setUp() throws DatabaseException, AppException {
        this.orderDAO = new OrderDAOImpl();
        this.cartDAO = new CartDAOImpl();
        this.productDAO = new ProductDAOImpl();
        this.userDAO = new UserDAOImpl();

        this.orderService = new OrderServiceImpl(orderDAO, cartDAO, productDAO);

        User seller = userDAO.save(new User(null, "Seller", "orderservice_seller@test.com", "hash", Role.SELLER, null));
        User buyer = userDAO.save(new User(null, "Buyer", "orderservice_buyer@test.com", "hash", Role.BUYER, null));
        this.sellerId = seller.getId();
        this.buyerId = buyer.getId();

        Product p1 = productDAO.save(new Product(null, sellerId, "Keyboard", "Mechanical", new BigDecimal("100.00"), 10, "Electronics", null, null));
        Product p2 = productDAO.save(new Product(null, sellerId, "Cable", "USB-C", new BigDecimal("20.00"), 20, "Electronics", null, null));
        this.productId1 = p1.getId();
        this.productId2 = p2.getId();
    }

    @Test
    @DisplayName("Should execute 10-step atomic checkout transaction successfully")
    void testCheckoutAtomicSuccess() throws AppException {
        cartDAO.add(buyerId, productId1, 2); // 200.00
        cartDAO.add(buyerId, productId2, 1); // 20.00

        Order order = orderService.checkout(buyerId);

        assertNotNull(order.getId());
        assertEquals(OrderStatus.CONFIRMED, order.getStatus());
        assertEquals(0, new BigDecimal("220.00").compareTo(order.getTotalAmount()));

        // Check stock reduced
        assertEquals(8, productDAO.findById(productId1).orElseThrow().getStockQty());
        assertEquals(19, productDAO.findById(productId2).orElseThrow().getStockQty());

        // Check cart cleared
        assertTrue(cartDAO.findByUser(buyerId).isEmpty());
    }

    @Test
    @DisplayName("Should reject checkout with empty cart")
    void testCheckoutEmptyCart() {
        assertThrows(ValidationException.class, () -> orderService.checkout(buyerId));
    }

    @Test
    @DisplayName("Should rollback transaction when any item has insufficient stock")
    void testCheckoutInsufficientStockRollback() throws AppException {
        cartDAO.add(buyerId, productId1, 15); // only 10 in stock

        assertThrows(InsufficientStockException.class, () -> orderService.checkout(buyerId));

        // Verify stock is untouched (no partial deductions)
        assertEquals(10, productDAO.findById(productId1).orElseThrow().getStockQty());

        // Cart is NOT cleared
        assertEquals(1, cartDAO.findByUser(buyerId).size());
    }

    @Test
    @DisplayName("Should enforce role-based viewing permissions on orders")
    void testRoleBasedOrderVisibility() throws AppException {
        cartDAO.add(buyerId, productId1, 1);
        Order order = orderService.checkout(buyerId);

        // Buyer can view own order
        Order buyerView = orderService.getOrderById(order.getId(), buyerId, "BUYER");
        assertEquals(order.getId(), buyerView.getId());

        // Other buyer cannot view
        assertThrows(AuthorizationException.class, () -> orderService.getOrderById(order.getId(), 9999L, "BUYER"));

        // Seller of product can view
        Order sellerView = orderService.getOrderById(order.getId(), sellerId, "SELLER");
        assertEquals(order.getId(), sellerView.getId());

        // Admin can view any order
        Order adminView = orderService.getOrderById(order.getId(), 8888L, "ADMIN");
        assertEquals(order.getId(), adminView.getId());
    }

    @Test
    @DisplayName("Should cancel order, update status to CANCELLED, and restore product stock")
    void testCancelOrderAndRestoreStock() throws AppException {
        cartDAO.add(buyerId, productId1, 2);
        Order order = orderService.checkout(buyerId);

        assertEquals(8, productDAO.findById(productId1).orElseThrow().getStockQty());

        orderService.cancelOrder(order.getId(), buyerId, "BUYER");

        Order cancelledOrder = orderService.getOrderById(order.getId());
        assertEquals(OrderStatus.CANCELLED, cancelledOrder.getStatus());

        // Stock must be restored to 10
        assertEquals(10, productDAO.findById(productId1).orElseThrow().getStockQty());

        // Cannot cancel already cancelled order
        assertThrows(OrderException.class, () -> orderService.cancelOrder(order.getId(), buyerId, "BUYER"));
    }

    @Test
    @DisplayName("Should reject cancellation when order is already SHIPPED or DELIVERED")
    void testCancelOrderDisallowedStates() throws AppException {
        cartDAO.add(buyerId, productId1, 1);
        Order order = orderService.checkout(buyerId);

        orderService.updateOrderStatus(order.getId(), OrderStatus.SHIPPED);

        assertThrows(OrderException.class, () -> orderService.cancelOrder(order.getId(), buyerId, "BUYER"));
    }
}

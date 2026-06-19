package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private String userId;
    private String productName;
    private int quantity;
    private int unitPrice;
    private int totalPrice;
    private LocalDateTime orderDate;
    private String paymentMethod;

    // コンストラクタ
    public Order(String userId, String productName, int quantity, int unitPrice, int totalPrice, 
                 LocalDateTime orderDate, String paymentMethod) {
        this.userId = userId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.orderDate = orderDate;
        this.paymentMethod = paymentMethod;
    }

    // ゲッターのみ（表示専用のため）
    public String getUserId() { return userId; }
    public String getProductName() { return productName; }
    public int getQuantity() { return quantity; }
    public int getUnitPrice() { return unitPrice; }
    public int getTotalPrice() { return totalPrice; }
    public LocalDateTime getOrderDate() { return orderDate; }
    public String getPaymentMethod() { return paymentMethod; }
}
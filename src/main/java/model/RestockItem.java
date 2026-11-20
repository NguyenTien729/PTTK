package model;

import java.math.BigDecimal;

public class RestockItem {

    public int productId, quantity;
    public String name;
    public BigDecimal unitPrice;

    public RestockItem(int id, String name, int quantity, BigDecimal price) {
        this.productId = id;
        this.name = name;
        this.quantity = quantity;
        this.unitPrice = price;
    }

    public BigDecimal total() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}

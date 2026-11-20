package model;

import java.math.BigDecimal;

public class Product {

    public int id, instock;
    public String name, description, type;
    public BigDecimal price;

    public Product(
        int id,
        String name,
        int instock,
        BigDecimal price,
        String description,
        String type
    ) {
        this.id = id;
        this.name = name;
        this.instock = instock;
        this.price = price;
        this.description = description;
        this.type = type;
    }
}

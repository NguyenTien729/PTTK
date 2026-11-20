package model;

public class Supplier {

    public int id;
    public String name, phone, email, address;

    public Supplier(int id, String name, String phone, String email, String address) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }
}

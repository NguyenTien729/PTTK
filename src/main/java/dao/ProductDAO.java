package dao;

import java.math.*;
import java.sql.*;
import java.util.*;
import model.Product;

public class ProductDAO extends DAO {

    public List<Product> getProduct(String name) throws SQLException {
        List<Product> out = new ArrayList<>();
        try (
            Connection c = connect();
            PreparedStatement q = c.prepareStatement(
                "SELECT p.id,p.name,p.instock,p.price,p.description,t.name FROM tblProduct p JOIN tblProductType t ON t.id=p.tblProductTypeId WHERE p.name LIKE ? ORDER BY p.name"
            )
        ) {
            q.setString(1, "%" + name + "%");
            try (ResultSet r = q.executeQuery()) {
                while (r.next())
                    out.add(
                        new Product(
                            r.getInt(1),
                            r.getString(2),
                            r.getInt(3),
                            r.getBigDecimal(4),
                            r.getString(5),
                            r.getString(6)
                        )
                    );
            }
        }
        return out;
    }

    public void saveProduct(String name, String type, String description, BigDecimal price)
        throws SQLException {
        try (Connection c = connect()) {
            c.setAutoCommit(false);
            try {
                int typeId;
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblProductType(name) VALUES(?) ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id)",
                        Statement.RETURN_GENERATED_KEYS
                    )
                ) {
                    q.setString(1, type);
                    q.executeUpdate();
                    try (ResultSet r = q.getGeneratedKeys()) {
                        r.next();
                        typeId = r.getInt(1);
                    }
                }
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblProduct(name,instock,price,description,tblProductTypeId) VALUES(?,0,?,?,?)"
                    )
                ) {
                    q.setString(1, name);
                    q.setBigDecimal(2, price);
                    q.setString(3, description);
                    q.setInt(4, typeId);
                    q.executeUpdate();
                }
                c.commit();
            } catch (SQLException | RuntimeException e) {
                c.rollback();
                throw e;
            }
        }
    }
}

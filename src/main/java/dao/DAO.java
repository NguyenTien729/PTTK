package dao;

import java.sql.*;

public class DAO {

    public Connection connect() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver is missing", e);
        }
        String url = System.getenv().getOrDefault(
            "SHOPMAN_DB_URL",
            "jdbc:mysql://localhost:3306/shopman32?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh"
        );
        return DriverManager.getConnection(
            url,
            System.getenv().getOrDefault("SHOPMAN_DB_USER", "tien"),
            System.getenv().getOrDefault("SHOPMAN_DB_PASSWORD", "max1236987")
        );
    }
}

package dao;

import java.sql.*;
import java.util.*;
import model.Supplier;

public class SupplierDAO extends DAO {

    private boolean hasColumn(Connection c, String table, String column) throws SQLException {
        try (ResultSet r = c.getMetaData().getColumns(c.getCatalog(), null, table, column)) {
            return r.next();
        }
    }

    public List<Supplier> getSupplier(String name) throws SQLException {
        List<Supplier> out = new ArrayList<>();
        try (Connection c = connect()) {
            boolean normalized = hasColumn(c, "tblSupplier", "tblAddressId")
                && hasColumn(c, "tblAddress", "city");
            String sql = normalized
                ? "SELECT s.id,s.name,s.phone,s.email,CONCAT_WS(', ',a.houseNumber,a.building,a.street,a.ward,a.district,a.city) FROM tblSupplier s JOIN tblAddress a ON a.id=s.tblAddressId WHERE s.name LIKE ? ORDER BY s.name"
                : "SELECT id,name,phone,email,fullAddress FROM tblSupplier WHERE name LIKE ? ORDER BY name";
            try (PreparedStatement q = c.prepareStatement(sql)) {
                q.setString(1, "%" + name + "%");
                try (ResultSet r = q.executeQuery()) {
                    while (r.next()) out.add(new Supplier(r.getInt(1), r.getString(2),
                        r.getString(3), r.getString(4), r.getString(5)));
                }
            }
        }
        return out;
    }

    public void saveSupplier(String name, String phone, String email, String note,
        String houseNumber, String building, String street, String ward, String district,
        String city, String contactPerson) throws SQLException {
        try (Connection c = connect()) {
            c.setAutoCommit(false);
            try {
                boolean normalized = hasColumn(c, "tblSupplier", "tblAddressId")
                    && hasColumn(c, "tblAddress", "city");
                if (normalized) {
                    int addressId;
                    try (PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblAddress(houseNumber,building,street,ward,district,city) VALUES(?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                        q.setString(1, houseNumber); q.setString(2, building); q.setString(3, street);
                        q.setString(4, ward); q.setString(5, district); q.setString(6, city);
                        q.executeUpdate();
                        try (ResultSet keys = q.getGeneratedKeys()) { keys.next(); addressId = keys.getInt(1); }
                    }
                    try (PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblSupplier(name,phone,email,note,tblAddressId,contactPerson,status) VALUES(?,?,?,?,?,?,?)")) {
                        q.setString(1,name); q.setString(2,phone); q.setString(3,email); q.setString(4,note);
                        q.setInt(5,addressId); q.setString(6,contactPerson); q.setString(7,"ACTIVE"); q.executeUpdate();
                    }
                } else {
                    String address = String.join(", ", Arrays.asList(houseNumber, building, street, ward, district, city)
                        .stream().filter(s -> s != null && !s.trim().isEmpty()).toArray(String[]::new));
                    try (PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblSupplier(name,fullAddress,phone,email) VALUES(?,?,?,?)")) {
                        q.setString(1,name); q.setString(2,address); q.setString(3,phone); q.setString(4,email);
                        q.executeUpdate();
                    }
                }
                c.commit();
            } catch (SQLException | RuntimeException e) { c.rollback(); throw e; }
        }
    }
}

package dao;

import java.math.*;
import java.sql.*;
import java.util.*;
import model.RestockItem;

public class ReceiptDAO extends DAO {

    public int saveReceipt(int managerId, int supplierId, List<RestockItem> items)
        throws SQLException {
        if (items == null || items.isEmpty()) throw new IllegalArgumentException(
            "Hóa đơn chưa có mặt hàng"
        );
        try (Connection c = connect()) {
            c.setAutoCommit(false);
            try {
                try (
                    PreparedStatement q = c.prepareStatement(
                        "SELECT tblUserId FROM tblManager WHERE tblUserId=?"
                    )
                ) {
                    q.setInt(1, managerId);
                    try (ResultSet r = q.executeQuery()) {
                        if (!r.next()) throw new IllegalArgumentException(
                            "Tài khoản không có quyền quản lý"
                        );
                    }
                }
                BigDecimal total = BigDecimal.ZERO;
                for (RestockItem i : items) total = total.add(i.total());
                int id;
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblRestockReceipt(restockDate,total,status,tblManagerId,tblSupplierId) VALUES(NOW(),?,'UNPAID',?,?)",
                        Statement.RETURN_GENERATED_KEYS
                    )
                ) {
                    q.setBigDecimal(1, total);
                    q.setInt(2, managerId);
                    q.setInt(3, supplierId);
                    q.executeUpdate();
                    try (ResultSet r = q.getGeneratedKeys()) {
                        r.next();
                        id = r.getInt(1);
                    }
                }
                for (RestockItem i : items) {
                    try (
                        PreparedStatement q = c.prepareStatement(
                            "INSERT INTO tblRestockReceiptDetail(amount,unitPrice,tblRestockReceiptId,tblProductId) VALUES(?,?,?,?)"
                        )
                    ) {
                        q.setInt(1, i.quantity);
                        q.setBigDecimal(2, i.unitPrice);
                        q.setInt(3, id);
                        q.setInt(4, i.productId);
                        q.executeUpdate();
                    }
                    try (
                        PreparedStatement q = c.prepareStatement(
                            "UPDATE tblProduct SET instock=instock+? WHERE id=?"
                        )
                    ) {
                        q.setInt(1, i.quantity);
                        q.setInt(2, i.productId);
                        if (q.executeUpdate() != 1) throw new SQLException(
                            "Mặt hàng không tồn tại"
                        );
                    }
                }
                c.commit();
                return id;
            } catch (SQLException | RuntimeException e) {
                c.rollback();
                throw e;
            }
        }
    }

    public List<Map<String, Object>> getReceipt() throws SQLException {
        List<Map<String, Object>> out = new ArrayList<>();
        try (
            Connection c = connect();
            PreparedStatement q = c.prepareStatement(
                "SELECT r.id,r.restockDate,r.total,r.status,s.name supplier FROM tblRestockReceipt r JOIN tblSupplier s ON s.id=r.tblSupplierId ORDER BY r.id DESC"
            );
            ResultSet rs = q.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> x = new HashMap<>();
                for (String k : new String[] { "id", "restockDate", "total", "status", "supplier" })
                    x.put(k, rs.getObject(k));
                out.add(x);
            }
        }
        return out;
    }

    public Map<String, Object> getReceiptDetail(int id) throws SQLException {
        Map<String, Object> out = new HashMap<>();
        try (Connection c = connect()) {
            try (
                PreparedStatement q = c.prepareStatement(
                    "SELECT r.id,r.restockDate,r.total,r.status,s.name supplier,s.fullAddress supplierAddress,s.phone supplierPhone FROM tblRestockReceipt r JOIN tblSupplier s ON s.id=r.tblSupplierId WHERE r.id=?"
                )
            ) {
                q.setInt(1, id);
                try (ResultSet rs = q.executeQuery()) {
                    if (!rs.next()) return null;
                    for (String k : new String[] {
                        "id",
                        "restockDate",
                        "total",
                        "status",
                        "supplier",
                        "supplierAddress",
                        "supplierPhone",
                    })
                        out.put(k, rs.getObject(k));
                }
            }
            List<Map<String, Object>> items = new ArrayList<>();
            try (
                PreparedStatement q = c.prepareStatement(
                    "SELECT p.name, d.amount,d.unitPrice,(d.amount*d.unitPrice) lineTotal FROM tblRestockReceiptDetail d JOIN tblProduct p ON p.id=d.tblProductId WHERE d.tblRestockReceiptId=?"
                )
            ) {
                q.setInt(1, id);
                try (ResultSet rs = q.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> x = new HashMap<>();
                        for (String k : new String[] { "name", "amount", "unitPrice", "lineTotal" })
                            x.put(k, rs.getObject(k));
                        items.add(x);
                    }
                }
            }
            out.put("items", items);
        }
        return out;
    }
}

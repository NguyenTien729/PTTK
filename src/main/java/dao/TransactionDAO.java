package dao;

import java.sql.*;

public class TransactionDAO extends DAO {

    public void saveTransaction(int receiptId) throws SQLException {
        try (Connection c = connect()) {
            c.setAutoCommit(false);
            try {
                String status;
                try (
                    PreparedStatement q = c.prepareStatement(
                        "SELECT status FROM tblRestockReceipt WHERE id=? FOR UPDATE"
                    )
                ) {
                    q.setInt(1, receiptId);
                    try (ResultSet r = q.executeQuery()) {
                        if (!r.next()) throw new IllegalArgumentException("Không tìm thấy hóa đơn");
                        status = r.getString(1);
                    }
                }
                if (!"UNPAID".equals(status)) throw new IllegalArgumentException(
                    "Hóa đơn đã thanh toán"
                );
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblTransaction(type,date,status,tblRestockReceiptId) VALUES('RESTOCK',NOW(),'PAID',?)"
                    )
                ) {
                    q.setInt(1, receiptId);
                    q.executeUpdate();
                }
                try (
                    PreparedStatement q = c.prepareStatement(
                        "UPDATE tblRestockReceipt SET status='PAID' WHERE id=?"
                    )
                ) {
                    q.setInt(1, receiptId);
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

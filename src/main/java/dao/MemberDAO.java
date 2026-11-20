package dao;

import java.sql.*;
import model.Member;

public class MemberDAO extends DAO {

    public void saveMember(Member m) throws SQLException {
        try (Connection c = connect()) {
            c.setAutoCommit(false);
            try {
                int nameId, userId;
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblName(name,middlename,surname) VALUES(?,?,?)",
                        Statement.RETURN_GENERATED_KEYS
                    )
                ) {
                    q.setString(1, m.first);
                    q.setString(2, m.middle);
                    q.setString(3, m.last);
                    q.executeUpdate();
                    try (ResultSet rs = q.getGeneratedKeys()) {
                        rs.next();
                        nameId = rs.getInt(1);
                    }
                }
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblUser(dob,email,phone,tblNameId,gender) VALUES(?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS
                    )
                ) {
                    q.setString(1, m.dob);
                    q.setString(2, m.email);
                    q.setString(3, m.phone);
                    q.setInt(4, nameId);
                    q.setString(5, m.gender);
                    q.executeUpdate();
                    try (ResultSet rs = q.getGeneratedKeys()) {
                        rs.next();
                        userId = rs.getInt(1);
                    }
                }
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblCustomer(tblUserId) VALUES(?)"
                    )
                ) {
                    q.setInt(1, userId);
                    q.executeUpdate();
                }
                try (
                    PreparedStatement q = c.prepareStatement(
                        "INSERT INTO tblMember(tblUserId,registerDate,memberStatus) VALUES(?,CURRENT_DATE,'ACTIVE')"
                    )
                ) {
                    q.setInt(1, userId);
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

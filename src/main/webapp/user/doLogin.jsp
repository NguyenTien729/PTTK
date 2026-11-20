<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="java.sql.*,dao.DAO,util.Web" %><%
request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("LoginView0.jsp");
    return;
}
try (
    Connection c = new DAO().connect();
    PreparedStatement q = c.prepareStatement(
        "SELECT u.id, m.tblUserId AS managerId, cu.tblUserId AS customerId " +
        "FROM tblUser u LEFT JOIN tblManager m ON m.tblUserId=u.id " +
        "LEFT JOIN tblCustomer cu ON cu.tblUserId=u.id " +
        "WHERE u.username=? AND u.password=SHA2(?,256)"
    )
) {
    q.setString(1, Web.value(request, "username"));
    q.setString(2, request.getParameter("password"));
    try (ResultSet r = q.executeQuery()) {
        if (!r.next() || (r.getObject("managerId") == null && r.getObject("customerId") == null)) {
            Web.error(request, response, "LoginView0.jsp", "Tên đăng nhập hoặc mật khẩu không đúng");
            return;
        }
        int userId = r.getInt("id");
        boolean manager = r.getObject("managerId") != null;
        request.getSession().invalidate();
        javax.servlet.http.HttpSession loginSession = request.getSession(true);
        loginSession.setAttribute("userId", userId);
        loginSession.setAttribute("role", manager ? "MANAGER" : "CUSTOMER");
        loginSession.setAttribute(manager ? "managerId" : "customerId", userId);
        response.sendRedirect(request.getContextPath() + (manager
            ? "/manager/ManagerView0.jsp" : "/customer/CustomerView0.jsp"));
    }
} catch (SQLException e) {
    application.log("User login failed", e);
    Web.error(request, response, "LoginView0.jsp", "Không thể đăng nhập. Hãy kiểm tra kết nối cơ sở dữ liệu.");
}
%>
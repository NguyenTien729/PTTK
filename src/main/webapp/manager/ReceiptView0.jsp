<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="java.util.*,dao.*,util.Web" %><%
List<Map<String, Object>> receipts = new ArrayList<>();
String error = null;
try {
    receipts = new ReceiptDAO().getReceipt();
} catch (Exception e) {
    error = "Không tải được hóa đơn";
}
%>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<main>
    <header class="site-banner"><span>ShopMan</span><% if (session.getAttribute("managerId") != null) { %><a class="logout-link" href="../user/logout.jsp">Đăng xuất</a><% } %></header>
    <h1>Danh sách hóa đơn nhập</h1><a class="btn" href="ManagerView0.jsp">Quay lại</a><%if(error!=null){%><p
        class="error"><%= Web.h(error) %></p>
    <%}%><table>
        <tr>
            <th>Mã</th>
            <th>Ngày nhập</th>
            <th>Nhà cung cấp</th>
            <th>Tổng</th>
            <th>Trạng thái</th>
            <th></th>
        </tr><%for(Map<String,Object> r:receipts){%>
        <tr>
            <td><%= r.get("id") %></td>
            <td><%= Web.h(r.get("restockDate")) %></td>
            <td><%= Web.h(r.get("supplier")) %></td>
            <td><%= r.get("total") %></td>
            <td><%= r.get("status") %></td>
            <td><a class="btn" href="ReceiptDetailView0.jsp?id=<%= r.get("id") %>">Xem</a></td>
        </tr><%}%>
    </table>
</main>

</html>

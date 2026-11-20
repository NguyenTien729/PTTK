<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%
if (session.getAttribute("managerId") == null) {
    response.sendRedirect(request.getContextPath() + "/user/LoginView0.jsp");
    return;
}
%>
<!doctype html>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<main>
    <header class="site-banner"><span>ShopMan</span><% if (session.getAttribute("managerId") != null) { %><a class="logout-link" href="../user/logout.jsp">Đăng xuất</a><% } %></header>
    <h1>Trang chủ quản lý</h1>
    <a class="btn" href="RestockView0.jsp">Nhập hàng</a>
    <a class="btn" href="ReceiptView0.jsp">Danh sách hóa đơn nhập</a>
</main>
</html>

<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="util.Web" %><%
%>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<main>
    <header class="site-banner"><span>ShopMan</span><% if (session.getAttribute("managerId") != null) { %><a class="logout-link" href="../user/logout.jsp">Đăng xuất</a><% } %></header>
    <h1>Thêm mặt hàng</h1><%if(request.getAttribute("error")!=null){%><p class="error">
        <%= Web.h(request.getAttribute("error")) %></p>
    <%}%><form method="post" action="doSaveProduct.jsp"><label>Tên</label><input
            name="name" required maxlength="150"><label>Loại mặt hàng</label><input name="type"
            required maxlength="100"><label>Mô tả</label><input name="description"><label>Giá
            (VND)</label><input name="price" type="number" step="0.01" min="0.01"
            required><button>Thêm</button><a class="btn" href="RestockView0.jsp">Quay lại</a></form>
</main>

</html>

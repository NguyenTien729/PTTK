<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<main>
    <header class="site-banner"><span>ShopMan</span>
<% if (session.getAttribute("customerId") != null) { %>
<a class="logout-link" href="../user/logout.jsp">Đăng xuất</a>
<% } %>
</header>
    <h1>Đăng ký làm thành viên thành công</h1>
    <a class="btn" href="CustomerView0.jsp">Về trang khách hàng</a>
</main>

</html>

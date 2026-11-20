<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="util.Web" %>
<!doctype html>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<style>
    .login-form input { width: 240px; max-width: 100%; }
</style>
<main>
    <header class="site-banner">ShopMan</header>
    <h1>Đăng nhập</h1>
    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= Web.h(request.getAttribute("error")) %></p>
    <% } %>
    <form class="login-form" method="post" action="doLogin.jsp">
        <label>Tên đăng nhập</label><input name="username" required autocomplete="username">
        <label>Mật khẩu</label><input name="password" type="password" required
            autocomplete="current-password">
        <button>Đăng nhập</button>
    </form>
</main>

</html>

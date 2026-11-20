<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="util.Web" %>
<!doctype html><html lang="vi"><meta charset="UTF-8"><link rel="stylesheet" href="../assets/style.css?v=shopman-invoice-1">
<main><header class="site-banner"><span>ShopMan</span><a class="logout-link" href="../user/logout.jsp">Đăng xuất</a></header>
<h1>Thêm nhà cung cấp</h1>
<% if (request.getAttribute("error") != null) { %><p class="error"><%= Web.h(request.getAttribute("error")) %></p><% } %>
<form method="post" action="doSaveSupplier.jsp">
<div class="grid">
<div><label>Tên nhà cung cấp</label><input name="name" maxlength="255" required>
<label>Người liên hệ</label><input name="contactPerson" maxlength="255">
<label>Số điện thoại</label><input name="phone" maxlength="25" required>
<label>Email</label><input name="email" type="email" maxlength="255" required>
<label>Ghi chú</label><input name="note" maxlength="255"></div>
<div><label>Số nhà</label><input name="houseNumber" maxlength="25">
<label>Tòa nhà</label><input name="building" maxlength="255">
<label>Đường</label><input name="street" maxlength="255" required>
<label>Phường</label><input name="ward" maxlength="255" required>
<label>Quận / huyện</label><input name="district" maxlength="255" required>
<label>Tỉnh / thành phố</label><input name="city" maxlength="255" required></div>
</div><button>Thêm nhà cung cấp</button><a class="btn" href="RestockView0.jsp">Quay lại</a>
</form></main></html>

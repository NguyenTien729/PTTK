<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="util.Web" %>
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
    <h1>Đăng ký làm thành viên</h1><% if(request.getAttribute("error")!=null){%><p class="error">
        <%= Web.h(request.getAttribute("error")) %></p>
    <%}%><form method="post" action="doSaveMember.jsp">
        <div class="grid">
            <div><label>Tên</label><input name="first" required maxlength="80"><label>Tên đệm</label><input name="middle" maxlength="100"><label>Họ</label><input
                    name="last" required maxlength="80"><label>Ngày sinh</label><input type="date"
                    name="dob" required><label>Số điện thoại</label><input type="tel" name="phone" required
                    maxlength="15"></div>
            <div><label>Email</label><input type="email" name="email" required
                    maxlength="150"><label>Giới tính</label><select name="gender" required>
<option value="">Chọn giới tính</option>
<option value="Nam">Nam</option><option value="Nữ">Nữ</option><option value="Khác">Khác</option>
</select></div>
        </div><button>Đăng ký làm thành viên</button><a class="btn" href="CustomerView0.jsp">Quay lại</a>
    </form>
</main>

</html>

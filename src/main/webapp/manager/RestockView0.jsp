<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="java.util.*,java.math.*,model.*,dao.*,util.Web" %><%
request.setCharacterEncoding("UTF-8");
List<RestockItem> cart = (List<RestockItem>) session.getAttribute("restockCart");
if (cart == null) {
    cart = new ArrayList<>();
    session.setAttribute("restockCart", cart);
}
List<Supplier> suppliers = new ArrayList<>();
List<Product> products = new ArrayList<>();
String loadError = null;
try {
    suppliers = new SupplierDAO().getSupplier("");
    products = new ProductDAO().getProduct("");
} catch (Exception e) {
    application.log("Restock data load failed", e);
    loadError = "Không thể tải dữ liệu từ CSDL";
}
%>
<!doctype html>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-banner-2">
<main>
    <header class="site-banner"><span>ShopMan</span><% if (session.getAttribute("managerId") != null) { %><a class="logout-link"
            href="../user/logout.jsp">Đăng xuất</a><% } %></header>
    <h1>Nhập hàng</h1><%if(request.getAttribute("error")!=null||loadError!=null){%><p class="error">
        <%= Web.h(
    request.getAttribute("error") != null ? request.getAttribute("error") : loadError
) %></p>
    <%}%><section class="panel">
    <h2>1. Thông tin nhà cung cấp</h2>
    <label for="supplierFilter">Tìm kiếm nhà cung cấp</label><input id="supplierFilter" type="search" placeholder="Nhập tên nhà cung cấp..." oninput="filterSelect('supplierFilter','supplierSelect')">
    <form method="post" action="doSelectSupplier.jsp"><label>Chọn nhà cung cấp</label><select
            id="supplierSelect" name="supplierId" required>
            <option value="">-- Chọn --</option><%for(Supplier s:suppliers){%><option
                value="<%= s.id %>" <%= String.valueOf(s.id).equals(String.valueOf(session.getAttribute("supplierId")))
    ? "selected"
    : "" %>>
                <%= Web.h(s.name) %> — <%= Web.h(s.phone) %></option>
            <%}%>
        </select>
        <div class="button-row"><button>Chọn nhà cung cấp</button><a class="btn push-right"
                href="AddSupplierView.jsp">Thêm nhà cung cấp</a></div>
    </form>
    </section>
    <h2>2. Thêm mặt hàng</h2>
    <label for="productFilter">Tìm kiếm mặt hàng</label><input id="productFilter" type="search" placeholder="Nhập tên mặt hàng..." oninput="filterSelect('productFilter','productSelect')">
    <form method="post" action="doAddItem.jsp"><label>Chọn mặt hàng</label><select id="productSelect" name="productId"
            required>
            <option value="">-- Chọn --</option><%for(Product p:products){%><option
                value="<%= p.id %>"><%= Web.h(p.name) %> (tồn: <%= p.instock %>)</option>
            <%}%>
        </select>
        <div class="grid">
            <div><label>Số lượng nhập</label><input name="quantity" type="number" min="1" required>
            </div>
            <div><label>Đơn giá (VND)</label><input name="unitPrice" type="number" min="0.01"
                    step="0.01" required></div>
        </div>
        <div class="button-row"><button>Thêm vào danh sách</button><a class="btn push-right"
                href="AddProductView.jsp">Thêm mặt hàng</a></div>
    </form>
    <section class="panel">
    <section class="panel">
    <h2>3. Hóa đơn nhập</h2>
    <p>Nhà cung cấp đã chọn: <b><%= session.getAttribute("supplierName") == null
    ? "Chưa chọn"
    : Web.h(session.getAttribute("supplierName")) %></b>
    </p>
    <table>
        <tr>
            <th>STT</th>
            <th>Mặt hàng</th>
            <th>Số lượng</th>
            <th>Đơn giá</th>
            <th>Thành tiền</th>
            <th>Thao tác</th>
        </tr>
        <%BigDecimal total=BigDecimal.ZERO;for(int i=0;i<cart.size();i++){RestockItem x=cart.get(i);total=total.add(x.total());%>
        <tr>
            <td><%= i + 1 %></td>
            <td><%= Web.h(x.name) %></td>
            <td><%= x.quantity %></td>
            <td><%= x.unitPrice %></td>
            <td><%= x.total() %></td>
            <td>
                <form method="post" action="doRemoveItem.jsp"><input type="hidden" name="index"
                        value="<%= i %>"><button>Xóa</button></form>
            </td>
        </tr><%}%><tr>
            <th colspan="4">Tổng tiền</th>
            <th colspan="2"><%= total %> VND</th>
        </tr>
    </table>
    <div class="button-row">
        <form method="post" action="doSaveReceipt.jsp"><button>Xác nhận đơn hàng</button></form><a
            class="btn" href="ManagerView0.jsp">Quay lại</a>
    </div>
</section>
    </main>

<script>function filterSelect(i,s){const q=document.getElementById(i).value.trim().toLocaleLowerCase("vi"),e=document.getElementById(s);for(const o of e.options)o.hidden=o.value!==""&&!o.text.toLocaleLowerCase("vi").includes(q);if(e.selectedOptions.length&&e.selectedOptions[0].hidden)e.value="";}</script></html>

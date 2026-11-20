<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="java.util.*,dao.*,util.Web" %><%
Map<String, Object> r = null;
try { r = new ReceiptDAO().getReceiptDetail(Web.positive(Web.value(request, "id"))); }
catch (Exception e) { application.log("Unable to load receipt", e); }
if (r == null) { response.sendError(404, "Không tìm thấy hóa đơn"); return; }
List<Map<String, Object>> items = (List<Map<String, Object>>) r.get("items");
%>
<!doctype html>
<html lang="vi">
<meta charset="UTF-8">
<link rel="stylesheet" href="../assets/style.css?v=shopman-invoice-1">
<main class="invoice-page">
    <div class="invoice-actions no-print">
        <a class="btn secondary" href="ReceiptView0.jsp">← Danh sách hóa đơn</a>
        <button class="btn" onclick="window.print()">▣ In hóa đơn</button>
    </div>
    <article class="invoice-paper" id="invoicePaper">
        <div class="paper-head">
            <div><b>ĐƠN VỊ: CỬA HÀNG</b><div>Địa chỉ: ....................................</div></div>
            <div class="paper-code">Mẫu phiếu nhập<br>Số: <b>PN<%= r.get("id") %></b></div>
        </div>
        <h2>HÓA ĐƠN NHẬP HÀNG</h2>
        <div class="paper-date">Ngày <%= Web.h(r.get("restockDate")) %></div>
        <div class="paper-meta">
            <div><b>Nhà cung cấp:</b> <%= Web.h(r.get("supplier")) %></div>
            <div><b>Địa chỉ:</b> <%= Web.h(r.get("supplierAddress")) %></div>
            <div><b>Điện thoại:</b> <%= Web.h(r.get("supplierPhone")) %></div>
        </div>
        <table>
            <thead><tr><th>STT</th><th>TÊN HÀNG HÓA</th><th>ĐVT</th><th>SỐ LƯỢNG</th><th>ĐƠN GIÁ</th><th>THÀNH TIỀN</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < Math.max(10, items.size()); i++) { if (i < items.size()) { Map<String,Object> item = items.get(i); %>
                <tr><td class="center"><%= i + 1 %></td><td><%= Web.h(item.get("name")) %></td><td class="center">—</td><td class="right"><%= item.get("amount") %></td><td class="right"><%= item.get("unitPrice") %></td><td class="right"><%= item.get("lineTotal") %></td></tr>
            <% } else { %><tr><td class="center"><%= i + 1 %></td><td>&nbsp;</td><td></td><td></td><td></td><td></td></tr><% } } %>
                <tr><td colspan="5" class="center"><b>Cộng</b></td><td class="right"><b><%= r.get("total") %></b></td></tr>
            </tbody>
        </table>
        <div class="paper-total">Tổng tiền: <%= r.get("total") %> ₫</div>
        <div class="paper-words">Trạng thái: <%= "PAID".equals(r.get("status")) ? "Đã thanh toán" : "Chưa thanh toán" %></div>
        <div class="signatures"><div>NGƯỜI NHẬP HÀNG<div class="signature-hint">(Ký, ghi rõ họ tên)</div><div class="signature-space"></div></div><div>NGƯỜI GIAO HÀNG<div class="signature-hint">(Ký, ghi rõ họ tên)</div><div class="signature-space"></div></div></div>
    </article>
    <% if ("UNPAID".equals(r.get("status"))) { %>
    <form class="no-print payment-action" method="post" action="doSaveTransaction.jsp"><input type="hidden" name="id" value="<%= r.get("id") %>"><button class="btn success">Xác nhận thanh toán</button></form>
    <% } %>
</main>
</html>

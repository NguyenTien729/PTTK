<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="dao.*,util.Web" %><%
request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("AddProductView.jsp");
    return;
}
try {
    String n = Web.value(request, "name"),
        t = Web.value(request, "type"),
        d = Web.value(request, "description");
    if (n.isEmpty() || t.isEmpty()) throw new Exception("Thiếu tên hoặc loại mặt hàng");
    new ProductDAO().saveProduct(n, t, d, Web.money(Web.value(request, "price")));
    response.sendRedirect("RestockView0.jsp");
} catch (Exception e) {
    Web.error(request, response, "AddProductView.jsp", e.getMessage());
}
%>

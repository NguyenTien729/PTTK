<%@ include file="auth.jsp" %>
<%@ page import="java.util.*,model.*,dao.*,util.Web" %><%
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("RestockView0.jsp");
    return;
}
try {
    Integer supplier = (Integer) session.getAttribute("supplierId");
    if (supplier == null) throw new Exception("Hãy chọn nhà cung cấp");
    List<RestockItem> cart = (List<RestockItem>) session.getAttribute("restockCart");
    int id = new ReceiptDAO().saveReceipt(
        (Integer) session.getAttribute("managerId"),
        supplier,
        cart
    );
    session.removeAttribute("restockCart");
    session.removeAttribute("supplierId");
    session.removeAttribute("supplierName");
    response.sendRedirect("ReceiptView0.jsp");
} catch (Exception e) {
    Web.error(
        request,
        response,
        "RestockView0.jsp",
        "Không thể lưu hóa đơn: " + e.getMessage()
    );
}
%>

<%@ include file="auth.jsp" %>
<%@ page import="dao.*,util.Web" %><%
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("ReceiptView0.jsp");
    return;
}
try {
    int id = Web.positive(Web.value(request, "id"));
    new TransactionDAO().saveTransaction(id);
    response.sendRedirect("ReceiptDetailView0.jsp?id=" + id);
} catch (Exception e) {
    response.sendError(400, "Không thể thanh toán: " + e.getMessage());
}
%>

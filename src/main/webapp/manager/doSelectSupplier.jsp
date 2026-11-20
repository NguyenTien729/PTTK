<%@ include file="auth.jsp" %>
<%@ page import="dao.*,model.*,util.Web" %><%
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("RestockView0.jsp");
    return;
}
try {
    int id = Web.positive(Web.value(request, "supplierId"));
    Supplier found = null;
    for (Supplier s : new SupplierDAO().getSupplier("")) if (s.id == id) found = s;
    if (found == null) throw new Exception("Nhà cung cấp không tồn tại");
    session.setAttribute("supplierId", id);
    session.setAttribute("supplierName", found.name);
    response.sendRedirect("RestockView0.jsp");
} catch (Exception e) {
    Web.error(request, response, "RestockView0.jsp", "Không thể chọn nhà cung cấp");
}
%>

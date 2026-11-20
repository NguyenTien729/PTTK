<%@ include file="auth.jsp" %>
<%@ page import="java.util.*,model.*,util.Web" %><%
if ("POST".equals(request.getMethod())) {
    try {
        int i = Integer.parseInt(Web.value(request, "index"));
        List<RestockItem> cart = (List<RestockItem>) session.getAttribute("restockCart");
        if (cart != null && i >= 0 && i < cart.size()) cart.remove(i);
    } catch (Exception ignored) {}
}
response.sendRedirect("RestockView0.jsp");
%>

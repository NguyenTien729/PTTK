<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%
if (session.getAttribute("customerId") == null) {
    response.sendRedirect(request.getContextPath() + "/user/LoginView0.jsp");
    return;
}
%>
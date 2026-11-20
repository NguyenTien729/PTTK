<%@ include file="auth.jsp" %><%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="dao.SupplierDAO,util.Web" %><%
request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) { response.sendRedirect("AddSupplierView.jsp"); return; }
try {
    String name=Web.value(request,"name"), phone=Web.value(request,"phone"), email=Web.value(request,"email");
    String street=Web.value(request,"street"), ward=Web.value(request,"ward"), district=Web.value(request,"district"), city=Web.value(request,"city");
    if(name.isEmpty()||street.isEmpty()||ward.isEmpty()||district.isEmpty()||city.isEmpty()||!phone.matches("[0-9+]{9,25}")||!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) throw new IllegalArgumentException("Thông tin nhà cung cấp không hợp lệ");
    new SupplierDAO().saveSupplier(name,phone,email,Web.value(request,"note"),Web.value(request,"houseNumber"),Web.value(request,"building"),street,ward,district,city,Web.value(request,"contactPerson"));
    response.sendRedirect("RestockView0.jsp");
} catch(Exception e) { application.log("Unable to save supplier",e); Web.error(request,response,"AddSupplierView.jsp",e.getMessage()); }
%>

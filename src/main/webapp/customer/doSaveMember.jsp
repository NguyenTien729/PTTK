<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ page import="model.Member,dao.MemberDAO,util.Web,java.time.LocalDate,java.sql.SQLException" %><%
request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("RegisterAsAMemberView0.jsp");
    return;
}
try {
    Member m = new Member();
    m.first = Web.value(request, "first");
    m.middle = Web.value(request, "middle");
    m.last = Web.value(request, "last");
    m.dob = Web.value(request, "dob");
    m.phone = Web.value(request, "phone");
    m.email = Web.value(request, "email");
    m.gender = Web.value(request, "gender");
    if (
        m.first.isEmpty() ||
        m.last.isEmpty() ||
        m.phone.isEmpty() ||
        m.email.isEmpty() ||
        m.first.length() > 80 || m.middle.length() > 100 || m.last.length() > 80 || m.email.length() > 150 || !java.util.Arrays.asList("Nam", "Nữ", "Khác").contains(m.gender) ||
        !m.email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$") ||
        !m.phone.matches("[0-9+]{9,15}") ||
        LocalDate.parse(m.dob).isAfter(LocalDate.now())
    ) throw new IllegalArgumentException(
        "Thông tin thành viên không hợp lệ. Vui lòng kiểm tra lại."
    );
    new MemberDAO().saveMember(m);
    response.sendRedirect("RegisterSuccess.jsp");
} catch (Exception e) {
    Web.error(
        request,
        response,
        "RegisterAsAMemberView0.jsp",
        e instanceof SQLException
            ? "Email đã được sử dụng hoặc có lỗi cơ sở dữ liệu"
            : e.getMessage()
    );
}
%>

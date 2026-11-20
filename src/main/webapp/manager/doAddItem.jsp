<%@ include file="auth.jsp" %>
<%@ page import="java.util.*,model.*,dao.*,util.Web" %><%
if (!"POST".equals(request.getMethod())) {
    response.sendRedirect("RestockView0.jsp");
    return;
}
try {
    int id = Web.positive(Web.value(request, "productId"));
    int qty = Web.positive(Web.value(request, "quantity"));
    java.math.BigDecimal price = Web.money(Web.value(request, "unitPrice"));
    Product found = null;
    for (Product p : new ProductDAO().getProduct("")) if (p.id == id) found = p;
    if (found == null) throw new Exception("Mặt hàng không tồn tại");
    List<RestockItem> cart = (List<RestockItem>) session.getAttribute("restockCart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("restockCart", cart);
    }
    for (RestockItem i : cart)
        if (i.productId == id) {
            if (i.unitPrice.compareTo(price) != 0) throw new Exception(
                "Mặt hàng đã có với đơn giá khác; hãy xóa trước khi thêm lại"
            );
            i.quantity = Math.addExact(i.quantity, qty);
            response.sendRedirect("RestockView0.jsp");
            return;
        }
    cart.add(new RestockItem(id, found.name, qty, price));
    response.sendRedirect("RestockView0.jsp");
} catch (Exception e) {
    Web.error(
        request,
        response,
        "RestockView0.jsp",
        "Không thể thêm mặt hàng: " + e.getMessage()
    );
}
%>

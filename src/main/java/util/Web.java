package util;

import javax.servlet.http.*;

public class Web {

    public static String h(Object value) {
        String s = value == null ? "" : value.toString();
        return s
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    public static String value(HttpServletRequest r, String key) {
        String s = r.getParameter(key);
        return s == null ? "" : s.trim();
    }

    public static int positive(String s) {
        try {
            int n = Integer.parseInt(s);
            if (n > 0) return n;
        } catch (Exception ignored) {}
        throw new IllegalArgumentException("Số lượng hoặc mã không hợp lệ");
    }

    public static java.math.BigDecimal money(String s) {
        try {
            java.math.BigDecimal v = new java.math.BigDecimal(s);
            if (v.signum() > 0 && v.scale() <= 2) return v;
        } catch (Exception ignored) {}
        throw new IllegalArgumentException(
            "Đơn giá phải lớn hơn 0 và có tối đa 2 chữ số thập phân"
        );
    }

    public static void error(
        HttpServletRequest r,
        HttpServletResponse resp,
        String target,
        String msg
    ) throws java.io.IOException, javax.servlet.ServletException {
        r.setAttribute("error", msg);
        r.getRequestDispatcher(target).forward(r, resp);
    }
}

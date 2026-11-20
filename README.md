# ShopMan – Đề 32, B23DCCN820

Hai module: **đăng ký thành viên** và **nhập hàng từ nhà cung cấp**. Java 11, JSP, JDBC, MySQL 8, Tomcat 9, Maven WAR. Không dùng Spring.

## Format Java và JSP

- Cài dependencies bằng `npm.cmd ci` và extension VS Code **Prettier - Code formatter** (`esbenp.prettier-vscode`).
- Lưu file hoặc nhấn `Shift+Alt+F` để format Java/JSP theo cấu hình workspace.
- Chạy `npm.cmd run format` để format toàn bộ; `npm.cmd run format:check` để kiểm tra định dạng.
- Java dùng `prettier-plugin-java`. JSP dùng plugin cục bộ `tools/prettier-plugin-jsp.cjs`: căn HTML bằng `js-beautify` và format Java trong các khối `<% ... %>` hoàn chỉnh bằng Prettier Java. Các đoạn Java mở/đóng xuyên nhiều thẻ JSP được giữ nguyên.
- Chạy `node tools/check-formatters.cjs` để kiểm tra formatter trên toàn bộ file và xác nhận các khối JSP được giữ nguyên.

## Chạy

1. Tạo MySQL 8 và chạy `database/shopman32.sql` **một lần trên CSDL mới**.
2. Đặt biến môi trường `SHOPMAN_DB_URL`, `SHOPMAN_DB_USER`, `SHOPMAN_DB_PASSWORD` theo máy; mặc định URL `jdbc:mysql://localhost:3306/shopman32?...`, user `root`, password rỗng.
3. `mvn clean package`; deploy `target/ShopMan32.war` lên **Tomcat 9** (không dùng Tomcat 10 vì namespace servlet khác).
4. Mở `http://localhost:8080/ShopMan32/`.
5. Tài khoản quản lý mẫu: `manager` / `Admin@123` (chỉ dùng demo, đổi trước khi triển khai).

## Luồng

- `CustomerView0.jsp` → `RegisterAsAMemberView0.jsp` → `doSaveMember.jsp` → `MemberDAO.saveMember` → lưu tblName, tblUser (chỉ thông tin cá nhân, không tạo thông tin đăng nhập), tblCustomer, tblMember trong 1 transaction → thông báo thành công.
- `user/LoginView0.jsp` → `user/doLogin.jsp` → `manager/ManagerView0.jsp` → `RestockView0.jsp`: tìm/chọn hoặc thêm nhà cung cấp, tìm/chọn hoặc thêm sản phẩm, thêm/xóa dòng hàng → `doSaveReceipt.jsp` → `ReceiptDAO.saveReceipt` (lưu hóa đơn, chi tiết, cập nhật tồn kho trong 1 transaction) → `ReceiptDetailView0.jsp` → `doSaveTransaction.jsp` (thanh toán 1 lần) → in bằng trình duyệt.

## Ghi chú phạm vi

- Thiết kế lớp/bảng dựa trên tài liệu 32B23DCCN820; `fullAddress` lưu địa chỉ nhập trong một ô thay vì phân tách số nhà/phường/quận. `unitPrice` bổ sung trong chi tiết nhập để lưu đúng đơn giá thực tế theo nghiệp vụ, tránh thay đổi khi giá sản phẩm thay đổi.
- Không xây dựng các chức năng khác như thống kê, bán hàng, giỏ hàng. Chức năng in dùng hộp thoại in của trình duyệt.
- Bảo mật cơ bản: PreparedStatement, transaction, escape HTML, kiểm tra quyền quản lý, SHA-256 cho tài khoản mẫu để giữ ví dụ đơn giản; khi triển khai thực tế cần thay SHA-256 bằng Argon2/bcrypt, CSRF token và cấu hình HTTPS.

CSDL đã tạo trước thay đổi đăng ký thành viên cần chạy database/migrate_member_registration.sql một lần. CSDL mới dùng database/shopman32.sql.

Đăng nhập/đăng xuất dùng chung tại src/main/webapp/user. Đăng nhập tự xác định vai trò từ tblManager/tblCustomer và chuyển về giao diện tương ứng; đăng xuất xóa session và về trang đăng nhập chung. Đăng ký thành viên không tạo tên đăng nhập/mật khẩu.

## Deploy và tự động deploy (PowerShell)

Chạy từ thư mục dự án:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/deploy.ps1
```

Build WAR và chép vào Tomcat trong `.runtime`, khởi động Tomcat nếu cổng 8080 chưa mở.
Mở http://localhost:8080/ShopMan32/ sau khi Tomcat triển khai xong.

Tự deploy mỗi khi lưu thay đổi trong `src/main` hoặc `pom.xml`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/deploy.ps1 -Watch
```

Giữ terminal mở; Ctrl+C để dừng theo dõi. Build lỗi sẽ giữ bản deploy trước đó.
Script dùng Maven trên PATH hoặc Maven của IntelliJ, JDK trong Program Files/Java,
và dependencies đã cache trong `.runtime/m2` (chế độ offline).
Nếu thiếu dependencies, chạy Maven không có `-o` để tải trước.
Thay đổi SQL cần chạy riêng trên MySQL; script không tự sửa dữ liệu.
powershell -ExecutionPolicy Bypass -File tools/deploy.ps1

Tài khoản khách hàng mẫu: customer / Customer@123. CSDL hiện có chạy database/seed_customer.sql; tài khoản mẫu chưa đăng ký thành viên.


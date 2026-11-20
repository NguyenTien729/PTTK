CREATE DATABASE IF NOT EXISTS shopman32 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopman32;
CREATE TABLE tblName(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(80) NOT NULL,middlename VARCHAR(100),surname VARCHAR(80) NOT NULL);
CREATE TABLE tblAddress(id INT AUTO_INCREMENT PRIMARY KEY,fullAddress VARCHAR(255) NOT NULL);
CREATE TABLE tblUser(id INT AUTO_INCREMENT PRIMARY KEY,username VARCHAR(80) NULL UNIQUE,password CHAR(64) NULL,dob DATE NOT NULL,email VARCHAR(150) NOT NULL UNIQUE,phone VARCHAR(20) NOT NULL,tblNameId INT NOT NULL,tblAddressId INT NULL,gender VARCHAR(10),FOREIGN KEY(tblNameId) REFERENCES tblName(id),FOREIGN KEY(tblAddressId) REFERENCES tblAddress(id));
CREATE TABLE tblCustomer(tblUserId INT PRIMARY KEY,FOREIGN KEY(tblUserId) REFERENCES tblUser(id));
CREATE TABLE tblMember(tblUserId INT PRIMARY KEY,registerDate DATE NOT NULL,memberStatus VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',FOREIGN KEY(tblUserId) REFERENCES tblCustomer(tblUserId));
CREATE TABLE tblStaff(tblUserId INT PRIMARY KEY,position VARCHAR(100),FOREIGN KEY(tblUserId) REFERENCES tblUser(id));
CREATE TABLE tblManager(tblUserId INT PRIMARY KEY,FOREIGN KEY(tblUserId) REFERENCES tblStaff(tblUserId));
CREATE TABLE tblSupplier(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(150) NOT NULL,fullAddress VARCHAR(255) NOT NULL,phone VARCHAR(20) NOT NULL,email VARCHAR(150) NOT NULL);
CREATE TABLE tblProductType(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE tblProduct(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(150) NOT NULL,instock INT NOT NULL DEFAULT 0,price DECIMAL(15,2) NOT NULL,description TEXT,tblProductTypeId INT NOT NULL,FOREIGN KEY(tblProductTypeId) REFERENCES tblProductType(id),CHECK(instock>=0));
CREATE TABLE tblRestockReceipt(id INT AUTO_INCREMENT PRIMARY KEY,restockDate DATETIME NOT NULL,total DECIMAL(18,2) NOT NULL,status VARCHAR(20) NOT NULL,tblManagerId INT NOT NULL,tblSupplierId INT NOT NULL,FOREIGN KEY(tblManagerId) REFERENCES tblManager(tblUserId),FOREIGN KEY(tblSupplierId) REFERENCES tblSupplier(id));
CREATE TABLE tblRestockReceiptDetail(id INT AUTO_INCREMENT PRIMARY KEY,amount INT NOT NULL,unitPrice DECIMAL(15,2) NOT NULL,tblRestockReceiptId INT NOT NULL,tblProductId INT NOT NULL,FOREIGN KEY(tblRestockReceiptId) REFERENCES tblRestockReceipt(id),FOREIGN KEY(tblProductId) REFERENCES tblProduct(id),CHECK(amount>0),CHECK(unitPrice>0));
CREATE TABLE tblTransaction(id INT AUTO_INCREMENT PRIMARY KEY,type VARCHAR(30) NOT NULL,date DATETIME NOT NULL,status VARCHAR(20) NOT NULL,tblRestockReceiptId INT UNIQUE,FOREIGN KEY(tblRestockReceiptId) REFERENCES tblRestockReceipt(id));
-- Tạo tài khoản quản lý để thử nghiệm (mật khẩu: Admin@123; thay đổi khi triển khai).
INSERT INTO tblName(name,middlename,surname) VALUES('Quản','','Lý');
INSERT INTO tblAddress(fullAddress) VALUES('Hà Nội');
INSERT INTO tblUser(username,password,dob,email,phone,tblNameId,tblAddressId) VALUES('manager',SHA2('Admin@123',256),'1990-01-01','manager@shopman.local','0900000000',1,1);
INSERT INTO tblStaff(tblUserId,position) VALUES(1,'Manager');
INSERT INTO tblManager(tblUserId) VALUES(1);

-- Tài khoản khách hàng mẫu: customer / Customer@123.
USE shopman32;
START TRANSACTION;
INSERT INTO tblName(name,middlename,surname)
SELECT 'Hang','','Khach'
WHERE NOT EXISTS (SELECT 1 FROM tblUser WHERE username='customer');
SET @customer_name_id = LAST_INSERT_ID();
INSERT INTO tblAddress(fullAddress)
SELECT 'Ha Noi'
WHERE NOT EXISTS (SELECT 1 FROM tblUser WHERE username='customer');
SET @customer_address_id = LAST_INSERT_ID();
INSERT INTO tblUser(username,password,dob,email,phone,tblNameId,tblAddressId)
SELECT 'customer',SHA2('Customer@123',256),'2000-01-01',
       'customer@shopman.local','0900000001',@customer_name_id,@customer_address_id
WHERE NOT EXISTS (SELECT 1 FROM tblUser WHERE username='customer');
INSERT INTO tblCustomer(tblUserId)
SELECT id FROM tblUser u WHERE username='customer'
AND NOT EXISTS (SELECT 1 FROM tblCustomer c WHERE c.tblUserId=u.id);
COMMIT;


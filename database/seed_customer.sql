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

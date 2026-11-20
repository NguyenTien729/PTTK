-- Chạy một lần trên CSDL hiện có trước khi dùng luồng đăng ký thành viên mới.
USE shopman32;
ALTER TABLE tblUser
    MODIFY username VARCHAR(80) NULL,
    MODIFY password CHAR(64) NULL,
    MODIFY tblAddressId INT NULL,
    ADD COLUMN gender VARCHAR(10) NULL;
ALTER TABLE tblMember
    ADD COLUMN memberStatus VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';
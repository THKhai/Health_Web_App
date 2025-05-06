-- Tạo người dùng và cơ sở dữ liệu
CREATE USER "khai_TR" WITH ENCRYPTED PASSWORD '09122002';
-- Cấp quyền cho người dùng
GRANT CONNECT ON DATABASE "HealthData" TO "khai_TR";
GRANT USAGE ON SCHEMA public TO "khai_TR";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "khai_TR";
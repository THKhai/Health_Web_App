-- Tạo người dùng và cơ sở dữ liệu
CREATE USER "khai_TR" WITH ENCRYPTED PASSWORD '09122002';
-- Cấp quyền cho người dùng
GRANT CONNECT ON DATABASE "HealthData" TO "khai_TR";
GRANT USAGE ON SCHEMA public TO "khai_TR";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "khai_TR";


CREATE TABLE AspNetRoles (
    Id uuid PRIMARY KEY,
    Name VARCHAR(256) NOT NULL,
    NormalizedName VARCHAR(256) NOT NULL,
    ConcurrencyStamp VARCHAR(256),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO AspNetRoles (id,Name, NormalizedName, ConcurrencyStamp)
VALUES ('dc2626f4-b6cf-40f8-93f1-e8c19d3b37ed', 'Reader','READER','dc2626f4-b6cf-40f8-93f1-e8c19d3b37ed'),
       ('30f1b620-14da-4e52-af95-4d7490d52edf','Writer','WRITER','30f1b620-14da-4e52-af95-4d7490d52edf');
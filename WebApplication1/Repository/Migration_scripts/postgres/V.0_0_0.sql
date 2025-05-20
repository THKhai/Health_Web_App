-- Tạo người dùng và cơ sở dữ liệu
CREATE USER "khai_TR" WITH ENCRYPTED PASSWORD '09122002';
-- Cấp quyền cho người dùng
GRANT CONNECT ON DATABASE "HealthData" TO "khai_TR";
GRANT USAGE ON SCHEMA public TO "khai_TR";

----------------------------------------CREATE TABLES----------------------------------------
-- tạo bảng AspNetUsers
CREATE TABLE "AspNetRoles" (
    "Id" text PRIMARY KEY,
    "Name" VARCHAR(256) NOT NULL,
    "NormalizedName" VARCHAR(256) NOT NULL,
    "ConcurrencyStamp" VARCHAR(256),
    "CreatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "AspNetUsers" (
    "Id" text PRIMARY KEY ,
    "UserName" VARCHAR(256) NOT NULL,
    "Email" VARCHAR(256) NOT NULL,
    "NormalizedUserName" VARCHAR(256) NOT NULL,
    "NormalizedEmail" VARCHAR(256) NOT NULL,
    "EmailConfirmed" BOOLEAN DEFAULT FALSE,
    "PhoneNumber" VARCHAR(256),
    "PhoneNumberConfirmed" BOOLEAN DEFAULT FALSE,
    "TwoFactorEnabled" BOOLEAN DEFAULT FALSE,
    "LockoutEnd" TIMESTAMP,
    "LockoutEnabled" BOOLEAN DEFAULT FALSE,
    "AccessFailedCount" INT DEFAULT 0,
    "SecurityStamp" VARCHAR(256),
    "PasswordHash" VARCHAR(256),
    "ConcurrencyStamp" VARCHAR(256),
    "CreatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE "AspNetUserRoles" (
    "UserId" text NOT NULL,
    "RoleId" text NOT NULL,
    PRIMARY KEY ("UserId", "RoleId"),
    FOREIGN KEY ("UserId") REFERENCES "AspNetUsers" ("Id") ON DELETE CASCADE,
    FOREIGN KEY ("RoleId") REFERENCES "AspNetRoles" ("Id") ON DELETE CASCADE
);
-----------------------------------------INSERT DATA-----------------------------------------
INSERT INTO "AspNetRoles" ("Id", "Name", "NormalizedName", "ConcurrencyStamp")
VALUES ('dc2626f4-b6cf-40f8-93f1-e8c19d3b37ed', 'User','USER','dc2626f4-b6cf-40f8-93f1-e8c19d3b37ed'),
       ('30f1b620-14da-4e52-af95-4d7490d52edf','Admin','ADMIN','30f1b620-14da-4e52-af95-4d7490d52edf');
----------------------------------------- Grant Permissions -----------------------------------------\
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "khai_TR";

create database QLKHO
GO
USE QLKHO

CREATE TABLE NHAP(
SoHDN INT PRIMARY KEY,
MaVT char(10) not null,
SoLuongN int not null,
DonGiaN money not null,
NgayN date not null
)
go

create table XUAT(
SoHDX int primary key,
MaVT char(10) not null,
SoLuongX int not null,
DonGiaX money not null,
NgayX date not null
)
go

create table TON(
MaVT char(10) primary key,
TenVT nvarchar(50) not null,
SoLuongT int not null
)
go

ALTER TABLE XUAT ADD CONSTRAINT fk_MaVT FOREIGN KEY(MaVT) REFERENCES TON(MaVT)
ALTER TABLE NHAP ADD CONSTRAINT fk1_MaVT FOREIGN KEY(MaVT) REFERENCES TON(MaVT)

INSERT INTO TON(MaVT, TenVT, SoLuongT) VALUES ('VT01','Gạch', 2.000),
                                              ('VT02','Tôn', 1.000),
											  ('VT03','XiMang', 1.500),
											  ('VT04','Thép', 3.000),
											  ('VT05','Săt',2.500)
INSERT INTO NHAP(SoHDN,MaVT,SoLuongN,DonGiaN,NgayN) values (3,'VT03',3000,12.000,'10-01-2023'),
                                                           (4,'VT04',4000, 5.000,'11-01-2023'),
													       (5,'VT01',5000, 20.000,'04-01-2023')
INSERT INTO XUAT(SoHDX, MaVT,DonGiaX,SoLuongX,NgayX) values (2, 'VT03',2.500 ,1000,'12-02-2023'),
                                                            (3,'VT01',3.000,1200, '09-02-2023')

----Câu 2--
CREATE VIEW CAU2
AS
select ton.MaVT,TenVT,sum(SoLuongX*DonGiaX) as tienban
from Xuat inner join ton on Xuat.MaVT=ton.MaVT
group by ton.mavt,tenvt
go
SELECT * FROM CAU2
-- câu 3 
go
CREATE VIEW CAU3
AS
select ton.tenvt, sum(soluongx) as SoLuongT
from xuat inner join ton on xuat.mavt=ton.mavt
group by ton.tenvt
go
SELECT * FROM CAU3
go 
-- câu 4
CREATE VIEW CAU4
AS
SELECT ton.TenVT, SUM(SoLuongN) AS SoLuongNhap
FROM Nhap inner join ton on Nhap.MaVT=ton.MaVT
group by ton.TenVT
go
SELECT * FROM CAU4
go
-- câu 5
CREATE VIEW CAU5
AS
select ton.mavt,ton.tenvt,sum(soluongN)-sum(soluongX) +
sum(soluongT) as tongton
from nhap inner join ton on nhap.mavt=ton.mavt
 inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
go 
SELECT * FROM CAU5
go
-- câu 6
CREATE VIEW CAU6
AS
select tenvt
from ton
where soluongT = (select max(soluongT) from Ton)
go
SELECT * FROM CAU6
go
-- câu 7
CREATE VIEW CAU7
AS
select ton.mavt,ton.tenvt
from ton inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
having sum(soluongX)>=100
go
SELECT * FROM CAU7
go
--câu 8 

CREATE VIEW CAU8 AS
SELECT MONTH(NgayX) AS "Tháng xuất", YEAR(NgayX) AS "Năm xuất", SUM(SoLuongX) AS Total_Quantity
FROM Xuat
GROUP BY MONTH(NgayX), YEAR(NgayX);
go
SELECT * FROM CAU8

--câu 9: tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số
--lượng xuất. đơn giá N. đơn giá X. ngày nhập. Ngày xuất
go
CREATE VIEW CAU9 AS
SELECT t.MaVT, t.TenVT,n.SoLuongN,x.SoLuongX, n.DonGiaN,x.DonGiaX, n.NgayN, x.NgayX
FROM Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT;
go
SELECT * FROM CAU9
go 
--câu 10: Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho. biết còn lại = SoluongN-
-- SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015

CREATE VIEW CAU10 
AS
SELECT t.MaVT, t.TenVT, SUM(n.SoLuongN-x.SoLuongX+t.SoLuongT) as "SL còn lại"
FROM Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT
where YEAR(n.NgayN) = 2023 OR YEAR(x.NgayX) = 2023
GROUP BY t.MaVT,t.TenVT;
go
SELECT * FROM CAU10
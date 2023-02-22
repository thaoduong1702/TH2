Use AdventureWorks2008R2
go
----Câu 1---
select A.SalesOrderID, A.OrderDate, Sum(B.OrderQty * B.UnitPrice) as 'SubTotal'
From Sales.SalesOrderHeader as A join Sales.SalesOrderDetail as B
   on A.SalesOrderID = B.SalesOrderID
where month(A.OrderDate)=6 and year(A.OrderDate) = 2008
Group by A.SalesOrderID, A.OrderDate
having sum(B.OrderQty * B.UnitPrice) > 70000


---Câu 2---
select sst.TerritoryID, count(sc.CustomerID) as 'CountOfCust', sum(ssod.OrderQty * ssod.UnitPrice) as 'Subtotal'
from Sales.SalesTerritory as sst join sales.Customer as sc
   on sst.TerritoryID = sc.TerritoryID
   join Sales.SalesOrderHeader as ssoh
   on ssoh.TerritoryID = sc.TerritoryID
   join sales.SalesOrderDetail as ssod
   on SSOD.SalesOrderID = SSOH.SalesOrderID
where SST.CountryRegionCode = 'US'
group by SST.TerritoryID

----Câu 3---
select SalesOrderID, CarrierTrackingNumber, Subtotal=SUM(OrderQty * UnitPrice) 
	from Sales.SalesOrderDetail
	where CarrierTrackingNumber like '4BD%'
	group by SalesOrderID, CarrierTrackingNumber


---Câu 4---
select pp.ProductID, pp.Name, AVG(SSOD.UnitPrice) as 'AverageOfQty'
from Production.Product as pp join Sales.SalesOrderDetail as SSOD
on pp.ProductID = SSOD.ProductID
where SSOD.UnitPrice < 25
group by pp.ProductID, pp.Name
having AVG(SSOD.OrderQty) > 5

----Câu 5-----
select JobTitle, CountofEmployee=count(BusinessEntityID) 
	from HumanResources.Employee 
	group by JobTitle
	having COUNT(BusinessEntityID) > 20

---Câu 6---
select v.BusinessEntityID, v.Name, ProductID, sumofQty = SUM(OrderQty), SubTotal = SUM(OrderQty * UnitPrice)
	from Purchasing.Vendor v join Purchasing.PurchaseOrderHeader h on h.VendorID = v.BusinessEntityID
							 join Purchasing.PurchaseOrderDetail d on h.PurchaseOrderID = d.PurchaseOrderID
	where v.Name like '%Bicycles'
	group by v.BusinessEntityID, v.Name, ProductID
	having SUM(OrderQty * UnitPrice) > 800000

---Câu 7---
select p.ProductID, p.Name, countofOrderID = COUNT(o.SalesOrderID), Subtotal = sum(OrderQty * UnitPrice) 
	from Production.Product p join Sales.SalesOrderDetail o on p.ProductID = o.ProductID
							  join sales.SalesOrderHeader h on h.SalesOrderID = o.SalesOrderID
	where Datepart(q, OrderDate) =1 and YEAR(OrderDate) = 2008
	group by p.ProductID, p.Name
	having sum(OrderQty * UnitPrice) > 10000 and COUNT(o.SalesOrderID) > 500

---Câu 8---
select PersonID, FirstName +' '+ LastName as fullname, CountOfOrders=count(*)
from [Person].[Person] p join [Sales].[Customer] c on p.BusinessEntityID=c.CustomerID
						 join [Sales].[SalesOrderHeader] h on h.CustomerID= c.CustomerID
where YEAR([OrderDate])>=2007 and YEAR([OrderDate])<=2008
group by PersonID, FirstName +' '+ LastName
having count(*)>25

---Câu 9---
select pp.ProductID, pp.Name, CountofOrderQty = sum(ssod.OrderQty), yearofSale=year(ssoh.OrderDate)
from Production.Product pp 
join Sales.SalesOrderDetail ssod on ssod.ProductID=pp.ProductID
join Sales.SalesOrderHeader ssoh on ssod.SalesOrderID=ssoh.SalesOrderID
where pp.Name like 'Bike%' or name like 'Sport%'
group by pp.ProductID, pp.Name, year(ssoh.OrderDate)
having sum(ssod.OrderQty) > 500

---Câu 10---
select hrd.DepartmentID, hrd.name, AvgofRate=avg(heph.Rate)
from HumanResources.Department hrd 
join HumanResources.EmployeeDepartmentHistory hedh on hrd.DepartmentID=hedh.DepartmentID
join HumanResources.EmployeePayHistory heph on hedh.BusinessEntityID=heph.BusinessEntityID
group by hrd.DepartmentID, hrd.name
having avg(heph.Rate)>30

---II
---Câu 1---
select ProductID, Name
from Production.Product
where ProductID in (select ProductID
					from  Sales.SalesOrderDetail d join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
					where MONTH(OrderDate)=7 and YEAR(OrderDate)=2008
					group by  ProductID
					having COUNT(*)>100)
---
select ProductID, Name
from Production.Product p 
where  exists (select ProductID
					from  Sales.SalesOrderDetail d join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
					where MONTH(OrderDate)=7 and YEAR(OrderDate)=2008 and ProductID=p.ProductID
					group by  ProductID
					having COUNT(*)>100)

----Câu 2--
select p.ProductID, Name
from Production.Product p join Sales.SalesOrderDetail d on p.ProductID=d.ProductID
	                      join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
where  MONTH(OrderDate)=7 and YEAR(OrderDate)=2008
group by p.ProductID, Name
having COUNT(*)>=all( select COUNT(*)
					  from Sales.SalesOrderDetail d join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
	                  where MONTH(OrderDate)=7 and YEAR(OrderDate)=2008
					  group by ProductID
					  )
----Câu 3------
select [CustomerID], count(*)
from [Sales].[SalesOrderHeader]
group by [CustomerID]
having count(*)>=all(	select count(*)
						from [Sales].[SalesOrderHeader]
						group by [CustomerID]
					)
select 	c.CustomerID, CountofOrder=COUNT(*)
from Sales.Customer c join Sales.SalesOrderHeader h on c.CustomerID=h.CustomerID
group by c.CustomerID
having COUNT(*)>=all(select COUNT(*)
					 from Sales.Customer c join Sales.SalesOrderHeader h on c.CustomerID=h.CustomerID
					 group by c.CustomerID)

----Câu 4---
select ProductID, Name
from Production.Product 
where ProductModelID in (select ProductModelID 
						 from Production.ProductModel
						 where Name like 'Long-Sleeve Logo Jersey%')

select ProductID, Name
from Production.Product p
where exists (select ProductModelID 
						 from Production.ProductModel
						 where Name like 'Long-Sleeve Logo Jersey%' and ProductModelID=p.ProductModelID)
----Câu 5---
select p.ProductModelID, m.Name, max(ListPrice)
from Production.ProductModel m join Production.Product p on m.ProductModelID=p.ProductModelID
group by p.ProductModelID, m.Name
having max(ListPrice)>=all(select AVG(ListPrice)
							from Production.ProductModel m join Production.Product p on m.ProductModelID=p.ProductModelID
							)
----Câu 6--
select ProductID, Name
from Production.Product 
where ProductID in (select ProductID 
					from Sales.SalesOrderDetail
					group by ProductID
					having SUM(OrderQty)>5000)
select ProductID, Name
from Production.Product p
where exists (select ProductID 
					from Sales.SalesOrderDetail
					where ProductID=p.ProductID
					group by ProductID
					having SUM(OrderQty)>5000)
----Câu 7-----
select distinct ProductID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice>=all (select distinct UnitPrice
					 from Sales.SalesOrderDetail)

-----Câu 8----
select P.productID, Name
from Production.Product p left join Sales.SalesOrderDetail d on p.ProductID=d.ProductID
where d.ProductID is null

select productID, Name
from Production.Product
where productID not in (select productID 
						from Sales.SalesOrderDetail)

select productID, Name
from Production.Product p
where not exists (select productID 
				  from Sales.SalesOrderDetail
				  where p.ProductID=ProductID)

----Câu 9-----
select [BusinessEntityID] as EmployeeID, FirstName, LastName
from [Person].[Person]
where [BusinessEntityID]  in (select [SalesPersonID]
								 from [Sales].[SalesOrderHeader]
								 where [OrderDate]>'2008-5-1'
								 )












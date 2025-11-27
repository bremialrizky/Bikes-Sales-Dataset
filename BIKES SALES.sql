if object_id('sales2.bike_sales' , 'U') is not null
	drop table sales2.bike_sales;
Create table sales2.bikes_sales(
Dates date,
Day_Name nvarchar(50),
Months nvarchar(50),
Years int,
Customer_Age int,
Age_Group nvarchar(50),
Customer_Gender nvarchar(50),
Country nvarchar(50),
Stated nvarchar(50),
Product_Category nvarchar(50),
Sub_Category nvarchar(50),
Products nvarchar(50),
Order_Quantity int,
Unit_Cost int,
Unit_Price int,
Profit int,
Cost int,
Revenue int
);

Bulk Insert sales2.bike_sales
from 'D:\Bahan Belajar\Phyton Code\Bike Sales Analysis\Clean Data.csv'
with (
	format = 'CSV',
    firstrow = 2,
    fieldterminator = ',',
    Rowterminator = '\n',
    codepage = '65001',
    tablock
)



--Total Revenue
Select
Sum (Revenue) as Total_Revenue
from sales2.bikes_sales
group by Day_Name
order by Total_revenue desc

--Total Sold Item
Select
Sum (Order_quantity) as Total_Sold
from sales2.bikes_sales

--GMV
Select
(Sum (order_quantity) as float / cast(Sum (unit_price) as float)
--sum (order_quantity) * sum(unit_price) as Gross_Merchant_Value
from sales2.Bikes_Sales

--Avg Order Value
Select
Sum (Order_Quantity) as Total_Order,
cast(Sum (Revenue) as float) / cast(Sum (Order_Quantity) as float) as Avg_Order_value
from sales2.bikes_sales
group by Day_Name
order by AOV

--Avg Operational Margin
select 
cast(1.0 * sum (Profit) / sum (Revenue) * 100 as decimal(10,2)) as avg_operational_margin
from sales2.Bikes_Sales
where revenue <> 0


--Sales Trends By Month and Daily
Select
Day_name,
Sum (Profit) as TProfit_Day
from sales2.bikes_sales
group by Day_name
order by TProfit_Day desc

Select
Month,
Sum (Profit) as TProfit_Month
from sales2.bikes_sales
group by Month
order by TProfit_Month desc

--Sales Trends By Quarter Year
select
datepart(Year, Date) as tahun,
datepart(Quarter, Date) as kuartal,
sum(profit) as TProfit_Year
from sales2.bikes_sales
group by datepart(Year, Date),
         datepart(Quarter, Date)
order by Tahun, Kuartal


--Top 5 Best Sub Product Sold
select top 5
    Product_Category,
    Sub_Category,
    Product,
    sum(Order_Quantity) as Total_Order,
    Rank() over (order by sum(Order_Quantity) desc) as Rank_Product
from sales2.bikes_sales
--where Product_Category = 'Accessories' and Year = 2014
group by Product_Category, Sub_Category, Product
order by Rank_productder desc

--Performance Sales By Category
Select
Product_Category,
sum(Profit) as TProfit_Product_Cateogry
From sales2.Bikes_Sales
Group by Product_Category
Order by TProfit_Product_Cateogry desc

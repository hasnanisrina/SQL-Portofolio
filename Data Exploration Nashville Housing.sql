/*Exploration Data in SQL
Skills Used: Agrregate, Subquery, CTE*/

Select *
From [SQL Portofolio].[dbo].[Nashville Housing ]

----------------------------------------------------
--Top OwnerName Most Sales
Select OwnerName, SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
WHERE OwnerName is not null
Order By SalePrice DESC

--Top LandUse Most Sales
Select Landuse, SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]

--The house built after 2000 and having more than 5 bedrooms
Select PropertyAddress, OwnerName, SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
Where YearBuilt>2000 AND Bedrooms > 5
Order By SalePrice DESC

--Counting the number of Property Address, Average Sale Price in each City
Select PropertySplitCity, count(PropertySplitCity) as Count_PropertySplitCity, avg(Saleprice) as avg_SalePrice, avg(Bedrooms) as avg_Bedroom
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by PropertySplitCity
Order By count(PropertySplitCity) DESC

--Date has the most frequent sales
Select SaleDataConverted, count(1) as sales_count, sum(SalePrice) as sum_SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by SaleDataConverted
Order by sales_count DESC

--Year has the lowest number of sales
Select YearDate, count(1) as sales_count, sum(SalePrice) as sum_SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by YearDate
Order by sales_count

--Year has the number of sales more than 14250
Select*
from
(Select YearDate, count(1) as sales_count, sum(SalePrice) as sum_SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by YearDate
)subq
where sales_count>14250

--Year has the number of sum sales less than 3000000
With YearQuery as
(Select YearDate, count(1) as sales_count, sum(SalePrice) as sum_SalePrice
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by YearDate
)Select*
from YearQuery
where sum_SalePrice < 3000000
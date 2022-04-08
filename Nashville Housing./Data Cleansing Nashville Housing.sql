/*Cleaning Data in SQL*/

Select *
From [SQL Portofolio].[dbo].[Nashville Housing ]

----------------------------------------------------

--Standardize Date Format
Select SaleDate
From [SQL Portofolio].[dbo].[Nashville Housing ]

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET SaleDate = CONVERT(Date, Saledate)

--It doesn't update properly, so I use this
ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add SaleDataConverted Date;

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET SaleDataConverted = CONVERT(Date, Saledate)

Select SaleDate, SaleDataConverted
From [SQL Portofolio].[dbo].[Nashville Housing ]

--Breaking out Date into Individual Columns (Day, Month, Year)
Select 
	datepart(DAY,SaleDataConverted) as DAY,
	datepart(MONTH,SaleDataConverted) as MONTH,
	datepart(YEAR,SaleDataConverted) as YEAR
From [SQL Portofolio].[dbo].[Nashville Housing ]

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add DayDate Int;

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET DayDate = datepart(DAY,SaleDataConverted)

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add MonthDate Int;

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET MOnthDate = datepart(MONTH,SaleDataConverted)

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add YearDate Int;

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET YearDate = datepart(YEAR,SaleDataConverted)

--Populate Property Address Data
Select *
From [SQL Portofolio].[dbo].[Nashville Housing ]
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Portofolio].[dbo].[Nashville Housing ] a
JOIN [SQL Portofolio].[dbo].[Nashville Housing ] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Portofolio].[dbo].[Nashville Housing ] a
JOIN [SQL Portofolio].[dbo].[Nashville Housing ] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)
---For Property Address
Select PropertyAddress
From [SQL Portofolio].[dbo].[Nashville Housing ]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From [SQL Portofolio].[dbo].[Nashville Housing ]

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add PropertySplitAddress Nvarchar(255);

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add PropertySplitCity Nvarchar(255);

UPDATE [SQL Portofolio].[dbo].[Nashville Housing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

---For Owner Address
Select OwnerAddress
From [SQL Portofolio].[dbo].[Nashville Housing ]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [SQL Portofolio].[dbo].[Nashville Housing ]

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add OwnerSplitAddress Nvarchar(255);

Update [SQL Portofolio].[dbo].[Nashville Housing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add OwnerSplitCity Nvarchar(255);

Update [SQL Portofolio].[dbo].[Nashville Housing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [SQL Portofolio].[dbo].[Nashville Housing ]
Add OwnerSplitState Nvarchar(255);

Update [SQL Portofolio].[dbo].[Nashville Housing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [SQL Portofolio].[dbo].[Nashville Housing ]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [SQL Portofolio].[dbo].[Nashville Housing ]

Update [SQL Portofolio].[dbo].[Nashville Housing ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [SQL Portofolio].[dbo].[Nashville Housing ]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [SQL Portofolio].[dbo].[Nashville Housing ]
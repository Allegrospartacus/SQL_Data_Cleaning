select * 
from [Portfolio]..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format 

ALTER TABLE [Portfolio]..NashvilleHousing
ALTER COLUMN saleDate  date

-- just cheacking

select SaleDate
from [Portfolio]..NashvilleHousing

select top(5) * 
from [Portfolio]..NashvilleHousing
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data 
-- the houses with the same ParcelID have the same PropertyAddress

select v1.ParcelID ,v1.PropertyAddress,v2.ParcelID ,v2.PropertyAddress,
	   ISNULL(v1.PropertyAddress ,v2.PropertyAddress) as toPopulate

from [Portfolio]..NashvilleHousing v1
join [Portfolio]..NashvilleHousing v2
on v1.ParcelID=v2.ParcelID
and v1.[UniqueID ]<>v2.[UniqueID ] --that is an important line to make sure they are not the same row
where v1.PropertyAddress is null



--updating the table

update v1
set PropertyAddress = ISNULL(v1.PropertyAddress ,v2.PropertyAddress)
from [Portfolio]..NashvilleHousing v1
join [Portfolio]..NashvilleHousing v2
on v1.ParcelID=v2.ParcelID
and v1.[UniqueID ]<>v2.[UniqueID ]
where v1.PropertyAddress is null
--just cheacking
select *
from [Portfolio]..NashvilleHousing
where PropertyAddress is null

-------------------------------------------------------------------------------------------------------------------------



--Breaking out PropertyAddress into Individual Columns using SUBSTRING

Select PropertyAddress
From [Portfolio]..NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as city
From [Portfolio]..NashvilleHousing

--updating the table

ALTER TABLE [Portfolio].. NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE [Portfolio].. NashvilleHousing
Add PropertySplitCity Nvarchar(255);



Update [Portfolio]..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


Update [Portfolio]..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--just cheacking

Select top(5)*
From [Portfolio]..NashvilleHousing


------------------------
--Breaking out OwnerAddress into Individual Columns using PARSENAME

Select OwnerAddress
From [Portfolio]..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as city 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as state
From [Portfolio]..NashvilleHousing

--updating the table

ALTER TABLE [Portfolio].. NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


ALTER TABLE [Portfolio].. NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE [Portfolio]..NashvilleHousing
Add OwnerSplitState Nvarchar(255);



Update [Portfolio]..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update [Portfolio].. NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update [Portfolio]..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--just cheacking

Select top(5)*
From [Portfolio]..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant, Count(SoldAsVacant)
From [Portfolio]..NashvilleHousing
Group by SoldAsVacant
order by 2

--find and replace

Select distinct(SoldAsVacant)
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 
From [Portfolio]..NashvilleHousing

--updating the table

Update [Portfolio]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--just checking
Select SoldAsVacant, Count(SoldAsVacant)
From [Portfolio]..NashvilleHousing
Group by SoldAsVacant
order by 2

--------------------------------------------------------------------------------------------------------------------------
--Remove duplicates
-- if a row has the same ParcelID, PropertyAddress, SalePrice,
	-- Sale Date and LegalReference We can say that is a duplicate value
	
-- Create a CTE to find duplicates

WITH RowNumCTE AS(
SELECT * ,
    ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY
                     UniqueID
                 ) row_num

FROM Portfolio..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1	

-- now lets remove them
select COUNT(*)as beforeRemovingDuplicates
from Portfolio..NashvilleHousing


----
--WITH RowNumCTE AS(
--SELECT * ,
--    ROW_NUMBER() OVER (
--    PARTITION BY ParcelID,
--                 PropertyAddress,
--                 SalePrice,
--                 SaleDate,
--                 LegalReference
--                 ORDER BY
--                     UniqueID
--                 ) row_num

--FROM Portfolio..NashvilleHousing
--)
--delete *
--FROM RowNumCTE
--WHERE row_num > 1	


--just cheacking 
select COUNT(*)as afterRemovingDuplicates
from Portfolio..NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------

--  a littile Exploration Data Analysis
select * 
from [Portfolio]..NashvilleHousing


--average salePrice per yearBuilt
select YearBuilt,AVG(salePrice)as avg_saleprice ,COUNT(saleprice)as num_ofHouses
from Portfolio..NashvilleHousing 
group by YearBuilt
order by 1 desc

--average salePrice per city
select PropertySplitCity ,AVG(saleprice)as avg_saleprice,COUNT(saleprice)as num_ofHouses
from Portfolio..NashvilleHousing
group by PropertySplitCity
order by 2 desc

--number of houses by LandUse
select LandUse,COUNT(*) as countHouses
from Portfolio..NashvilleHousing
group by LandUse
order by 2 desc
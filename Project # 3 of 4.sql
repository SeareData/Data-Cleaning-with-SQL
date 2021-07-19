

	--Cleaning data in sql queries
	--This is a data cleaning project for sunday July 18th/2021

            Select *
			from Nash_hd
			where propertyaddress is null
                  

	--STANDARDAIZE DATE FORMAT 
	 Select saledate,Convert(date,saledate)
	 From Nash_hd;

   --Result: It converts from this (2013-12-06 00:00:00.000) to (2013-12-06) in order to alter our old data now we should update it.
     Update Nash_hd
     Set saledate=Convert(date,saledate)
   ---It didn't work at all(I think the reason is you have to use where clause to update and in this case we can'nt do that since it is a lot of rows), so we have to use another 
   ---means).
   ALTER TABLE Nash_hd 
   Add Newdateformated Date;--In this case we are now able to create a column with the name "Saledateupdated"with records of null. there for we now need to populate the rows using update.
  
   Update Nash_hd                                    
   Set Newdateformated=Convert(date,saledate) ---now since we have created a new column we are able to populate easily. so from this lesson one thing we can learn is, to update a whole 
                                               --column it is better to first create a new column using alter add statement and then pupulate the rows with Update table function.
	--TASK 2. Populate property address data.
	 Select propertyaddress
	 From Nash_hd
	 where propertyaddress is null; ---as you can see there are 29 null values, which means properties with out an address.another big lesson here is when i did use "="instead of "is" those
	                                 --null records didn't appear.only the column names did appear. so this means when using where clause to search null values I have to use 'is'.
	 
	 select a.parcel

	 select parcelid, propertyaddress
	 from Nash_hd
	 where parcelid in ('033 06 0 041.00','026 06 0A 038.00','033 15 0 123.00','034 16 0A 004.00','041 03 0A 100.00','034 07 0B 015.00','034 03 0 059.00','025 07 0 031.00',
	 '026 01 0 069.00','026 05 0 017.00','092 06 0 273.00','092 06 0 282.00','113 14 0A 002.00','110 03 0A 061.00','109 04 0A 080.00','092 13 0 322.00','092 13 0 339.00',
	 '093 08 0 054.00','114 15 0A 030.00','107 13 0 107.00','108 07 0A 026.00','052 01 0 296.00','052 08 0A 320.00','042 13 0 075.00','043 13 0 308.00','043 09 0 074.00',
	 '043 04 0 014.00','044 05 0 135.00')
	 when I run the above query(weired?) I found out that for the same identical parcelid there are two addresses. one is 'null' and the other one is a real actual address.
	 now that is the reason why the instructor is trying to make a self join and fill the null values with the actual address.
	  --Here this is the theory
	  --Let say parcel A = Address X
	         -- Parcel B = Null
			 ---If parcel A=Parcel B
			 ----Then Change Parcel B's address from Null to address X.
	 
	 Select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,ISNUll(a.propertyaddress,b.propertyaddress)
	 --Here I am saying if you find null in a.propertyaddrss then give me another column with an address correosponding to b.propertyaddress if there is some value.)
	 from nash_hd a
	 join nash_hd b
	 on a.parcelid=b.parcelid
	 and a.uniqueid<>b.uniqueid
	 where a.propertyaddress is null

	 update a 
	 set propertyaddress=Isnull(a.propertyaddress,b.propertyaddress)
	 from nash_hd a
	 join nash_hd b
	 on a.parcelid=b.parcelid
	 and a.uniqueid<>b.uniqueid
	 where a.propertyaddress is null;

	--Breaking out Address into Individual columns (address, City, State)

   Select PropertyAddress
   From nash_hd
 
SELECT 
      --Thsi next step is just to see if charindex is working.
    Select PropertyAddress,Charindex(',',PropertyAddress)from nash_hd 
	--first let me extract the street address which is located left of the delimiter or comma.
	--to perform this job, I will use Left(),and charindex.
	 Select Left(PropertyAddress,Charindex(',',PropertyAddress))from nash_hd
	 --after executing this query the comma delimiter will still be present so..will write the 
	 --following query to eliminate ','
Select Left(PropertyAddress,Charindex(',',PropertyAddress)-1) AS streetaddress
from nash_hd
--NOW we extracted street address already.We will create a new column and then update the new column
  Alter table nash_hd
  add streetaddress nvarchar(255);
  --Next let us update the street address column
  Update nash_hd
  Set streetaddress=Left(Propertyaddress,charindex(',',streetaddress)-1)
 
  --So far we only did the left string now let's do the right part of the string (City)
  --First let's extract the right part (city) to see if our query is correct.
Select Right(PropertyAddress,Len(PropertyAddress)-Charindex(',',PropertyAddress))As city 
from nash_hd
--Now let us create a coumn with city.
   Alter table nash_hd
   add City nvarchar(255);
 --Now let's update the city or using the right string.
 update nash_hd
 set city=Right(PropertyAddress,Len(PropertyAddress)-Charindex(',',PropertyAddress))
 --Here we are saying update the city column by extracting right to the property address 
-- starting from length of the propertyaddress minus the position, where the delimiter
  --is located.That means if the property address has 25 characters, and if comma is found
    --at 18th position,the start posion will start @ (25-18)=7.

--Check 
Select * from nash_hd





select owneraddress from nash_hd

select owneraddress,Left(owneraddress,charindex(',',owneraddress)-1) as ownerstreetaddress
from nash_hd 

Select Right(owneraddress,Len(owneraddress-charindex(',',owneraddress)-1)) as citystate
from nash_hd 
--Let us try to use the super usable Parsename() function.
--as a side note parse means to analyze a sentence in to it's parts and describe their
  ----syntax roles.
--Let's first try to work with one obviousely to fail query.
   Select parsename(owneraddress,1) from nash_hd;
--as we can see from the out put it didn't do any change.the reason is this function doesnt
---recognize commas,there fore commas must be replaced with periods.in order to do that we -
--will use REPLACE()function.Here i am asking the query to Parsename a string(owneraddress)-
--after it's comma is Replaced with Period) 
--Notice here parsename function counts from back to front,like an arabic language.

Select owneraddress,
Parsename (Replace(owneraddress,',','.'),3) AS ownerstreetaddress,
Parsename (Replace(owneraddress,',','.'),2) AS ownercity,
Parsename (Replace(owneraddress,',','.'),1) AS ownerstate
from nash_hd;
---Next let us now create a column and populate them using update statement.
---Let's create first ownerstreetaddress column
   Alter table nash_hd
   add ownerstreetaddress nvarchar(255)
--let's now update(populate)the column we have made already
    update nash_hd
	set ownerstreetaddress=Parsename (Replace(owneraddress,',','.'),3)

---Let's create now ownercity column
   Alter table nash_hd
   add ownercity nvarchar(255)
   --let's now update(populate)the column we have made already
    update nash_hd
	set ownercity=Parsename (Replace(owneraddress,',','.'),2) 

---Let's create ownerstate column
   Alter table nash_hd
   add ownerstate nvarchar(255)
--let's now update(populate)the column we have made already
    update nash_hd
	set ownerstate=Parsename (Replace(owneraddress,',','.'),1)

---Let's now check our work.
Select ownerstreetaddress,ownercity,ownerstate from nash_hd;
---Everything great!


-- CHANGE Y AND N to YES and NO in "SOLD as VACANT" FIELD---
--Let us first check if the claim is valid.
select soldasvacant 
from nash_hd
where soldasvacant in ('y','n')
--based on the query we executed above,we found out that there are multiple 'Y's and 'N's.
--Now let's write a query that can bring an output that we desired.
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END as Updatedsoldasvacant
From Nash_hd
--After executing the above query we can see the desired output has performed.
--Next step will be to UPDATE the Soldasvacant column.
Update nash_hd
Set soldasvacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 
--Let's check if we have any more 'Y's and 'N's
     select soldasvacant 
     from nash_hd
     where soldasvacant in ('y','n')
--we don't have 'Y's and 'N's any more so we are good to go.

--REMOVE DUPLICATES--
   --Let's first check if the claim about duplicates is valid.
   --we will just pick one column and execute the following query.
   Select streetaddress ,count(*)
   From nash_hd 
   Group by streetaddress
   having count(*)>1
--We have proved from the output that we have tons of duplicates.
--let's first create a cte table
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
					) as row_num   
From Nash_hd
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
--The above query is a second method to see if i have duplicates. 
--Now we have seen all of our duplicates.
--Next step will be to delete all my duplicates by using delete instead of select from
--above query.

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
From Nash_hd
--order by ParcelID
)
delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

---now let us see if we have duplicates any more using the first query that we have been using to check if we have duplicates.
----checked already and i have an out put of zero duplicates.
--Final note: to be honest i didn't clearly uderstand the topic with removing duplicates

--DELETING UNUSED COLUMNS 
--to see what columns we need to delete let us see our table
select * from nash_hd
---we see that we have some column that we dont need to keep them,like the propertyaddress,owneraddress etc.
Alter table nash_hd
Drop Column propertyaddress,owneraddress,taxdistrict saledate

Alter table nash_hd
Drop Column saledate
--Final comment:The wohle point of cleaning data is to make it much more usable,more frindely and more standardaized.


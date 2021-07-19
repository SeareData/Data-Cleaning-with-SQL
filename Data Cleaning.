

	--Cleaning data in sql queries
	--This is a data cleaning project for sunday July 18th/2021

           
                  

  --Task 1--STANDARDAIZE DATE FORMAT 
  --Issue:Date not recorded in standard format[Example:(2013-12-06 00:00:00.000) to (2013-12-06)].
  
   ---Step 1-Make a column name Newdateformated 
   ALTER TABLE Nash_hd 
   Add Newdateformated Date;
  --Step 2-Populate the Newdateformated column with values converted to date format.
   Update Nash_hd                                    
   Set Newdateformated=Convert(date,saledate)
   ---Step 3-Check Output. 
          Select Newdateformated 
          From Nash_hd
   
--TASK 2. POPULATE PROPERTY ADDRESS DATA.
--Issue:Populating Records that have null values with Proper address.

--Step1:Validating the claim.
         Select propertyaddress
         From Nash_hd
         Where propertyaddress is Null; 
--We have 29 null values in property address,which means 29 properties without an address.
--Step2:Using ISNULL()function and Selfjoin Update Property address
--Assumption: 
    --ParecelA=Parcelx
    -- Parcel B= Null
    --If parcelA=ParcelB
    --Then Change ParcelB's address from Null to address x
	 
	 Update a 
	 Set propertyaddress=Isnull(a.propertyaddress,b.propertyaddress)
	 From nash_hd a
	 Join nash_hd b
	 On a.parcelid = b.parcelid
	 And a.uniqueid<>b.uniqueid
	 Where a.propertyaddress is null;

--TASK 3. BREAKING OUT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS,CITY,STATE)
--Step 1:Validiating the Claim
        Select PropertyAddress
        From nash_hd
--Step 2:Creating Columns With Streetaddress and City.
        Alter Table nash_hd
        Add streetaddress Nvarchar(255);
        Alter Table nash_hd
        Add City nvarchar(255);
--Step 3: Populating Streetaddress and City Columns. 
        Update nash_hd
        Set streetaddress= Left (Propertyaddress,charindex(',',streetaddress)-1)
        Update nash_hd
        Set city=Right(PropertyAddress,Len(PropertyAddress)-Charindex(',',PropertyAddress))
 
--TASK 4: BREAKING OUT OWNERS ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)USING PARSENAME() FUNCTION.

--Step 1:Checking if there is unfriendely data .   
        Select owneraddress 
	From nash_hd
--Step2:Creating Columns Ownerstreetaddress, Ownercity and Ownerstate.
        Alter Table nash_hd
        add ownercity nvarchar(255)
	Alter Table nash_hd
        add ownerstreetaddress nvarchar(255)
	Alter Table nash_hd
        add ownerstate nvarchar(255)
--Step3:Stuffing Ownerstreetaddress,Ownercity and Ownerstate.
        Update nash_hd
	Set ownerstreetaddress=Parsename (Replace(owneraddress,',','.'),3)
	Update nash_hd
	Set ownercity=Parsename (Replace(owneraddress,',','.'),2) 
	Update nash_hd
	Set ownerstate=Parsename (Replace(owneraddress,',','.'),1)
--Step5:Checking the new created columns.
        Select ownerstreetaddress,ownercity,ownerstate 
	From nash_hd;
	
--Task5: CHANGE Y AND N to YES and NO in "SOLD as VACANT" FIELD USING CASE STATEMENT.

--Step1: Checking if "SOLD as Vacant" column has Y and S.
        Select soldasvacant 
        From nash_hd
        Where soldasvacant in ('y','n')
--Step2: Updating "Soldasvacant" Columni 
        Update nash_hd
        Set soldasvacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 
--Step3: Let's check if we have any more 'Y's and 'N's
        Select soldasvacant 
        From nash_hd
        Where soldasvacant in ('y','n')

--Task6: REMOVING DUPLICATES USING ROW_NUMBER() FUNCTION.

--Step1:Checking if there are duplicates in one of any columns in the table.
        WITH RowNumCTE AS
	(
        Select *,
	ROW_NUMBER() OVER(PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	ORDER BY UniqueID) as row_num   
        From Nash_hd
        )
        Select *
        From RowNumCTE
        Where row_num > 1
        Order by PropertyAddress
--Step2:Deleting Duplicates 

        WITH RowNumCTE AS
	(
        Select *,
	ROW_NUMBER() OVER
	(PARTITION BY ParcelID,PropertyAddress, SalePrice,SaleDate,LegalReference
	ORDER BYUniqueID) row_num
	From Nash_hd
        )
        delete
        From RowNumCTE
        Where row_num > 1
--Step3:Checking if there are duplicates any more.
    ----Use query step 1----

--Task7. DELETING UNUSED COLUMNS 
--Step1: Checking if there are any irrelevant columns.
        Select * 
        From nash_hd
--Step2:Dropping all irrelevant columns.
        Alter table nash_hd
        Drop Column propertyaddress,owneraddress,taxdistrict saledate,saledate





/*ETL procedure when inserting power supplier*/
DROP PROCEDURE if exists dbo.UpdateDimPowerSupplier;
/* dbo.UpdateDimPowerSupplier ?,?,?,?,?,?,?,?,?,?,?*/

CREATE PROCEDURE dbo.UpdateDimPowerSupplier
@powerSupplierID int,
@CompanyName nvarchar(50),
@year_founded nvarchar(50),
@HQAddress nvarchar(50),
@Province nvarchar(50),
@City nvarchar(50),
@PostalCode smallint,
@Country nvarchar(50),
@Departments tinyint,
@PowerPlants smallint,
@Branches tinyint
AS BEGIN
	if not exists (select PowerSupplierSK
	from dbo.DimPowerSupplier
	where alternatePowerSupplierID = @powerSupplierID) 
	BEGIN
		insert into dbo.DimPowerSupplier (alternatePowerSupplierID, CompanyName, year_founded, HQAddress, Province, City, PostalCode,
		Country, Departments,PowerPlants, Branches, InsertDate, ModifiedDate)
		values(@powerSupplierID, @CompanyName, @year_founded, @HQAddress, @Province, @City, @PostalCode,
		@Country, @Departments, @PowerPlants, @Branches, GETDATE(), GETDATE()) 
	END;
	if exists (select PowerSupplierSK
	from dbo.DimPowerSupplier
	where alternatePowerSupplierID = @powerSupplierID) 
	BEGIN
		update dbo.DimPowerSupplier
		set alternatePowerSupplierID = @powerSupplierID, CompanyName=@CompanyName, year_founded=@year_founded, HQAddress=@HQAddress, 
		Province=@Province, City=@City, PostalCode=@PostalCode,Country=@Country, Departments=@Departments, PowerPlants=@PowerPlants, Branches=@Branches, 
		ModifiedDate = GETDATE()
		where alternatePowerSupplierID = @powerSupplierID
	END;
END;



/*ETL procedure when inserting PowerPlant*/
DROP PROCEDURE if exists dbo.UpdateDimPowerPlant;
/* dbo.UpdateDimPowerPlant ?,?,?,?,?,?,? */

CREATE PROCEDURE dbo.UpdateDimPowerPlant
@alternatePlantID int,
@DC_POWER real,
@AC_POWER real,
@DAILY_YIELD real,
@TOTAL_YIELD real,
@Type nvarchar(20),
@powerSupplierKey int


AS BEGIN
	if not exists (select PowerPlantSK
	from dbo.DimPowerPlant
	where alternatePlantID = @alternatePlantID ) 
	BEGIN
		insert into dbo.DimPowerPlant (alternatePlantID, DC_POWER, AC_POWER, DAILY_YIELD,TOTAL_YIELD, 
		Type, powerSupplierKey, InsertDate, ModifiedDate)
		values(@alternatePlantID, @DC_POWER, @AC_POWER, @DAILY_YIELD,@TOTAL_YIELD, @Type, @powerSupplierKey, GETDATE(), GETDATE()) 
	END;
	if exists (select PowerPlantSK
	from dbo.DimPowerPlant
	where alternatePlantID = @alternatePlantID ) 
	BEGIN
		update dbo.DimPowerPlant
		set alternatePlantID = @alternatePlantID, DC_POWER=@DC_POWER, AC_POWER=@AC_POWER,
		DAILY_YIELD = @DAILY_YIELD, TOTAL_YIELD=@TOTAL_YIELD, Type=@Type, powerSupplierKey=@powerSupplierKey,  ModifiedDate = GETDATE()
		where alternatePlantID = @alternatePlantID
	END;
END;



/*ETL procedure when inserting PowerDistribution*/
DROP PROCEDURE if exists dbo.UpdateDimPowerPlant;
/* dbo.UpdateDimPowerDistribution ?,?,? */

CREATE PROCEDURE dbo.UpdateDimPowerDistribution
@alternatePowerDistributionID int,
@initiateDate date,
@PowerGenKey int


AS BEGIN
	if not exists (select PowerDistributionSK
	from dbo.DimPowerDistribution
	where alternatePowerDistributionID = @alternatePowerDistributionID ) 
	BEGIN
		insert into dbo.DimPowerDistribution (alternatePowerDistributionID, initiateDate, PowerGenKey, InsertDate, ModifiedDate)
		values(@alternatePowerDistributionID, @initiateDate, @PowerGenKey, GETDATE(), GETDATE()) 
	END;
	if exists (select PowerDistributionSK
	from dbo.DimPowerDistribution
	where alternatePowerDistributionID = @alternatePowerDistributionID ) 
	BEGIN
		update dbo.DimPowerDistribution
		set alternatePowerDistributionID = @alternatePowerDistributionID, initiateDate=@initiateDate, PowerGenKey=@PowerGenKey,
		ModifiedDate = GETDATE()
		where alternatePowerDistributionID = @alternatePowerDistributionID
	END;
END;


/*ETL procedure when inserting PowerUnit*/
DROP PROCEDURE if exists dbo.UpdateDimPowerUnit;
/* dbo.UpdateDimPowerUnit ?,?,?,? */

CREATE PROCEDURE dbo.UpdateDimPowerUnit
@alternateTypeID tinyint,
@alternatepriceDateID date,
@unitPrice float,
@consumerType nvarchar(225)

AS BEGIN
	if not exists (select TypeSK
	from dbo.DimPowerUnit
	where alternatepriceDateID = @alternatepriceDateID AND alternateTypeID = @alternateTypeID) 
	BEGIN
		insert into dbo.DimPowerUnit (alternateTypeID, alternatepriceDateID, unitPrice, consumerType, InsertDate, ModifiedDate)
		values(@alternateTypeID, @alternatepriceDateID, @unitPrice, @consumerType, GETDATE(), GETDATE()) 
	END;
	if exists (select TypeSK
	from dbo.DimPowerUnit
	where alternatepriceDateID = @alternatepriceDateID AND alternateTypeID = @alternateTypeID) 
	BEGIN
		update dbo.DimPowerUnit
		set alternateTypeID = @alternateTypeID, alternatepriceDateID=@alternatepriceDateID, unitPrice=@unitPrice,
		consumerType=@consumerType, ModifiedDate = GETDATE()
		where alternatepriceDateID = @alternatepriceDateID AND alternateTypeID = @alternateTypeID
	END;
END;





/*ETL procedure when update completion time*/
CREATE PROCEDURE dbo.UpdateFactTable
@ConsumptionID int,
@accm_txn_complete_time datetime,
@txn_process_time_hours int
AS BEGIN

	if exists (select ConsumptionID
		from dbo.FactPowerConsumptionCharges
		where ConsumptionID = @ConsumptionID)
	BEGIN
		update dbo.FactPowerConsumptionCharges set accm_txn_complete_time = @accm_txn_complete_time, 
		txn_process_time_hours = @txn_process_time_hours, ModifiedDate=getdate()
		where ConsumptionID = @ConsumptionID;
	END;

END;



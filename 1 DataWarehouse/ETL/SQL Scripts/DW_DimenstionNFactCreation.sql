
/* DimPowerSupplier dimension*/
drop table if exists DimPowerSupplier;
create table DimPowerSupplier(
	PowerSupplierSK int identity(1,1) primary key,
	alternatePowerSupplierID tinyint, 
	CompanyName nvarchar(50), 
	year_founded nvarchar(50), 
	HQAddress nvarchar(50), 
	Province nvarchar(50), 
	City nvarchar(50), 
	PostalCode smallint, 
	Country nvarchar(50), 
	Departments tinyint, 
	PowerPlants smallint, 
	Branches tinyint, 

	InsertDate datetime, 
	ModifiedDate datetime
)


/* DimPowerPlant dimension */
drop table if exists DimPowerPlant;
create table DimPowerPlant(
	PowerPlantSK int identity(1,1) primary key,
	alternatePlantID int, 
	DC_POWER real, 
	AC_POWER real, 
	DAILY_YIELD real, 
	TOTAL_YIELD real, 
	Type nvarchar(20), 
	powerSupplierKey int foreign key references DimPowerSupplier(PowerSupplierSK),

	InsertDate datetime, 
	ModifiedDate datetime
)


/* DimPowerDistribution dimension */
drop table if exists DimPowerDistribution;
create table DimPowerDistribution(
	PowerDistributionSK int identity(1,1) primary key,
	alternatePowerDistributionID int, 
	initiateDate date, 
	PowerGenKey int foreign key references DimPowerPlant(PowerPlantSK),

	InsertDate datetime, 
	ModifiedDate datetime
)



/* DimConsumer dimension*/
drop table if exists DimConsumer;
create table DimConsumer(
	ConsumerSK int identity(1,1) primary key,
	alternateAccountID smallint,
	consumerID smallint,
	Consumer_Fname	nvarchar(50),
	Consumer_Lname	nvarchar(50),
	age	tinyint,
	PhoneNumber	nvarchar(50),
	race nvarchar(50),
	sex	nvarchar(50),
	type tinyint,
	typeName nvarchar(50),
	EmailAddress nvarchar(50),

	Province nvarchar(50),
	city nvarchar(50),
	Postal_code	nvarchar(50),
	Country	nvarchar(50),
	Latitude float,
	Longitude float,
	ConsumerAddress	nvarchar(50),
	distributionID int,

	StartDate datetime,
	EndDate	datetime,
	InsertDate datetime, 
	ModifiedDate datetime
)

/* DimPowerUnit dimension*/
drop table if exists DimPowerUnit;
create table DimPowerUnit
(
	TypeSK	int identity(1,1) primary key,
	alternateTypeID tinyint,
	alternatepriceDateID date,
	unitPrice float,
	consumerType nvarchar(225),

	InsertDate DateTime,
	ModifiedDate DateTime
)



/*Fact table*/
drop table if exists FactPowerConsumptionCharges;
create table FactPowerConsumptionCharges(
	consumptionID int,
	ConsumptionChargeDateKey int foreign key references DimDate(DateKey),

	/*Consumer + InstallService*/
	ConsumerKey	int foreign key references DimConsumer(ConsumerSK),
	installFee float,

	/*PowerUnit*/
	unitKey int foreign key references DimPowerUnit(TypeSK),
	unitPrice float,

	/*Power Distribution -> PowerPlant -> PowerSupplier*/
	DistributionKey int foreign key references DimPowerDistribution(PowerDistributionSK),

	SmartMeterPerc decimal(10,2),
	NoOfUnit decimal(10,2),
	entrant tinyint,

	/*Derived*/
	totalPrice float,
	subTotal float,

	/*SrcDetailModifiedDate datetime,*/
	InsertDate datetime,
	ModifiedDate datetime
)


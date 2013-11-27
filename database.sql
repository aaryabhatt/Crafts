--
-- Database for Maavalan Travels
--
--
-- Version 1.25
-- Tirveni Yadav<tirveni@udyansh.org>
-- use database maavalan;
--
-- 1.26 
-- 20131021
-- TripPicture and HotelPicture have descript field.
-- 
-- 1.25
-- Cart,PaymentHandler,ItemofCart,CartOrdered,ItemOfOrder Added
--
-- 1.23
-- TripDay references City. Useful for TripDayHotel And Search
--
-- 1.22 TableTag is not to be used anymore.
-- Table Tagsoftrips,Tagsofpages are to be used.
--
-- 1.21 Table Tag's column tagtype is not null now.
--
-- 1.18
-- Image and Icon links in theme,season,region,transport,language.
--
-- 1.17
-- HotelCode modified to 60 chars
--
-- 1.16
-- HotelName added to Hotel,HotelLang
--
-- 1.15
-- TripdayHotel is referenced to TripDay,TripCost,Hotel.
-- ReferenceOfTrip is for multiple tripid references.(SEO Optimizations).
--
-- 1.14
-- Table TagType created. And more columns added to Table Tag.
--
-- Version 1.11  2013-06-25
-- View V_trip created
-- TRIP:: 1:n ::    Theme,Season,Region (These are in 1:n against Trip )
-- Added priority to Theme,Season,Region for display order
--



DROP TABLE IF EXISTS Roles CASCADE;
DROP TABLE IF EXISTS Privilege CASCADE;
DROP TABLE IF EXISTS Access CASCADE;
DROP TABLE IF EXISTS Appuser CASCADE;
DROP TABLE IF EXISTS UserEmail CASCADE;

DROP TABLE IF EXISTS LanguageType CASCADE;
DROP TABLE IF EXISTS PageStatic CASCADE;
DROP TABLE IF EXISTS PageStaticLang CASCADE;
DROP TABLE IF EXISTS Currency CASCADE;
DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS State CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS CityLang CASCADE;

DROP TABLE IF EXISTS Transport CASCADE;
DROP TABLE IF EXISTS TransportLang CASCADE; 

--Trip Themes(Categories/Activity)
DROP TABLE IF EXISTS Theme CASCADE;
DROP TABLE IF EXISTS ThemeLang CASCADE;

--Basic of Trip 
DROP TABLE IF EXISTS HotelFacilityTypes CASCADE; 
DROP TABLE IF EXISTS Hotel CASCADE;
DROP TABLE IF EXISTS HotelPrice CASCADE;
DROP TABLE IF EXISTS HotelLang CASCADE;
DROP TABLE IF EXISTS HotelPictures CASCADE;
DROP TABLE IF EXISTS HotelFacility CASCADE;

DROP TABLE IF EXISTS Region CASCADE;
DROP TABLE IF EXISTS RegionLang CASCADE;
DROP TABLE IF EXISTS Season CASCADE;
DROP TABLE IF EXISTS SeasonLang CASCADE;

DROP TABLE IF EXISTS Trip CASCADE;
DROP TABLE IF EXISTS ReferenceOfTrip CASCADE;
DROP TABLE IF EXISTS TripLang CASCADE; 
DROP TABLE IF EXISTS TripSeason CASCADE; 
DROP TABLE IF EXISTS TripRegion CASCADE; 
DROP TABLE IF EXISTS TripTheme CASCADE;
DROP TABLE IF EXISTS TripCost CASCADE;
DROP TABLE IF EXISTS TripCostLang CASCADE;
DROP TABLE IF EXISTS TripDay CASCADE;
DROP TABLE IF EXISTS TripDayLang CASCADE;
DROP TABLE IF EXISTS TripDayHotel CASCADE;
DROP TABLE IF EXISTS TripDayTransport CASCADE;
DROP TABLE IF EXISTS TripDayTransportLang CASCADE;
DROP TABLE IF EXISTS TripInclusions CASCADE;
DROP TABLE IF EXISTS TripInclusionsLang CASCADE;
DROP TABLE IF EXISTS TripPictures CASCADE;
DROP TABLE IF EXISTS TripPreferences CASCADE;
DROP TABLE IF EXISTS TripPreferencesLang CASCADE;
DROP TABLE IF EXISTS TagType CASCADE;
DROP TABLE IF EXISTS TagsofPage CASCADE;
DROP TABLE IF EXISTS TagsofTrip CASCADE;

DROP TABLE IF EXISTS MessageDisplay CASCADE;
DROP TABLE IF EXISTS MessageDisplayLang CASCADE;

DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS CustomerPreferences CASCADE;
DROP TABLE IF EXISTS CustomerTrip CASCADE;

DROP TABLE IF EXISTS PaymentHandler CASCADE;
DROP TABLE IF EXISTS Cart CASCADE;
DROP TABLE IF EXISTS ItemOfCart CASCADE;
DROP TABLE IF EXISTS CartOrdered CASCADE;
DROP TABLE IF EXISTS ItemOfOrder CASCADE;

CREATE TABLE Roles
(
        role            CHAR(8) PRIMARY KEY,
        description     text
);

CREATE TABLE Privilege
(
        privilege       text    PRIMARY KEY,
        description     text
);

CREATE TABLE Access
(
        role            CHAR(8) references 
		Roles ON DELETE CASCADE ON UPDATE CASCADE,
        privilege       text references 
		Privilege  ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (role, privilege)
);

CREATE TABLE AppUser
(
        userid          text    PRIMARY KEY,
        name            text,
        details         text,
        password        text,
        date_joined     date,
        active          smallint,
        role            CHAR(8) references 
		Roles(role) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserEmail
(
        userid          text references 
		AppUser ON DELETE CASCADE ON UPDATE CASCADE,
        email           text NOT NULL,
	datecreated	date,
        PRIMARY KEY(userid, email)
);


CREATE TABLE LanguageType
(
        code            CHAR(4) PRIMARY KEY,
        description     text,
	path_of_icon	text,
	path_of_picture	text
);

CREATE TABLE PageStatic
(
	pageid		char(20) PRIMARY KEY,
	pagename	char(24),
	content		text
);

CREATE TABLE PageStaticLang
(
	pageid		char(20) references 
		PageStatic  ON DELETE CASCADE ON UPDATE CASCADE,
	languagetype	CHAR(4) references
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	content		text,
	PRIMARY KEY(pageid,languagetype)				
);


CREATE TABLE Currency
(
	CurrencyCode		char(3) PRIMARY KEY,
	CurrencyName		text,
	Symbol			char(10),
	RoundingFactor		smallint
);

--
--Country, State, City
--

CREATE TABLE Country
(
        CountryCode             char(2) PRIMARY KEY ,
        CountryName             text
) ;



CREATE TABLE State
(
        State_Country           char(2) references 
		Country ON DELETE CASCADE ON UPDATE CASCADE,
        StateCode               char(2),
        StateName               text,
        PRIMARY KEY( State_Country, StateCode )
) ;



CREATE TABLE City
(
        City_Country            char(2),
        City_State              char(2),
        CityCode	        char(20),
        CityName                text,
	Latitude		text,
	Longitude		text,
	FOREIGN KEY( City_country,City_state) references
		State ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY( City_Country, City_State, CityCode )
);

--Description of a City/Town in a specified Language
CREATE TABLE CityLang
(
        City_Country            char(2),
        City_State              char(2), 
        CityCode                char(20), 
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	CityName		text,
	FOREIGN KEY( City_country,City_state,CityCode) references
		City ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY( City_Country, City_State, CityCode,LanguageType )
		
);

-- Transport and Hotel Defined.

CREATE TABLE Transport
(
	TransportCode	CHAR(10) PRIMARY KEY,
	path_of_icon		text,
	path_of_picture		text,
	description	text	--Description in English(default)
);

CREATE TABLE TransportLang
(
	TransportCode	CHAR(10),
	languagetype	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,	--Description in a specified Language 
	PRIMARY KEY(TransportCode,languagetype)
);


-- Application Part


--Theme (Acitivity OR Category)
CREATE TABLE Theme
(
	themeid		CHAR(10) PRIMARY KEY,
	description	text,
	path_of_icon	text,
	path_of_picture	text,
	priority	smallint	
);

CREATE TABLE ThemeLang
(
	ThemeId		char(10) references 
		Theme ON DELETE CASCADE ON UPDATE CASCADE,
	languagetype	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,
	PRIMARY KEY(themeid, languagetype)
);


--Wifi,SwimmingPool etc.
--
CREATE TABLE HotelFacilityTypes
(
	facilitytype		smallint PRIMARY KEY,
	path_of_icon		text,
	path_of_picture		text,
	description		text
);



CREATE TABLE Hotel
(
	hotelcode		char(60),
        City_Country            char(2) references 
		Country ON DELETE CASCADE ON UPDATE CASCADE,
        City_State              char(2),
        CityCode                char(20) ,
	address			text,
	pincode			char(20),
	url			text,
	ratingstar		int,		
	validfrom		date,
	validtill		date,
	hotelname		text,

	FOREIGN KEY( City_country,City_state,CityCode) references
		City ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY( City_Country, City_State, CityCode, hotelcode )

);

CREATE TABLE HotelPrice
(
	hotelcode		char(60),
        City_Country            char(2) references 
		Country ON DELETE CASCADE ON UPDATE CASCADE,
        City_State              char(2),
        CityCode                char(20),
	validfrom		date,
	cost			smallint,

	FOREIGN KEY( City_country,City_state,CityCode,
	Hotelcode) references
		Hotel ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY( City_country,City_state,CityCode,
	Hotelcode,validfrom)
	
);

CREATE TABLE HotelLang
(
	hotelcode		char(60),
        City_Country            char(2),
        City_State              char(2),
        CityCode                char(20),

	LanguageType		char(4),
	hotelname		text,
	description		text, -- In multiple languages

	FOREIGN KEY( City_country,City_state,CityCode,Hotelcode) references
		Hotel ON DELETE CASCADE ON UPDATE CASCADE,

        PRIMARY KEY( City_Country, City_State, CityCode, 
		hotelcode,LanguageType )

);

-- Hotel can have multiple pictures
-- These will be stored in the filesystem

CREATE TABLE HotelPictures
(

	hotelcode		char(60),

	picturenumber		SERIAL,		-- picture serial number

	picturepath		text,		-- Path of picture file
	description		text,
	priority		smallint,
	valid			smallint,

        City_Country            char(2),
        City_State              char(2),
        CityCode                char(20),

	FOREIGN KEY( City_country,City_state,CityCode,Hotelcode) references
		Hotel ON DELETE CASCADE ON UPDATE CASCADE,

        PRIMARY KEY( City_Country, City_State, CityCode, 
		hotelcode,picturenumber )
	
);

CREATE TABLE HotelFacility
(
	hotelcode		char(60),
	FacilityType	smallint references 
		HotelFacilityTypes ON DELETE CASCADE ON UPDATE CASCADE,

        City_Country            char(2),
        City_State              char(2),
        CityCode                char(20),

	FOREIGN KEY( City_country,City_state,CityCode,Hotelcode) references
		Hotel ON DELETE CASCADE ON UPDATE CASCADE,

        PRIMARY KEY( hotelcode,FacilityType )

);

--
-- Regions and Seasons
--

CREATE TABLE Region
(
	RegionCode	CHAR(10) PRIMARY KEY,
	priority	smallint,
	path_of_icon		text,
	path_of_picture		text,
	description	text	--Description in English(default)
);

CREATE TABLE RegionLang
(
	RegionCode	CHAR(10) references 
		Region ON DELETE CASCADE ON UPDATE CASCADE,
	languagetype	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,	--Description in a specified Language 

	PRIMARY KEY(RegionCode,languagetype)
);

CREATE TABLE Season
(
	SeasonCode	CHAR(10) PRIMARY KEY,
	priority	smallint,
	path_of_icon		text,
	path_of_picture		text,
	Description	text,
	DescSeasonStart	text,	--User can fill in a details
	DescSeasonEnd	text	--User can fill in a details
);

CREATE TABLE SeasonLang
(
	SeasonCode	CHAR(10) references 
		Season ON DELETE CASCADE ON UPDATE CASCADE,
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	Description	text,
	DescSeasonStart	text,	-- In selected language
	DescSeasonEnd	text,	--User can fill in a details

	PRIMARY KEY ( SeasonCode, LanguageType)
);


--
-- Itinerary , Day, Hotel
-- Trip is an Itinerary.
--
CREATE TABLE Trip
(
	tripid		char(60) PRIMARY KEY,
	tripname	text,
	description	text,
	pathofmappicture	text,	-- Filesystem path for the map picture

	valid		smallint,		
	validtilldate	date,
	bookingfrom	date,
	bookingtill	date
);

CREATE TABLE TripLang
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	tripname	text,
	Description	text,
	PRIMARY KEY(TripID,LanguageType)
	
);


--Trip References
CREATE TABLE ReferenceOfTrip
(
	referenceid  	char(90),
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(tripid,referenceid)			
	
);

--A Trip can be in multiple season
CREATE TABLE TripSeason
(

	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	seasoncode	char(10) references
			Season ON DELETE CASCADE ON UPDATE CASCADE,
	description	text, -- Why this is the preferred season.

	PRIMARY KEY(tripid,seasoncode)		
			
);

--A Trip can be in multiple season
CREATE TABLE TripRegion
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	regioncode	char(10) references
			Region ON DELETE CASCADE ON UPDATE CASCADE,
	description	text, 

	PRIMARY KEY(tripid,regioncode)		
			
);


CREATE TABLE TripTheme
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	ThemeId		CHAR(10) references 
		Theme ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(TripID,ThemeID)	
);

CREATE TABLE TripCost
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	costoption	smallint NOT NULL, -- CostOption (int of cost etc)
	cost		decimal(8,2), 	   -- Price of a Option
	valid		smallint,		
	validfromdate	date,
	validtilldate	date,
	description	text,
	currencycode	char(3) references
		Currency ON DELETE CASCADE ON UPDATE CASCADE,
	
	PRIMARY KEY (tripid,costoption)
);

CREATE TABLE TripCostLang
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	costoption	smallint NOT NULL,  -- CostOption (int of cost etc)
	LanguageType	char(4) references
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,
	PRIMARY KEY (tripid,costoption,LanguageType)
);


--
--All TripDay* tables are connected to TripCost
--
CREATE TABLE TripDay
(
	tripid		char(60),
	daynumber	smallint    	NOT NULL,	
			--Day number ofTrip, serial(1,2,3 etc)
	titleofday	text, 	     -- Title of the Trip Day		
	description	text,		-- In English
	travelinfo	text,		-- In English
	visitingplaces	text,		-- In English
	options		text,		-- In English

        City_Country            char(2),
        City_State              char(2), 
        CityCode                char(20), 

	FOREIGN KEY( City_country,City_state,CityCode) references
		City ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY (tripid,daynumber),

	FOREIGN KEY (tripid) references 
		Trip ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE TripDayLang
(
	tripid		char(60),
	daynumber	smallint    	NOT NULL,	
	titleofday	text, -- Title of the Trip Day		

			--Day number ofTrip, serial(1,2,3 etc)

	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,

	Description	text,
	travelinfo	text,
	visitingplaces	text,		-- In Other Languages
	options		text,		

	PRIMARY KEY(TripID,daynumber,LanguageType),

	FOREIGN KEY (tripid,daynumber) references 
		TripDay ON DELETE CASCADE ON UPDATE CASCADE

);

-- this table is quite complicated.
-- 
CREATE TABLE TripDayHotel
(
	tripid			char(60),
	daynumber		smallint NOT NULL,	-- Day number of Trip
	costoption		smallint NOT NULL,

        City_Country            char(2),
        City_State              char(2),
        CityCode                char(20),
	hotelcode		char(60),

	FOREIGN KEY (tripid,daynumber) references 
		TripDay ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (tripid,costoption) references 
		TripCost ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY( City_country,City_state,CityCode,hotelcode) references
		Hotel ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY(TripID,daynumber,costoption)


);

CREATE TABLE TripDayTransport
(
	tripid		char(60),
	daynumber	smallint NOT NULL,	-- Day number of Trip

	TransportCode	char(10) references
		Transport ON DELETE CASCADE ON UPDATE CASCADE,

	description	text,

	source		text,
	destination	text,

	PRIMARY KEY(TripID,daynumber,TransportCode ),

	FOREIGN KEY (tripid,daynumber) references 
		TripDay ON DELETE CASCADE ON UPDATE CASCADE


);

CREATE TABLE TripDayTransportLang
(

	tripid		char(60),
	daynumber	smallint NOT NULL,	-- Day number of Trip

	TransportCode	char(10) references
		Transport ON DELETE CASCADE ON UPDATE CASCADE,
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,	-- In Multiple Language

	source		text,
	destination	text,

	PRIMARY KEY(TripID,daynumber, TransportCode,LanguageType ),

	FOREIGN KEY (tripid,daynumber,TransportCode) references 
		TripDayTransport ON DELETE CASCADE ON UPDATE CASCADE

);


-- All of the following Trip* tables are connected to Trip Table

CREATE TABLE TripInclusions
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	serialnumber	smallint NOT NULL,	--Serial Number of Inclusion
	description	text,
	PRIMARY KEY(tripid,serialnumber)	
);

CREATE TABLE TripInclusionsLang
(
	tripid		char(60),

	serialnumber	integer NOT NULL,	--Serial Number of Inclusion
	languagetype	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,
	PRIMARY KEY(tripid,serialnumber,languagetype ),

	FOREIGN KEY(tripid,serialnumber) references
		TripInclusions ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TripPictures
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	picturenumber		smallint NOT NULL,
		  	 --picture serial number
	picturepath		text,		 --Path of picture file
	description		text,
	priority		smallint,
	valid			smallint,
        PRIMARY KEY( tripid,picturenumber )
	
);

CREATE TABLE TripPreferences
(
	tripid		char(60) references
		Trip ON DELETE CASCADE ON UPDATE CASCADE,
	serialnumber	smallint NOT NULL,	--Serial Number of Inclusion
	description	text,

	PRIMARY KEY(tripid,serialnumber)	

);

CREATE TABLE TripPreferencesLang
(
	tripid		char(60),
	serialnumber	smallint NOT NULL,	--Serial Number of Inclusion
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	description	text,

	PRIMARY KEY(tripid,serialnumber,LanguageType),

	FOREIGN KEY(tripid,serialnumber) references
		TripPreferences ON DELETE CASCADE ON UPDATE CASCADE

);


CREATE TABLE TagType
(
	TagType		CHAR(24) PRIMARY KEY,
	description	text
);

CREATE TABLE TagsOfTrip
(
	TagType		CHAR(24) NOT NULL references
		TagType ON DELETE CASCADE ON UPDATE CASCADE,
	TripID		char(60) NOT NULL,
	priority	smallint,

	TripDayNumber	smallint,
	details		text,
	
	PRIMARY KEY(TagType,TripID,priority)
);

CREATE TABLE TagsOfPage
(
	TagType		CHAR(24) NOT NULL references
		TagType ON DELETE CASCADE ON UPDATE CASCADE,
	pageid		char(20) NOT NULL references 
		PageStatic  ON DELETE CASCADE ON UPDATE CASCADE,
	priority	smallint,

	details		text,
	
	PRIMARY KEY(TagType,PageID,Priority)
);


--
-- This is for displaying the texts on the pages.
--
CREATE TABLE MessageDisplay
(
	MessageID	SERIAL PRIMARY KEY,
	pageid		char(20) references 
		PageStatic  ON DELETE CASCADE ON UPDATE CASCADE,
	valuestr	text,
	valuenumber	SMALLINT,
	msgcomment	text,
	detail		text
);


CREATE TABLE MessageDisplayLang
(
	MessageID	SERIAL PRIMARY KEY,
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,
	detail		text
);


--
--Customer
CREATE TABLE Customer
(
	customerid	SERIAL PRIMARY KEY,
	name		text,
        userid          text UNIQUE references 
		AppUser ON DELETE CASCADE ON UPDATE CASCADE,
	address		text,	
	city		text,
	state		text,
	country		text,
	phone		text,
	mobile		text,
	email		text
);

CREATE TABLE CustomerPreferences
(
	CustomerID	int references
		Customer ON DELETE CASCADE ON UPDATE CASCADE,
	LanguageType	char(4) references 
		LanguageType ON DELETE CASCADE ON UPDATE CASCADE,

	SendAlerts      char(1) check (SendAlerts in ('Y', 'N')),
  	SendInfo        char(1) check (SendInfo in ('Y', 'N')),
  	SendLetter      char(1) check (SendLetter in ('Y', 'N')),
  	Visible         char(1) check (Visible in ('Y', 'N')),

	PRIMARY KEY(CustomerID)
);

CREATE TABLE CustomerTrip
(
	customerid		int references
		Customer ON DELETE CASCADE ON UPDATE CASCADE,
	tripid			char(60),

	arrivaldate		date,
	departuredate		date,
	NumberOfAdults		smallint,
	NumberOfInfants		smallint,
	NumberOfChildren	smallint,

	PRIMARY KEY(customerid,tripid)
);


--
--Payment Processor: EBS, CCA
--
CREATE TABLE PaymentHandler
(
	HandlerId	char(6) PRIMARY KEY,	-- App's Processor ID

--	(EBS clients or Merchant ID 4-5 characters)
	account_id 	char(24), 
	merchant_refno 	char(20),
	secretkey      	char(36),
	mode 	     	char(4),
--	(TEST/LIVE)

--	(Web Address to bring back after the payment)
	return_url   	text,
	payment_url    	text
--	(Web Address of the Payment Handler)

);

--Cart
CREATE TABLE cart (
        cartid			SERIAL PRIMARY KEY,
	shopper 	       	int references Customer 	
		ON DELETE CASCADE ON UPDATE CASCADE,
        type			smallint,
        name			char(10) default NULL,

        description 		text,

	Billing_Name		char(128),	 
	Billing_Address		char(255),		 
	Billing_City		char(32),
	Billing_State		char(32),
	Billing_PostalCode	char(10),
	Billing_Country		char(3),	
	Billing_Phone		char(20),
	Billing_Email		char(100)

); 

CREATE TABLE ItemOfCart (
        cartid 		smallint references Cart
			ON DELETE CASCADE ON UPDATE CASCADE,
        itemid 		char(60) references Trip
			ON DELETE CASCADE ON UPDATE CASCADE,
        quantity 	smallint NOT NULL default '1',
        price 		decimal(9,2) NOT NULL default '0.00',
        description 	text default NULL,

        PRIMARY KEY (cartid,itemid)
);

CREATE TABLE CartOrdered (
        orderid			smallint 
		references Cart
		ON DELETE CASCADE ON UPDATE CASCADE ,

	shopper 	       	int references Customer 	
		ON DELETE CASCADE ON UPDATE CASCADE,

	description		text,
	totalprice		decimal(9,2) NOT NULL default '0.00',	

	Billing_Name		text,
	Billing_Address		text,
	Billing_City		char(32),
	Billing_State		char(32),
	Billing_PostalCode	char(10),
	Billing_Country		char(3),	
	Billing_Phone		char(20),
	Billing_Email		text,

	Ship_Name		text,
	Ship_Address		text,
	Ship_City		char(32),
	Ship_State		char(32),
	Ship_PostalCode		char(10),
	Ship_Country		char(3),	
	Ship_Phone		char(20),
	Ship_Email		text,

	HandlerID		char(6)
		references PaymentHandler	
		ON DELETE CASCADE ON UPDATE CASCADE,
	ResponseCode	  	smallint, 
		-- 0 is successfule txn, else failed txn
	ResponseMessage		text,
	DateCreated		date,
	PaymentID		char(20),
	MerchantRefNo		char(20),
	amount			decimal(9,2) NOT NULL default '0.00',
	mode			char(4),
	isFlagged		char(3), -- Yes or No	

	PRIMARY KEY(orderid)

);


CREATE TABLE ItemOfOrder (
        orderid 	 smallint 
		references CartOrdered
		ON DELETE CASCADE ON UPDATE CASCADE,
	itemid		 char(60) 
		references Trip
		ON DELETE CASCADE ON UPDATE CASCADE,
        quantity   	  smallint NOT NULL default '1',
        price 		  decimal(9,2) NOT NULL default '0.00',
        description 	  varchar(255) default NULL,
        total 		  decimal(9,2) NOT NULL default '0.00',

        PRIMARY KEY (orderid,itemid)
);



--
--

create view v_trip AS  select t.tripid ,t.tripname,
(SELECT max(tc.cost) from tripcost tc where tc.valid=1 AND t.tripid=tc.tripid) 
as max_trip_cost, --MAX COST OF the Trip
(SELECT min(tc.cost) from tripcost tc where tc.valid=1 AND t.tripid=tc.tripid) 
as min_trip_cost, -- MIN COST OF the Trip
(SELECT array_agg(tr.regioncode) from tripregion tr where t.tripid=tr.tripid        ) as all_trip_regions, -- All the Regions of the trip
(SELECT array_agg(ts.seasoncode) from tripseason ts where t.tripid=ts.tripid ) as all_trip_seasons,     --All the Seasons of the trip
(SELECT array_agg(tt.themeid) from triptheme tt where t.tripid=tt.tripid) as all_trip_theme -- All the themes of the trip
from trip t  where t.valid=1 ;


--INSERT INTO Roles Values ('ADMIN' , 'Software Administrator');
--INSERT INTO Roles Values ('AUTHOR' , 'Data Author');
--INSERT INTO Roles Values ('GUEST' , 'Not Logged In');
--INSERT INTO Roles Values ('CLIENT' , 'Client');

--INSERT INTO Privilege Values ('/', 'Home Page');
--INSERT INTO Privilege Values ('/login/index', 'Login');
--INSERT INTO Privilege Values ('/logout/index', 'Logout');

----Admin must have all the access
--INSERT INTO Access Values ('ADMIN'  ,   '/');
--INSERT INTO Access Values ('ADMIN'  ,   '/logout/index');
--INSERT INTO Access Values ('GUEST' ,    '/');

--INSERT INTO APPUSER VALUES( 'UNKN','Unknown','DETAILS UNKNOWN',
--        'PWD','2013-01-01','1','GUEST');
--INSERT INTO APPUSER VALUES( 'tirveni','Application Admin',
--       'Handle Administration', 'tirveni','2013-01-01','1','ADMIN');

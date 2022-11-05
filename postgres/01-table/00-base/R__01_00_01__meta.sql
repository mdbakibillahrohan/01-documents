/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
valueJson                      : 
despcription                   : 
*/
create table                   MetaProperty
(
oid                            varchar(128)                                                not null,
valueJson                      text                                                        not null,
despcription                   varchar(128),
constraint                     pk_MetaProperty                                             primary key    (oid)
);

/*

oid                            : Surrogate primary key
yearEn                         : 
yearBn                         : 
nameEn                         : 
nameBn                         : 
serialNo                       : 
sortOrder                      : 
*/
create table                   Calendar
(
oid                            varchar(128)                                                not null,
yearEn                         numeric(4,0)                                                not null,
yearBn                         varchar(64)                                                 not null,
nameEn                         varchar(64)                                                 not null,
nameBn                         varchar(64)                                                 not null,
serialNo                       numeric(5,0)                                                not null,
sortOrder                      numeric(5,0)                                                not null,
constraint                     pk_Calendar                                                 primary key    (oid)
);

/*

oid                            : Surrogate primary key
yearValue                      : 
quarterValue                   : 
monthValue                     : 
weekOfMonthValue               : 
weekOfYearValue                : 
dayValue                       : 
dayOfYearValue                 : 
dayOfWeekValue                 : 
quarterString                  : 
monthString                    : 
dayString                      : 
*/
create table                   CalendarDetail
(
oid                            varchar(128)                                                not null,
yearValue                      numeric(4,0)                                                not null,
quarterValue                   numeric(1,0)                                                not null,
monthValue                     numeric(2,0)                                                not null,
weekOfMonthValue               numeric(1,0)                                                not null,
weekOfYearValue                numeric(2,0)                                                not null,
dayValue                       numeric(2,0)                                                not null,
dayOfYearValue                 numeric(3,0)                                                not null,
dayOfWeekValue                 numeric(1,0)                                                not null,
quarterString                  varchar(2)                                                  not null,
monthString                    varchar(10)                                                 not null,
dayString                      varchar(10)                                                 not null,
constraint                     pk_CalendarDetail                                           primary key    (oid)
);

/*
List of all division of Bangladesh
oid                            : Surrogate primary key
divisionCode                   : 
nameEn                         : 
nameBn                         : 
*/
create table                   Division
(
oid                            varchar(128)                                                not null,
divisionCode                   varchar(32)                                                 not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
constraint                     pk_Division                                                 primary key    (oid),
constraint                     uk_divisionCode_Division                                    unique         (divisionCode),
constraint                     uk_nameEn_Division                                          unique         (nameEn)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
districtCode                   : 
nameEn                         : 
nameBn                         : 
divisionOid                    : 
*/
create table                   District
(
oid                            varchar(128)                                                not null,
districtCode                   varchar(32)                                                 not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
divisionOid                    varchar(128)                                                not null,
constraint                     pk_District                                                 primary key    (oid),
constraint                     uk_districtCode_District                                    unique         (districtCode),
constraint                     uk_nameEn_District                                          unique         (nameEn),
constraint                     fk_divisionOid_District                                     foreign key    (divisionOid)
                                                                                           references     Division(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
thanaCode                      : 
nameEn                         : 
nameBn                         : 
districtOid                    : 
*/
create table                   Thana
(
oid                            varchar(128)                                                not null,
thanaCode                      varchar(32)                                                 not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
districtOid                    varchar(64)                                                 not null,
constraint                     pk_Thana                                                    primary key    (oid),
constraint                     uk_thanaCode_Thana                                          unique         (thanaCode),
constraint                     fk_districtOid_Thana                                        foreign key    (districtOid)
                                                                                           references     District(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
postCode                       : 
nameEn                         : 
nameBn                         : 
thanaOid                       : 
*/
create table                   PostOffice
(
oid                            varchar(128)                                                not null,
postCode                       varchar(32)                                                 not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
thanaOid                       varchar(64)                                                 not null,
constraint                     pk_PostOffice                                               primary key    (oid),
constraint                     uk_postCode_PostOffice                                      unique         (postCode),
constraint                     fk_thanaOid_PostOffice                                      foreign key    (thanaOid)
                                                                                           references     Thana(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
nameEn                         : 
nameBn                         : 
*/
create table                   Bank
(
oid                            varchar(128)                                                not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
constraint                     pk_Bank                                                     primary key    (oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
capital                        : 
isoCodeAlphaTwo                : 
isoCodeAlphaThree              : 
countryCode                    : 
dialingCode                    : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
*/
create table                   Country
(
oid                            varchar(128)                                                not null,
name                           text                                                        not null,
capital                        varchar(128),
isoCodeAlphaTwo                varchar(16),
isoCodeAlphaThree              varchar(16),
countryCode                    varchar(32),
dialingCode                    varchar(32),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_Country                                                  primary key    (oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
packageJson                    : 
description                    : 
price                          : 
period                         : 
type                           : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
*/
create table                   Package
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
packageJson                    text,
description                    varchar(128),
price                          varchar(32),
period                         varchar(32),
type                           varchar(32)                                                                default 'Default',
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_Package                                                  primary key    (oid),
constraint                     ck_type_Package                                             check          (type = 'Default' or type = 'Custom')
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
mnemonic                       : 
status                         : 
businessType                   : 
address                        : 
website                        : 
telephone                      : 
contactNo                      : 
hotlineNumber                  : 
logoPath                       : 
emailId                        : 
emailPassword                  : 
bankAccountTitle               : 
bankAccountNo                  : 
branchNameEn                   : 
branchAddress                  : 
salaryJson                     : 
bankOid                        : 
packageOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
*/
create table                   Company
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
mnemonic                       varchar(32)                                                 not null,
status                         varchar(32)                                                 not null       default 'Active',
businessType                   varchar(128),
address                        text,
website                        varchar(128),
telephone                      varchar(128),
contactNo                      varchar(128),
hotlineNumber                  varchar(64),
logoPath                       varchar(64)                                                                default 'companylogo/default_logo.png',
emailId                        varchar(64),
emailPassword                  varchar(64),
bankAccountTitle               varchar(128),
bankAccountNo                  varchar(128),
branchNameEn                   varchar(128),
branchAddress                  text,
salaryJson                     text,
bankOid                        varchar(128),
packageOid                     varchar(128),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_Company                                                  primary key    (oid),
constraint                     ck_status_Company                                           check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_bankOid_Company                                          foreign key    (bankOid)
                                                                                           references     Bank(oid),
constraint                     fk_packageOid_Company                                       foreign key    (packageOid)
                                                                                           references     Package(oid)
);

/*
Table
oid                            : Surrogate primary key
name                           : 
ledgerType                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
companyOid                     : 
*/
create table                   Ledger
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
ledgerType                     varchar(32),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Ledger                                                   primary key    (oid),
constraint                     fk_companyOid_Ledger                                        foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
airportId                      : 
airportName                    : 
city                           : 
country                        : 
iata                           : 
icao                           : 
latitude                       : 
longitude                      : 
altitude                       : 
timezoneInHour                 : 
dst                            : 
timezone                       : 
status                         : 
createdOn                      : When was created
createdBy                      : Who was created
*/
create table                   Airport
(
oid                            varchar(64)                                                 not null,
airportId                      varchar(64)                                                 not null,
airportName                    varchar(128)                                                not null,
city                           varchar(64),
country                        varchar(64),
iata                           varchar(32),
icao                           varchar(32),
latitude                       numeric(18,12),
longitude                      numeric(18,12),
altitude                       varchar(32),
timezoneInHour                 numeric(5,3),
dst                            varchar(32),
timezone                       varchar(32),
status                         varchar(32)                                                 not null       default 'Active',
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
constraint                     pk_Airport                                                  primary key    (oid),
constraint                     ck_status_Airport                                           check          (status = 'Active' or status = 'Inactive')
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
airlineId                      : 
airlineName                    : 
aliasName                      : 
country                        : 
iata                           : 
icao                           : 
callsign                       : 
logoPath                       : 
companyOid                     : 
status                         : 
createdOn                      : When was created
createdBy                      : Who was created
*/
create table                   Airline
(
oid                            varchar(64)                                                 not null,
airlineId                      varchar(64)                                                 not null,
airlineName                    varchar(128)                                                not null,
aliasName                      varchar(64),
country                        varchar(64),
iata                           varchar(32),
icao                           varchar(32),
callsign                       varchar(64),
logoPath                       text,
companyOid                     varchar(128),
status                         varchar(32)                                                 not null       default 'Active',
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
constraint                     pk_Airline                                                  primary key    (oid),
constraint                     fk_companyOid_Airline                                       foreign key    (companyOid)
                                                                                           references     Company(oid),
constraint                     ck_status_Airline                                           check          (status = 'Active' or status = 'Inactive')
);

/*
Table
oid                            : Surrogate primary key
name                           : 
accountNumber                  : 
accountType                    : 
initialBalance                 : 
status                         : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
companyOid                     : 
*/
create table                   Account
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
accountNumber                  varchar(64),
accountType                    varchar(32)                                                 not null       default 'Bank',
initialBalance                 numeric(20,2)                                                              default 0,
status                         varchar(32)                                                 not null       default 'Active',
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Account                                                  primary key    (oid),
constraint                     ck_accountType_Account                                      check          (accountType = 'Cash' or accountType = 'Bank'),
constraint                     ck_status_Account                                           check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_companyOid_Account                                       foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
name                           : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
companyOid                     : 
*/
create table                   Category
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Category                                                 primary key    (oid),
constraint                     fk_companyOid_Category                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
name                           : 
unit                           : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
categoryOid                    : 
companyOid                     : 
*/
create table                   Product
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
unit                           varchar(128),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
categoryOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Product                                                  primary key    (oid),
constraint                     fk_categoryOid_Product                                      foreign key    (categoryOid)
                                                                                           references     Category(oid),
constraint                     fk_companyOid_Product                                       foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
nameEn                         : 
nameBn                         : 
status                         : 
sortOrder                      : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   Department
(
oid                            varchar(128)                                                not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
status                         varchar(32)                                                 not null       default 'Active',
sortOrder                      numeric(5,0),
companyOid                     varchar(128),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_Department                                               primary key    (oid),
constraint                     ck_status_Department                                        check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_companyOid_Department                                    foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
nameEn                         : 
nameBn                         : 
status                         : 
sortOrder                      : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   Designation
(
oid                            varchar(128)                                                not null,
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
status                         varchar(32)                                                 not null       default 'Active',
sortOrder                      numeric(5,0),
companyOid                     varchar(128),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_Designation                                              primary key    (oid),
constraint                     ck_status_Designation                                       check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_companyOid_Designation                                   foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
employeeId                     : 
nameEn                         : 
nameBn                         : 
mobileNo                       : 
companyMobileNo                : 
email                          : 
imagePath                      : 
nid                            : 
passportNo                     : 
dateOfBirth                    : 
joiningDate                    : 
gender                         : 
maritalStatus                  : 
bloodGroup                     : 
permanentAddress               : 
presentAddress                 : 
employeeType                   : 
status                         : 
grossSalary                    : 
mobileLimit                    : 
tax                            : 
bankAccountTitle               : 
bankAccountNo                  : 
bankOid                        : 
departmentOid                  : 
designationOid                 : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   Employee
(
oid                            varchar(128)                                                not null,
employeeId                     varchar(64),
nameEn                         varchar(128)                                                not null,
nameBn                         varchar(128),
mobileNo                       varchar(64),
companyMobileNo                text                                                                       default '[]',
email                          varchar(128),
imagePath                      text,
nid                            varchar(32),
passportNo                     varchar(32),
dateOfBirth                    date,
joiningDate                    date,
gender                         varchar(32),
maritalStatus                  varchar(32),
bloodGroup                     varchar(16),
permanentAddress               text,
presentAddress                 text,
employeeType                   varchar(32),
status                         varchar(32)                                                 not null       default 'Active',
grossSalary                    numeric(12,2)                                                              default 0,
mobileLimit                    numeric(12,2)                                                              default 0,
tax                            numeric(12,2)                                                              default 0,
bankAccountTitle               varchar(128),
bankAccountNo                  varchar(128),
bankOid                        varchar(128),
departmentOid                  varchar(128),
designationOid                 varchar(128),
companyOid                     varchar(128),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_Employee                                                 primary key    (oid),
constraint                     ck_status_Employee                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_bankOid_Employee                                         foreign key    (bankOid)
                                                                                           references     Bank(oid),
constraint                     fk_departmentOid_Employee                                   foreign key    (departmentOid)
                                                                                           references     Department(oid),
constraint                     fk_designationOid_Employee                                  foreign key    (designationOid)
                                                                                           references     Designation(oid),
constraint                     fk_companyOid_Employee                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
customerId                     : 
name                           : 
address                        : 
mobileNo                       : 
email                          : 
supplierType                   : 
initialBalance                 : 
commissionType                 : 
commissionValue                : 
serviceCharge                  : 
imagePath                      : 
status                         : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
companyOid                     : 
*/
create table                   Supplier
(
oid                            varchar(128)                                                not null,
customerId                     varchar(128),
name                           varchar(128),
address                        text,
mobileNo                       varchar(128),
email                          varchar(128),
supplierType                   varchar(64)                                                                default 'Vendor',
initialBalance                 numeric(20,2)                                                              default 0,
commissionType                 varchar(8),
commissionValue                numeric(20,2)                                                              default 0,
serviceCharge                  numeric(20,2)                                                              default 0,
imagePath                      varchar(256),
status                         varchar(32)                                                 not null       default 'Active',
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Supplier                                                 primary key    (oid),
constraint                     ck_supplierType_Supplier                                    check          (supplierType = 'Vendor' or supplierType = 'Airlines'),
constraint                     ck_commissionType_Supplier                                  check          (commissionType = 'Pct' or commissionType = 'Fixed'),
constraint                     ck_status_Supplier                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_companyOid_Supplier                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
serviceType                    : 
toEmailAddrees                 : 
toCCEmailAddrees               : 
contactNo                      : 
remarks                        : 
sortOrder                      : 
supplierOid                    : 
companyOid                     : 
*/
create table                   SupplierEmailService
(
oid                            varchar(128)                                                not null,
serviceType                    varchar(128),
toEmailAddrees                 varchar(128),
toCCEmailAddrees               text,
contactNo                      varchar(128),
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
supplierOid                    varchar(128),
companyOid                     varchar(128)                                                not null,
constraint                     pk_SupplierEmailService                                     primary key    (oid),
constraint                     fk_supplierOid_SupplierEmailService                         foreign key    (supplierOid)
                                                                                           references     Supplier(oid),
constraint                     fk_companyOid_SupplierEmailService                          foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
customerId                     : 
name                           : 
address                        : 
mobileNo                       : 
email                          : 
initialBalance                 : 
discountType                   : 
discountValue                  : 
imagePath                      : 
status                         : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
companyOid                     : 
*/
create table                   Customer
(
oid                            varchar(128)                                                not null,
customerId                     varchar(128),
name                           varchar(128),
address                        text,
mobileNo                       varchar(128),
email                          varchar(128),
initialBalance                 numeric(20,2)                                                              default 0,
discountType                   varchar(8),
discountValue                  numeric(20,2)                                                              default 0,
imagePath                      varchar(256),
status                         varchar(32)                                                 not null       default 'Active',
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Customer                                                 primary key    (oid),
constraint                     ck_discountType_Customer                                    check          (discountType = 'Pct' or discountType = 'Fixed'),
constraint                     ck_status_Customer                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_companyOid_Customer                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
passengerId                    : 
fullName                       : 
surName                        : 
givenName                      : 
gender                         : 
mobileNo                       : 
email                          : 
nationality                    : 
countryCode                    : 
birthRegistrationNo            : 
personalNo                     : 
passportNumber                 : 
previousPassportNumber         : 
birthDate                      : 
passportIssueDate              : 
passportExpiryDate             : 
passportImagePath              : 
issuingAuthority               : 
description                    : 
status                         : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
countryOid                     : 
customerOid                    : 
companyOid                     : 
*/
create table                   Passport
(
oid                            varchar(128)                                                not null,
passengerId                    varchar(32),
fullName                       varchar(128),
surName                        varchar(128),
givenName                      varchar(128),
gender                         varchar(16),
mobileNo                       varchar(128),
email                          varchar(128),
nationality                    varchar(128),
countryCode                    varchar(32),
birthRegistrationNo            varchar(32),
personalNo                     varchar(32),
passportNumber                 varchar(32),
previousPassportNumber         varchar(32),
birthDate                      date,
passportIssueDate              date,
passportExpiryDate             date,
passportImagePath              text                                                                       default '[]',
issuingAuthority               varchar(128),
description                    text,
status                         varchar(32)                                                                default 'Active',
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
countryOid                     varchar(128),
customerOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Passport                                                 primary key    (oid),
constraint                     ck_status_Passport                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_countryOid_Passport                                      foreign key    (countryOid)
                                                                                           references     Country(oid),
constraint                     fk_customerOid_Passport                                     foreign key    (customerOid)
                                                                                           references     Customer(oid),
constraint                     fk_companyOid_Passport                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
title                          : 
imagePath                      : 
remarks                        : 
sortOrder                      : 
passportOid                    : 
companyOid                     : 
*/
create table                   PassportDetail
(
oid                            varchar(128)                                                not null,
title                          varchar(128),
imagePath                      varchar(256),
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassportDetail                                           primary key    (oid),
constraint                     fk_passportOid_PassportDetail                               foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassportDetail                                foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
visaNumber                     : 
visaType                       : 
visaIssueDate                  : 
visaExpiryDate                 : 
country                        : 
imagePath                      : 
remarks                        : 
status                         : 
sortOrder                      : 
passportOid                    : 
companyOid                     : 
*/
create table                   PassportVisaInformation
(
oid                            varchar(128)                                                not null,
visaNumber                     varchar(128),
visaType                       varchar(128),
visaIssueDate                  date,
visaExpiryDate                 date,
country                        varchar(128),
imagePath                      varchar(256),
remarks                        text,
status                         varchar(32)                                                 not null       default 'Active',
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassportVisaInformation                                  primary key    (oid),
constraint                     ck_status_PassportVisaInformation                           check          (status = 'Inactive' or status = 'Active'),
constraint                     fk_passportOid_PassportVisaInformation                      foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassportVisaInformation                       foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
title                          : 
command                        : 
remarks                        : 
sortOrder                      : 
passportOid                    : 
companyOid                     : 
*/
create table                   PassportCommand
(
oid                            varchar(128)                                                not null,
title                          varchar(128),
command                        text,
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassportCommand                                          primary key    (oid),
constraint                     fk_passportOid_PassportCommand                              foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassportCommand                               foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Table
oid                            : Surrogate primary key
name                           : 
notificationValue              : 
subscribe                      : 
remarks                        : 
sortOrder                      : 
passportOid                    : 
companyOid                     : 
*/
create table                   PassengerNotification
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
notificationValue              text,
subscribe                      text,
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassengerNotification                                    primary key    (oid),
constraint                     fk_passportOid_PassengerNotification                        foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassengerNotification                         foreign key    (companyOid)
                                                                                           references     Company(oid)
);



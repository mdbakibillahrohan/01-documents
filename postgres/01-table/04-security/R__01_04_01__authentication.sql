/*
Application users
oid                            : Surrogate primary key
loginId                        : Login Id
password                       : Encrypted password
mobileNo                       : User mobile number
name                           : User name
address                        : User address
email                          : Email (if possible to collect)
menuJson                       : Json schema to generate menu
reportJson                     : Json schema to generate report menu
status                         : Status of Login
imagePath                      : 
referenceOid                   : customerOid, supplierOid, employeeOid
referenceType                  : Supplier, Customer, Employee
roleOid                        : Role oid
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
companyOid                     : 
*/
create table                   Login
(
oid                            varchar(128)                                                not null,
loginId                        varchar(128)                                                not null,
password                       varchar(128)                                                not null,
mobileNo                       varchar(64),
name                           varchar(256),
address                        text,
email                          varchar(128),
menuJson                       text                                                        not null       default '[]',
reportJson                     text                                                        not null       default '[]',
status                         varchar(32)                                                 not null,
imagePath                      varchar(256),
referenceOid                   varchar(128),
referenceType                  varchar(32),
roleOid                        varchar(128)                                                not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Login                                                    primary key    (oid),
constraint                     uk_loginId_Login                                            unique         (loginId),
constraint                     ck_status_Login                                             check          (status = 'Active' or status = 'Inactive'),
constraint                     ck_referenceType_Login                                      check          (referenceType = 'Supplier' or referenceType = 'Customer' or referenceType = 'Employee'),
constraint                     fk_roleOid_Login                                            foreign key    (roleOid)
                                                                                           references     Role(oid),
constraint                     fk_companyOid_Login                                         foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Audit log information of Login
oid                            : Surrogate primary key
loginOid                       : Login on which the log is
ipAddress                      : Login on which the log is
loginTime                      : Time of log
logoutTime                     : Type of log, what it was
status                         : JSON schema for log
*/
create table                   LoginLog
(
oid                            varchar(128)                                                not null,
loginOid                       varchar(128)                                                not null,
ipAddress                      varchar(128)                                                not null,
loginTime                      timestamp                                                   not null       default current_timestamp,
logoutTime                     timestamp,
status                         varchar(32)                                                 not null       default 'Login',
constraint                     pk_LoginLog                                                 primary key    (oid),
constraint                     fk_loginOid_LoginLog                                        foreign key    (loginOid)
                                                                                           references     Login(Oid),
constraint                     ck_status_LoginLog                                          check          (status = 'Login' or status = 'Logout')
);



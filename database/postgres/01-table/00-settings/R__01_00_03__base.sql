/*
-
oid                            : Surrogate Primary Key
name_en                        : 
name_bn                        : 
*/
create table                   bank
(
oid                            varchar(128)                                                not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
constraint                     pk_bank                                                     primary key    (oid),
constraint                     uk_name_en_bank                                             unique         (name_en)
);

/*
-
oid                            : Surrogate Primary Key
year_en                        : Mnemonic of company name
month_name                     : Full name of Company
month_number                   : Short name of Company
*/
create table                   calendar_month
(
oid                            varchar(128)                                                not null,
year_en                        numeric(4,0)                                                not null,
month_name                     varchar(64)                                                 not null,
month_number                   numeric(2,0)                                                not null,
constraint                     pk_calendar_month                                           primary key    (oid)
);

/*
-
oid                            : Surrogate Primary Key
name                           : 
package_json                   : 
description                    : 
price                          : 
period                         : 
package_type                   : 
*/
create table                   package
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
package_json                   json,
description                    text,
price                          varchar(32),
period                         varchar(32),
package_type                   varchar(32)                                                                default 'Default',
constraint                     pk_package                                                  primary key    (oid),
constraint                     ck_package_type_package                                     check          (package_type = 'Default' or package_type = 'Custom')
);

/*
-
oid                            : Surrogate Primary Key
mnemonic                       : Mnemonic of company name
name                           : Full name of Company
short_name                     : Short name of Company
establishment_year             : 
bin_no                         : Business Identification Number of Company
company_json                   : JSON schema for attributes of company
address                        : Full english name of Company address
status                         : Status of Company
logo_path                      : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   company
(
oid                            varchar(128)                                                not null,
mnemonic                       varchar(64)                                                 not null,
name                           varchar(256)                                                not null,
short_name                     varchar(64)                                                 not null,
establishment_year             varchar(32),
bin_no                         varchar(64),
company_json                   json,
address                        text,
status                         varchar(16)                                                 not null       default 'Active',
logo_path                      text,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_company                                                  primary key    (oid),
constraint                     ck_status_company                                           check          (status = 'Active' or status = 'Inactive')
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
sort_order                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   department
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
sort_order                     numeric(5,0)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_department                                               primary key    (oid),
constraint                     fk_company_oid_department                                   foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
sort_order                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   designation
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
sort_order                     numeric(5,0)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_designation                                              primary key    (oid),
constraint                     fk_company_oid_designation                                  foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
account_no                     : 
account_name                   : 
branch_name                    : 
initial_balance                : 
status                         : Status of Company
bank_oid                       : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   bank_account
(
oid                            varchar(128)                                                not null,
account_no                     varchar(128)                                                not null,
account_name                   varchar(256)                                                not null,
branch_name                    varchar,
initial_balance                numeric(20,2)                                               not null       default 0,
status                         varchar(16)                                                 not null       default 'Active',
bank_oid                       varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_bank_account                                             primary key    (oid),
constraint                     ck_status_bank_account                                      check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_bank_oid_bank_account                                    foreign key    (bank_oid)
                                                                                           references     bank(oid),
constraint                     fk_company_oid_bank_account                                 foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : Surrogate primary key
name                           : 
mobile_no                      : 
email                          : 
address                        : 
people_type                    : 
people_json                    : 
payable_balance                : 
receivable_balance             : 
image_path                     : 
status                         : Status of people
department_oid                 : 
designation_oid                : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   people
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
mobile_no                      varchar(128),
email                          varchar(128),
address                        text,
people_type                    json                                                                       default '[]',
people_json                    json                                                                       default '[]',
payable_balance                numeric(20,2)                                               not null       default 0,
receivable_balance             numeric(20,2)                                               not null       default 0,
image_path                     text,
status                         varchar(16)                                                 not null       default 'Active',
department_oid                 varchar(128),
designation_oid                varchar(128),
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_people                                                   primary key    (oid),
constraint                     ck_status_people                                            check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_department_oid_people                                    foreign key    (department_oid)
                                                                                           references     department(oid),
constraint                     fk_designation_oid_people                                   foreign key    (designation_oid)
                                                                                           references     designation(oid),
constraint                     fk_company_oid_people                                       foreign key    (company_oid)
                                                                                           references     company(oid)
);



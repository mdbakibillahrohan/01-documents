/*

oid                            : Surrogate primary key
passenger_id                   : 
full_name                      : 
sur_name                       : 
given_name                     : 
gender                         : 
mobile_no                      : 
email                          : 
nationality                    : 
country_code                   : 
birth_registration_no          : 
personal_no                    : 
passport_number                : 
previous_passport_number       : 
birth_date                     : 
passport_issue_date            : 
passport_expiry_date           : 
passport_image_path            : 
issuing_authority              : 
description                    : 
passport_json                  : 
status                         : 
country_oid                    : 
people_oid                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   passport
(
oid                            varchar(128)                                                not null,
passenger_id                   varchar(32),
full_name                      varchar(128),
sur_name                       varchar(128),
given_name                     varchar(128),
gender                         varchar(16),
mobile_no                      varchar(128),
email                          varchar(128),
nationality                    varchar(128),
country_code                   varchar(32),
birth_registration_no          varchar(32),
personal_no                    varchar(32),
passport_number                varchar(32),
previous_passport_number       varchar(32),
birth_date                     date,
passport_issue_date            date,
passport_expiry_date           date,
passport_image_path            text                                                                       default '[]',
issuing_authority              varchar(128),
description                    text,
passport_json                  json                                                                       default '[]',
status                         varchar(32)                                                                default 'Active',
country_oid                    varchar(128),
people_oid                     varchar(128),
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_passport                                                 primary key    (oid),
constraint                     ck_status_passport                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_country_oid_passport                                     foreign key    (country_oid)
                                                                                           references     country(oid),
constraint                     fk_people_oid_passport                                      foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_passport                                     foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : Surrogate primary key
title                          : 
image_path                     : 
remarks                        : 
sort_order                     : 
country_oid                    : 
passport_oid                   : 
company_oid                    : 
*/
create table                   passport_detail
(
oid                            varchar(128)                                                not null,
title                          varchar(128),
image_path                     varchar(256),
remarks                        text,
sort_order                     numeric(3,0)                                                not null,
country_oid                    varchar(128),
passport_oid                   varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_passport_detail                                          primary key    (oid),
constraint                     fk_country_oid_passport_detail                              foreign key    (country_oid)
                                                                                           references     country(oid),
constraint                     fk_passport_oid_passport_detail                             foreign key    (passport_oid)
                                                                                           references     passport(oid),
constraint                     fk_company_oid_passport_detail                              foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : Surrogate primary key
visa_number                    : 
visa_type                      : 
visa_issue_date                : 
visa_expiry_date               : 
country                        : 
image_path                     : 
remarks                        : 
status                         : 
sort_order                     : 
passport_oid                   : 
company_oid                    : 
*/
create table                   passport_visa_information
(
oid                            varchar(128)                                                not null,
visa_number                    varchar(128),
visa_type                      varchar(128),
visa_issue_date                date,
visa_expiry_date               date,
country                        varchar(128),
image_path                     varchar(256),
remarks                        text,
status                         varchar(32)                                                 not null       default 'Active',
sort_order                     numeric(3,0)                                                not null,
passport_oid                   varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_passport_visa_information                                primary key    (oid),
constraint                     ck_status_passport_visa_information                         check          (status = 'Inactive' or status = 'Active'),
constraint                     fk_passport_oid_passport_visa_information                   foreign key    (passport_oid)
                                                                                           references     passport(oid),
constraint                     fk_company_oid_passport_visa_information                    foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : Surrogate primary key
title                          : 
command                        : 
remarks                        : 
sort_order                     : 
passport_oid                   : 
company_oid                    : 
*/
create table                   passport_command
(
oid                            varchar(128)                                                not null,
title                          varchar(128),
command                        text,
remarks                        text,
sort_order                     numeric(3,0)                                                not null,
passport_oid                   varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_passport_command                                         primary key    (oid),
constraint                     fk_passport_oid_passport_command                            foreign key    (passport_oid)
                                                                                           references     passport(oid),
constraint                     fk_company_oid_passport_command                             foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : Surrogate primary key
name                           : 
notificationValue              : 
subscribe                      : 
remarks                        : 
sort_order                     : 
passport_oid                   : 
company_oid                    : 
*/
create table                   passenger_notification
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
notificationValue              text,
subscribe                      text,
remarks                        text,
sort_order                     numeric(3,0)                                                not null,
passport_oid                   varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_passenger_notification                                   primary key    (oid),
constraint                     fk_passport_oid_passenger_notification                      foreign key    (passport_oid)
                                                                                           references     passport(oid),
constraint                     fk_company_oid_passenger_notification                       foreign key    (company_oid)
                                                                                           references     company(oid)
);



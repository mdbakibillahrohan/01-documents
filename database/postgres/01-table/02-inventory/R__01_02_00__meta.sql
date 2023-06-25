/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
address                        : 
status                         : 
is_default                     : 
company_oid                    : 
*/
create table                   warehouse
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
address                        text,
status                         varchar(16)                                                 not null       default 'Active',
is_default                     varchar(16)                                                 not null       default 'No',
company_oid                    varchar(128)                                                not null,
constraint                     pk_warehouse                                                primary key    (oid),
constraint                     ck_status_warehouse                                         check          (status = 'Active' or status = 'Inactive'),
constraint                     ck_is_default_warehouse                                     check          (is_default = 'Yes' or is_default = 'No'),
constraint                     fk_company_oid_warehouse                                    foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
name                           : 
status                         : 
company_oid                    : 
*/
create table                   product_unit
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
status                         varchar(16)                                                 not null       default 'Active',
company_oid                    varchar(128)                                                not null,
constraint                     pk_product_unit                                             primary key    (oid),
constraint                     ck_status_product_unit                                      check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_company_oid_product_unit                                 foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*

oid                            : 
name                           : 
status                         : 
company_oid                    : 
*/
create table                   product_category
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
status                         varchar(16)                                                 not null       default 'Active',
company_oid                    varchar(128)                                                not null,
constraint                     pk_product_category                                         primary key    (oid),
constraint                     ck_status_product_category                                  check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_company_oid_product_category                             foreign key    (company_oid)
                                                                                           references     company(oid)
);



/*

oid                            : 
name                           : 
product_type                   : 
selling_price                  : 
purchase_price                 : 
minimum_qty                    : 
initial_qty                    : 
initial_value                  : 
status                         : 
product_unit_oid               : 
product_category_oid           : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   product
(
oid                            varchar(128)                                                not null,
name                           varchar(128)                                                not null,
product_type                   varchar(32)                                                 not null       default 'Product',
selling_price                  numeric(20,2)                                                              default 0,
purchase_price                 numeric(20,2)                                                              default 0,
minimum_qty                    numeric(20,2)                                               not null       default 0,
initial_qty                    numeric(20,2)                                               not null       default 0,
initial_value                  numeric(20,2)                                               not null       default 0,
status                         varchar(16)                                                 not null       default 'Active',
product_unit_oid               varchar(128)                                                not null,
product_category_oid           varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_product                                                  primary key    (oid),
constraint                     ck_product_type_product                                     check          (product_type = 'Product' or product_type = 'Service'),
constraint                     ck_status_product                                           check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_product_unit_oid_product                                 foreign key    (product_unit_oid)
                                                                                           references     product_unit(oid),
constraint                     fk_product_category_oid_product                             foreign key    (product_category_oid)
                                                                                           references     product_category(oid),
constraint                     fk_company_oid_product                                      foreign key    (company_oid)
                                                                                           references     company(oid)
);



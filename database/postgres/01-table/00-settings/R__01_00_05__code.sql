/*
This table is used to store qrcode data
code                           : Surrogate primary key
table_name                     : 
company_oid                    : 
*/
create table                   transaction_id
(
code                           varchar(16)                                                 not null,
table_name                     varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_transaction_id                                           primary key    (code),
constraint                     fk_company_oid_transaction_id                               foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Custom generated code stored here
code                           : Six digit gerenated code
company_oid                    : 
*/
create table                   reserve_transaction_id
(
code                           varchar(16)                                                 not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_reserve_transaction_id                                   primary key    (code),
constraint                     fk_company_oid_reserve_transaction_id                       foreign key    (company_oid)
                                                                                           references     company(oid)
);



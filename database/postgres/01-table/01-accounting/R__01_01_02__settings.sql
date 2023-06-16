/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledger_key                     : 
ledger_name                    : 
ledger_code                    : 
ledger_oid                     : 
company_oid                    : 
*/
create table                   ledger_setting
(
oid                            varchar(128)                                                not null,
ledger_key                     varchar(128)                                                not null,
ledger_name                    varchar(128),
ledger_code                    varchar(32),
ledger_oid                     varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_ledger_setting                                           primary key    (oid),
constraint                     fk_ledger_oid_ledger_setting                                foreign key    (ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_company_oid_ledger_setting                               foreign key    (company_oid)
                                                                                           references     company(oid)
);



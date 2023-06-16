/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
history_json                   : 
history_on                     : When was created
bank_account_oid               : 
company_oid                    : 
*/
create table                   bank_account_history
(
oid                            varchar(128)                                                not null,
history_json                   json                                                        not null,
history_on                     timestamp                                                   not null       default current_timestamp,
bank_account_oid               varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_bank_account_history                                     primary key    (oid),
constraint                     fk_bank_account_oid_bank_account_history                    foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_company_oid_bank_account_history                         foreign key    (company_oid)
                                                                                           references     company(oid)
);



/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
description                    : 
status                         : 
previous_balance               : VendorCredit, CreditNote balance
payment_amount                 : 
current_balance                : ACPayable, ACReceivable balance
debit_ledger_oid               : 
credit_ledger_oid              : 
debit_subledger_oid            : 
credit_subLedger_oid           : 
people_oid                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
approved_on                    : When was created
approved_by                    : Who was created
rejected_on                    : When was created
rejected_by                    : Who was created
reason                         : 
*/
create table                   credit_note_adustment
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
payment_amount                 numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
debit_ledger_oid               varchar(128),
credit_ledger_oid              varchar(128),
debit_subledger_oid            varchar(128),
credit_subLedger_oid           varchar(128),
people_oid                     varchar(128),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_credit_note_adustment                                    primary key    (oid),
constraint                     ck_status_credit_note_adustment                             check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_debit_ledger_oid_credit_note_adustment                   foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_credit_note_adustment                  foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_credit_note_adustment                foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_credit_note_adustment               foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_credit_note_adustment                         foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_credit_note_adustment                        foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
description                    : 
status                         : 
previous_balance               : VendorCredit, CreditNote balance
payment_amount                 : 
current_balance                : ACPayable, ACReceivable balance
debit_ledger_oid               : 
credit_ledger_oid              : 
debit_subledger_oid            : 
credit_subLedger_oid           : 
people_oid                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
approved_on                    : When was created
approved_by                    : Who was created
rejected_on                    : When was created
rejected_by                    : Who was created
reason                         : 
*/
create table                   vendor_credit_adustment
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
payment_amount                 numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
debit_ledger_oid               varchar(128),
credit_ledger_oid              varchar(128),
debit_subledger_oid            varchar(128),
credit_subLedger_oid           varchar(128),
people_oid                     varchar(128),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_vendor_credit_adustment                                  primary key    (oid),
constraint                     ck_status_vendor_credit_adustment                           check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_debit_ledger_oid_vendor_credit_adustment                 foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_vendor_credit_adustment                foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_vendor_credit_adustment              foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_vendor_credit_adustment             foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_vendor_credit_adustment                       foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_vendor_credit_adustment                      foreign key    (company_oid)
                                                                                           references     company(oid)
);



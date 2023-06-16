/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
payment_mode                   : 
description                    : 
status                         : 
previous_balance               : 
payment_amount                 : 
current_balance                : 
instrument_no                  : 
instrument_type                : 
bank_account_oid               : 
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
create table                   credit_note_refund
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
payment_mode                   varchar(64),
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
payment_amount                 numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
instrument_no                  varchar(64),
instrument_type                varchar(64),
bank_account_oid               varchar(128),
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
constraint                     pk_credit_note_refund                                       primary key    (oid),
constraint                     ck_payment_mode_credit_note_refund                          check          (payment_mode = 'Cash' or payment_mode = 'CashInBank'),
constraint                     ck_status_credit_note_refund                                check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_credit_note_refund                      foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_credit_note_refund                      foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_credit_note_refund                     foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_credit_note_refund                   foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_credit_note_refund                  foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_credit_note_refund                            foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_credit_note_refund                           foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
credit_note_oid                : 
payment_made_oid               : 
credit_note_refund_oid         : 
company_oid                    : 
*/
create table                   credit_note_refund_mapping
(
oid                            varchar(128)                                                not null,
credit_note_oid                varchar(128)                                                not null,
payment_made_oid               varchar(128)                                                not null,
credit_note_refund_oid         varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_credit_note_refund_mapping                               primary key    (oid),
constraint                     fk_credit_note_oid_credit_note_refund_mapping               foreign key    (credit_note_oid)
                                                                                           references     credit_note(oid),
constraint                     fk_payment_made_oid_credit_note_refund_mapping              foreign key    (payment_made_oid)
                                                                                           references     payment_made(oid),
constraint                     fk_credit_note_refund_oid_credit_note_refund_mapping        foreign key    (credit_note_refund_oid)
                                                                                           references     credit_note_refund(oid),
constraint                     fk_company_oid_credit_note_refund_mapping                   foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
payment_mode                   : 
description                    : 
status                         : 
previous_balance               : 
payment_amount                 : 
current_balance                : 
instrument_no                  : 
instrument_type                : 
bank_account_oid               : 
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
create table                   vendor_credit_refund
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
payment_mode                   varchar(64),
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
payment_amount                 numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
instrument_no                  varchar(64),
instrument_type                varchar(64),
bank_account_oid               varchar(128),
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
constraint                     pk_vendor_credit_refund                                     primary key    (oid),
constraint                     ck_payment_mode_vendor_credit_refund                        check          (payment_mode = 'Cash' or payment_mode = 'CashInBank'),
constraint                     ck_status_vendor_credit_refund                              check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_vendor_credit_refund                    foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_vendor_credit_refund                    foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_vendor_credit_refund                   foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_vendor_credit_refund                 foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_vendor_credit_refund                foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_vendor_credit_refund                          foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_vendor_credit_refund                         foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
vendor_credit_oid              : 
payment_received_oid           : 
vendor_credit_refund_oid       : 
company_oid                    : 
*/
create table                   vendor_credit_refund_mapping
(
oid                            varchar(128)                                                not null,
vendor_credit_oid              varchar(128)                                                not null,
payment_received_oid           varchar(128)                                                not null,
vendor_credit_refund_oid       varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_vendor_credit_refund_mapping                             primary key    (oid),
constraint                     fk_vendor_credit_oid_vendor_credit_refund_mapping           foreign key    (vendor_credit_oid)
                                                                                           references     vendor_credit(oid),
constraint                     fk_payment_received_oid_vendor_credit_refund_mapping        foreign key    (payment_received_oid)
                                                                                           references     payment_received(oid),
constraint                     fk_vendor_credit_refund_oid_vendor_credit_refund_mapping    foreign key    (vendor_credit_refund_oid)
                                                                                           references     vendor_credit_refund(oid),
constraint                     fk_company_oid_vendor_credit_refund_mapping                 foreign key    (company_oid)
                                                                                           references     company(oid)
);



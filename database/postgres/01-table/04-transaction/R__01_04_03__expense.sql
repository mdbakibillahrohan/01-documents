/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
expense_no                     : 
expense_date                   : 
image_path                     : 
expense_amount                 : 
description                    : 
status                         : 
payment_status                 : 
payment_amount                 : 
paid_amount                    : 
due_amount                     : 
payment_mode                   : 
instrument_no                  : 
instrument_type                : 
bank_account_oid               : 
credit_ledger_oid              : 
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
create table                   expense_summary
(
oid                            varchar(64)                                                 not null,
expense_no                     varchar(64)                                                 not null,
expense_date                   date                                                        not null,
image_path                     text,
expense_amount                 numeric(20,2)                                               not null       default 0,
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
payment_status                 varchar(16)                                                 not null       default 'No',
payment_amount                 numeric(20,2)                                                              default 0,
paid_amount                    numeric(20,2)                                                              default 0,
due_amount                     numeric(20,2)                                                              default 0,
payment_mode                   varchar(64),
instrument_no                  varchar(64),
instrument_type                varchar(64),
bank_account_oid               varchar(128),
credit_ledger_oid              varchar(128),
credit_subLedger_oid           varchar(128),
people_oid                     varchar(64),
company_oid                    varchar(64),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_expense_summary                                          primary key    (oid),
constraint                     ck_status_expense_summary                                   check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     ck_payment_status_expense_summary                           check          (payment_status = 'Yes' or payment_status = 'No'),
constraint                     ck_payment_mode_expense_summary                             check          (payment_mode = 'Cash' or payment_mode = 'CashInBank'),
constraint                     fk_bank_account_oid_expense_summary                         foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_credit_ledger_oid_expense_summary                        foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_subLedger_oid_expense_summary                     foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_expense_summary                               foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_expense_summary                              foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
amount                         : 
sort_order                     : 
ledger_oid                     : 
expense_summary_oid            : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   expense_detail
(
oid                            varchar(128)                                                not null,
amount                         numeric(10,2)                                               not null       default 0,
sort_order                     numeric(5,0),
ledger_oid                     varchar(128)                                                not null,
expense_summary_oid            varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_expense_detail                                           primary key    (oid),
constraint                     fk_ledger_oid_expense_detail                                foreign key    (ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_expense_summary_oid_expense_detail                       foreign key    (expense_summary_oid)
                                                                                           references     expense_summary(oid),
constraint                     fk_company_oid_expense_detail                               foreign key    (company_oid)
                                                                                           references     company(oid)
);



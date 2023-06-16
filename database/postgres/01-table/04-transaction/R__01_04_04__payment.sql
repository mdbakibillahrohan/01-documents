/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
payment_mode                   : 
transaction_type               : 
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
reference_oid                  : 
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
create table                   payment_made
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
payment_mode                   varchar(64),
transaction_type               varchar(64)                                                 not null,
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
reference_oid                  varchar(128),
people_oid                     varchar(128),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_payment_made                                             primary key    (oid),
constraint                     ck_payment_mode_payment_made                                check          (payment_mode = 'Cash' or payment_mode = 'CashInBank'),
constraint                     ck_transaction_type_payment_made                            check          (transaction_type = 'CashIn' or transaction_type = 'CashOut' or transaction_type = 'ACPayable' or transaction_type = 'ACReceivable' or transaction_type = 'CreditNotePaid' or transaction_type = 'VendorCreditPaid' or transaction_type = 'CreditNoteReceived' or transaction_type = 'VendorCreditReceived'),
constraint                     ck_status_payment_made                                      check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_payment_made                            foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_payment_made                            foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_payment_made                           foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_payment_made                         foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_payment_made                        foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_payment_made                                  foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_payment_made                                 foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
expense_summary_oid            : 
payment_made_oid               : 
company_oid                    : 
*/
create table                   expense_payment_mapping
(
oid                            varchar(128)                                                not null,
expense_summary_oid            varchar(128)                                                not null,
payment_made_oid               varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
constraint                     pk_expense_payment_mapping                                  primary key    (oid),
constraint                     fk_expense_summary_oid_expense_payment_mapping              foreign key    (expense_summary_oid)
                                                                                           references     expense_summary(oid),
constraint                     fk_payment_made_oid_expense_payment_mapping                 foreign key    (payment_made_oid)
                                                                                           references     payment_made(oid),
constraint                     fk_company_oid_expense_payment_mapping                      foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
payment_no                     : 
payment_date                   : 
payment_mode                   : 
transaction_type               : 
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
reference_oid                  : 
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
create table                   payment_received
(
oid                            varchar(128)                                                not null,
payment_no                     varchar(64)                                                 not null,
payment_date                   date                                                        not null,
payment_mode                   varchar(64),
transaction_type               varchar(64)                                                 not null,
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
reference_oid                  varchar(128),
people_oid                     varchar(128),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_payment_received                                         primary key    (oid),
constraint                     ck_payment_mode_payment_received                            check          (payment_mode = 'Cash' or payment_mode = 'CashInBank'),
constraint                     ck_transaction_type_payment_received                        check          (transaction_type = 'CashIn' or transaction_type = 'CashOut' or transaction_type = 'ACPayable' or transaction_type = 'ACReceivable' or transaction_type = 'CreditNotePaid' or transaction_type = 'VendorCreditPaid' or transaction_type = 'CreditNoteReceived' or transaction_type = 'VendorCreditReceived'),
constraint                     ck_status_payment_received                                  check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_payment_received                        foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_payment_received                        foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_payment_received                       foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_payment_received                     foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_payment_received                    foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_people_oid_payment_received                              foreign key    (people_oid)
                                                                                           references     people(oid),
constraint                     fk_company_oid_payment_received                             foreign key    (company_oid)
                                                                                           references     company(oid)
);



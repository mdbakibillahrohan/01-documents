/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
transaction_no                 : 
transaction_date               : 
transaction_type               : 
description                    : 
status                         : 
previous_balance               : 
transaction_amount             : 
current_balance                : 
bank_account_oid               : 
debit_ledger_oid               : 
credit_ledger_oid              : 
debit_subledger_oid            : 
credit_subLedger_oid           : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
approved_on                    : When was created
approved_by                    : Who was created
rejected_on                    : When was created
rejected_by                    : Who was created
reason                         : 
*/
create table                   cash_book
(
oid                            varchar(128)                                                not null,
transaction_no                 varchar(64)                                                 not null,
transaction_date               date                                                        not null,
transaction_type               varchar(64)                                                 not null,
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
transaction_amount             numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
bank_account_oid               varchar(128),
debit_ledger_oid               varchar(128),
credit_ledger_oid              varchar(128),
debit_subledger_oid            varchar(128),
credit_subLedger_oid           varchar(128),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
approved_on                    timestamp,
approved_by                    varchar(64),
rejected_on                    timestamp,
rejected_by                    varchar(64),
reason                         text,
constraint                     pk_cash_book                                                primary key    (oid),
constraint                     ck_transaction_type_cash_book                               check          (transaction_type = 'CashIn' or transaction_type = 'CashOut' or transaction_type = 'ACPayable' or transaction_type = 'ACReceivable' or transaction_type = 'CreditNotePaid' or transaction_type = 'VendorCreditPaid' or transaction_type = 'CreditNoteReceived' or transaction_type = 'VendorCreditReceived'),
constraint                     ck_status_cash_book                                         check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_cash_book                               foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_cash_book                               foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_cash_book                              foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_cash_book                            foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_cash_book                           foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_company_oid_cash_book                                    foreign key    (company_oid)
                                                                                           references     company(oid)
);



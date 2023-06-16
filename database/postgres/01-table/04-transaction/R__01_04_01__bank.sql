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
instrument_no                  : 
instrument_type                : 
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
create table                   bank_transaction
(
oid                            varchar(128)                                                not null,
transaction_no                 varchar(64)                                                 not null,
transaction_date               date                                                        not null,
transaction_type               varchar(64),
description                    text,
status                         varchar(16)                                                 not null       default 'Draft',
previous_balance               numeric(20,2)                                                              default 0,
transaction_amount             numeric(20,2)                                               not null       default 0,
current_balance                numeric(20,2)                                               not null       default 0,
instrument_no                  varchar(64),
instrument_type                varchar(64),
bank_account_oid               varchar(128)                                                not null,
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
constraint                     pk_bank_transaction                                         primary key    (oid),
constraint                     ck_transaction_type_bank_transaction                        check          (transaction_type = 'Deposit' or transaction_type = 'Withdraw' or transaction_type = 'CashToBank' or transaction_type = 'BankToCash' or transaction_type = 'ACPayable' or transaction_type = 'ACReceivable' or transaction_type = 'CreditNotePaid' or transaction_type = 'VendorCreditPaid' or transaction_type = 'CreditNoteReceived' or transaction_type = 'VendorCreditReceived'),
constraint                     ck_status_bank_transaction                                  check          (status = 'Draft' or status = 'Submitted' or status = 'Approved' or status = 'Rejected'),
constraint                     fk_bank_account_oid_bank_transaction                        foreign key    (bank_account_oid)
                                                                                           references     bank_account(oid),
constraint                     fk_debit_ledger_oid_bank_transaction                        foreign key    (debit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_credit_ledger_oid_bank_transaction                       foreign key    (credit_ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_debit_subledger_oid_bank_transaction                     foreign key    (debit_subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_credit_subLedger_oid_bank_transaction                    foreign key    (credit_subLedger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_company_oid_bank_transaction                             foreign key    (company_oid)
                                                                                           references     company(oid)
);



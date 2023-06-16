/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledger_code                    : 
ledger_name                    : 
mnemonic                       : 
ledger_type                    : 
balance_sheet_item             : 
initial_balance                : 
ledger_balance                 : 
status                         : 
parent_oid                     : 
ledger_subgroup_oid            : 
financial_period_oid           : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   ledger_history
(
oid                            varchar(64)                                                 not null,
ledger_code                    varchar(32)                                                 not null,
ledger_name                    varchar(128)                                                not null,
mnemonic                       varchar(128),
ledger_type                    varchar(8)                                                  not null,
balance_sheet_item             varchar(8)                                                  not null       default 'No',
initial_balance                numeric(20,2)                                               not null       default 0,
ledger_balance                 numeric(20,2)                                               not null       default 0,
status                         varchar(16)                                                 not null       default 'Active',
parent_oid                     varchar(128),
ledger_subgroup_oid            varchar(128)                                                not null,
financial_period_oid           varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_ledger_history                                           primary key    (oid),
constraint                     ck_ledger_type_ledger_history                               check          (ledger_type = 'Debit' or ledger_type = 'Credit'),
constraint                     ck_balance_sheet_item_ledger_history                        check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     ck_status_ledger_history                                    check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_subgroup_oid_ledger_history                       foreign key    (ledger_subgroup_oid)
                                                                                           references     ledger_subgroup(oid),
constraint                     fk_financial_period_oid_ledger_history                      foreign key    (financial_period_oid)
                                                                                           references     financial_period(oid),
constraint                     fk_company_oid_ledger_history                               foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledger_key                     : 
subledger_code                 : 
subledger_name                 : 
subledger_type                 : 
balance_sheet_item             : 
initial_balance                : 
subledger_balance              : 
status                         : 
reference_oid                  : -
parent_oid                     : 
ledger_oid                     : 
ledger_history_oid             : 
financial_period_oid           : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   subledger_history
(
oid                            varchar(64)                                                 not null,
ledger_key                     varchar(64),
subledger_code                 varchar(10),
subledger_name                 varchar(128)                                                not null,
subledger_type                 varchar(16)                                                 not null,
balance_sheet_item             varchar(8)                                                  not null       default 'No',
initial_balance                numeric(20,2)                                               not null       default 0,
subledger_balance              numeric(20,2)                                               not null       default 0,
status                         varchar(16)                                                 not null       default 'Active',
reference_oid                  varchar(128),
parent_oid                     varchar(128),
ledger_oid                     varchar(128)                                                not null,
ledger_history_oid             varchar(128),
financial_period_oid           varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_subledger_history                                        primary key    (oid),
constraint                     ck_subledger_type_subledger_history                         check          (subledger_type = 'Debit' or subledger_type = 'Credit'),
constraint                     ck_balance_sheet_item_subledger_history                     check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     ck_status_subledger_history                                 check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_oid_subledger_history                             foreign key    (ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_ledger_history_oid_subledger_history                     foreign key    (ledger_history_oid)
                                                                                           references     ledger_history(oid),
constraint                     fk_financial_period_oid_subledger_history                   foreign key    (financial_period_oid)
                                                                                           references     financial_period(oid),
constraint                     fk_company_oid_subledger_history                            foreign key    (company_oid)
                                                                                           references     company(oid)
);



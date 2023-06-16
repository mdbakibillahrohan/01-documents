/*
Log for every request to (and response from) Antarika
oid                            : Surrogate Primary Key
ledger_group_code              : 
ledger_group_name              : 
ledger_group_type              : 
balance_sheet_item             : 
company_oid                    : 
*/
create table                   ledger_group
(
oid                            varchar(128)                                                not null,
ledger_group_code              varchar(2),
ledger_group_name              varchar(128),
ledger_group_type              varchar(16)                                                 not null,
balance_sheet_item             varchar(8)                                                  not null       default 'No',
company_oid                    varchar(128)                                                not null,
constraint                     pk_ledger_group                                             primary key    (oid),
constraint                     ck_ledger_group_type_ledger_group                           check          (ledger_group_type = 'Debit' or ledger_group_type = 'Credit'),
constraint                     ck_balance_sheet_item_ledger_group                          check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     fk_company_oid_ledger_group                                 foreign key    (company_oid)
                                                                                           references     company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate Primary Key
ledger_subgroup_code           : 
ledger_subgroup_name           : 
ledger_subgroup_type           : 
balance_sheet_item             : 
ledger_group_oid               : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   ledger_subgroup
(
oid                            varchar(128)                                                not null,
ledger_subgroup_code           varchar(4),
ledger_subgroup_name           varchar(128),
ledger_subgroup_type           varchar(16)                                                 not null,
balance_sheet_item             varchar(8)                                                  not null       default 'No',
ledger_group_oid               varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_ledger_subgroup                                          primary key    (oid),
constraint                     ck_ledger_subgroup_type_ledger_subgroup                     check          (ledger_subgroup_type = 'Debit' or ledger_subgroup_type = 'Credit'),
constraint                     ck_balance_sheet_item_ledger_subgroup                       check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     fk_ledger_group_oid_ledger_subgroup                         foreign key    (ledger_group_oid)
                                                                                           references     ledger_group(oid),
constraint                     fk_company_oid_ledger_subgroup                              foreign key    (company_oid)
                                                                                           references     company(oid)
);

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
ledger_subgroup_oid            : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   ledger
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
ledger_subgroup_oid            varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_ledger                                                   primary key    (oid),
constraint                     ck_ledger_type_ledger                                       check          (ledger_type = 'Debit' or ledger_type = 'Credit'),
constraint                     ck_balance_sheet_item_ledger                                check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     ck_status_ledger                                            check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_subgroup_oid_ledger                               foreign key    (ledger_subgroup_oid)
                                                                                           references     ledger_subgroup(oid),
constraint                     fk_company_oid_ledger                                       foreign key    (company_oid)
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
ledger_oid                     : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   subledger
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
ledger_oid                     varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_subledger                                                primary key    (oid),
constraint                     ck_subledger_type_subledger                                 check          (subledger_type = 'Debit' or subledger_type = 'Credit'),
constraint                     ck_balance_sheet_item_subledger                             check          (balance_sheet_item = 'Yes' or balance_sheet_item = 'No'),
constraint                     ck_status_subledger                                         check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledger_oid_subledger                                     foreign key    (ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_company_oid_subledger                                    foreign key    (company_oid)
                                                                                           references     company(oid)
);



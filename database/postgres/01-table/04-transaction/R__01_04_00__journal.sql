/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
journal_date                   : 
journal_type                   : Adjustment Journal
journal_manner                 : Auto/Manual
description                    : 
amount                         : 
reference_no                   : 
status                         : 
created_on                     : When was created
created_by                     : Who was created
company_oid                    : 
financial_period_oid           : 
*/
create table                   journal_summary
(
oid                            varchar(64)                                                 not null,
journal_date                   date                                                        not null,
journal_type                   varchar(64),
journal_manner                 varchar(64)                                                 not null       default 'Auto',
description                    text,
amount                         numeric(20,2)                                               not null       default 0,
reference_no                   varchar(128),
status                         varchar(16)                                                 not null       default 'Active',
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
company_oid                    varchar(128)                                                not null,
financial_period_oid           varchar(128)                                                not null,
constraint                     pk_journal_summary                                          primary key    (oid),
constraint                     ck_journal_manner_journal_summary                           check          (journal_manner = 'Auto' or journal_manner = 'Manual'),
constraint                     ck_status_journal_summary                                   check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_company_oid_journal_summary                              foreign key    (company_oid)
                                                                                           references     company(oid),
constraint                     fk_financial_period_oid_journal_summary                     foreign key    (financial_period_oid)
                                                                                           references     financial_period(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
entry_no                       : 
description                    : 
debited_amount                 : 
credited_amount                : 
ledger_oid                     : 
ledger_balance                 : 
subledger_oid                  : 
subledger_balance              : 
journal_summary_oid            : 
company_oid                    : 
financial_period_oid           : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   journal
(
oid                            varchar(64)                                                 not null,
entry_no                       numeric(5,0)                                                not null,
description                    text,
debited_amount                 numeric(20,2)                                               not null,
credited_amount                numeric(20,2)                                               not null,
ledger_oid                     varchar(128)                                                not null,
ledger_balance                 numeric(20,2)                                               not null,
subledger_oid                  varchar(128),
subledger_balance              numeric(20,2),
journal_summary_oid            varchar(128)                                                not null,
company_oid                    varchar(128)                                                not null,
financial_period_oid           varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_journal                                                  primary key    (oid),
constraint                     fk_ledger_oid_journal                                       foreign key    (ledger_oid)
                                                                                           references     ledger(oid),
constraint                     fk_subledger_oid_journal                                    foreign key    (subledger_oid)
                                                                                           references     subledger(oid),
constraint                     fk_journal_summary_oid_journal                              foreign key    (journal_summary_oid)
                                                                                           references     journal_summary(oid),
constraint                     fk_company_oid_journal                                      foreign key    (company_oid)
                                                                                           references     company(oid),
constraint                     fk_financial_period_oid_journal                             foreign key    (financial_period_oid)
                                                                                           references     financial_period(oid)
);



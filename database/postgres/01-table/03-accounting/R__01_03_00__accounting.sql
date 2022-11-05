/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledgerKey                      : 
ledgerName                     : 
ledgerCode                     : 
status                         : 
ledgerOid                      : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_LedgerSetting
(
oid                            varchar(64)                                                 not null,
ledgerKey                      varchar(128)                                                not null,
ledgerName                     varchar(128),
ledgerCode                     varchar(32),
status                         varchar(32)                                                 not null       default 'Active',
ledgerOid                      varchar(64),
companyOid                     varchar(64)                                                 not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_LedgerSetting                                          primary key    (oid),
constraint                     fk_ledgerOid_t_LedgerSetting                                foreign key    (ledgerOid)
                                                                                           references     t_Ledger(oid),
constraint                     fk_companyOid_t_LedgerSetting                               foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
journalEntryDate               : 
journalType                    : 
journalManner                  : 
notes                          : 
amount                         : 
referenceNo                    : 
bankAccountNo                  : 
versionId                      : 
status                         : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_JournalSummary
(
oid                            varchar(64)                                                 not null,
journalEntryDate               date                                                        not null,
journalType                    varchar(16)                                                 not null,
journalManner                  varchar(16),
notes                          varchar(256),
amount                         numeric(20,2)                                               not null       default 0,
referenceNo                    varchar(128),
bankAccountNo                  varchar(64),
versionId                      varchar(4),
status                         varchar(32)                                                 not null       default 'Active',
companyOid                     varchar(64)                                                 not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_JournalSummary                                         primary key    (oid),
constraint                     fk_companyOid_t_JournalSummary                              foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
journalEntryDate               : 
journalEntryNo                 : 
contactTag                     : 
referenceNo                    : 
description                    : 
debitedAmount                  : 
creditedAmount                 : 
ledgerOid                      : 
ledgerCode                     : 
ledgerBalance                  : 
subledgerOid                   : 
subledgerCode                  : 
subledgerBalance               : 
journalSummaryOid              : 
companyOid                     : 
versionId                      : 
status                         : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_Journal
(
oid                            varchar(64)                                                 not null,
journalEntryDate               date                                                        not null,
journalEntryNo                 numeric(5,0)                                                not null,
contactTag                     varchar(128),
referenceNo                    varchar(128),
description                    varchar(256),
debitedAmount                  numeric(20,2)                                               not null,
creditedAmount                 numeric(20,2)                                               not null,
ledgerOid                      varchar(64)                                                 not null,
ledgerCode                     varchar(16)                                                 not null,
ledgerBalance                  numeric(20,2)                                               not null,
subledgerOid                   varchar(64),
subledgerCode                  varchar(64),
subledgerBalance               numeric(20,2),
journalSummaryOid              varchar(64),
companyOid                     varchar(64)                                                 not null,
versionId                      varchar(4),
status                         varchar(32)                                                 not null       default 'Active',
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_Journal                                                primary key    (oid),
constraint                     fk_ledgerOid_t_Journal                                      foreign key    (ledgerOid)
                                                                                           references     t_Ledger(oid),
constraint                     fk_subledgerOid_t_Journal                                   foreign key    (subledgerOid)
                                                                                           references     t_SubLedger(oid),
constraint                     fk_journalSummaryOid_t_Journal                              foreign key    (journalSummaryOid)
                                                                                           references     t_JournalSummary(oid),
constraint                     fk_companyOid_t_Journal                                     foreign key    (companyOid)
                                                                                           references     Company(oid)
);



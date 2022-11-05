/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledgerkey                      : 
subLedgerName                  : 
subLedgerCode                  : 
mnemonic                       : 
subLedgerType                  : 
isBalanceSheetItem             : 
subLedgerBalance               : 
openingBalance                 : 
closingBalance                 : 
ledgerCode                     : 
versionId                      : 
status                         : 
referenceOid                   : 
ledgerOid                      : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_SubLedger
(
oid                            varchar(64)                                                 not null,
ledgerkey                      varchar(64),
subLedgerName                  varchar(128)                                                not null,
subLedgerCode                  varchar(10),
mnemonic                       varchar(32)                                                 not null,
subLedgerType                  varchar(16)                                                 not null,
isBalanceSheetItem             varchar(8)                                                  not null       default 'No',
subLedgerBalance               numeric(20,2)                                                              default 0,
openingBalance                 numeric(20,2)                                                              default 0,
closingBalance                 numeric(20,2)                                                              default 0,
ledgerCode                     varchar(7),
versionId                      varchar(4)                                                  not null       default '1',
status                         varchar(32)                                                 not null       default 'Active',
referenceOid                   varchar(64),
ledgerOid                      varchar(64),
companyOid                     varchar(64),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_SubLedger                                              primary key    (oid),
constraint                     ck_isBalanceSheetItem_t_SubLedger                           check          (isBalanceSheetItem = 'Yes' or isBalanceSheetItem = 'No'),
constraint                     fk_ledgerOid_t_SubLedger                                    foreign key    (ledgerOid)
                                                                                           references     t_Ledger(oid),
constraint                     fk_companyOid_t_SubLedger                                   foreign key    (companyOid)
                                                                                           references     Company(oid)
);



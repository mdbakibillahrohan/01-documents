/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledgerGroupName                : 
ledgerGroupCode                : 
ledgerGroupType                : 
isBalanceSheetItem             : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_LedgerGroup
(
oid                            varchar(64)                                                 not null,
ledgerGroupName                varchar(128),
ledgerGroupCode                varchar(2),
ledgerGroupType                varchar(16)                                                 not null,
isBalanceSheetItem             varchar(8)                                                  not null       default 'No',
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_LedgerGroup                                            primary key    (oid),
constraint                     ck_isBalanceSheetItem_t_LedgerGroup                         check          (isBalanceSheetItem = 'Yes' or isBalanceSheetItem = 'No')
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledgerSubGroupName             : 
ledgerSubGroupCode             : 
ledgerSubGroupType             : 
isBalanceSheetItem             : 
ledgerGroupCode                : 
versionId                      : 
status                         : 
ledgerGroupOid                 : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_LedgerSubGroup
(
oid                            varchar(64)                                                 not null,
ledgerSubGroupName             varchar(128)                                                not null,
ledgerSubGroupCode             varchar(4)                                                  not null,
ledgerSubGroupType             varchar(64)                                                 not null,
isBalanceSheetItem             varchar(8)                                                  not null       default 'No',
ledgerGroupCode                varchar(32)                                                 not null,
versionId                      varchar(4)                                                                 default '1',
status                         varchar(32)                                                 not null       default 'Active',
ledgerGroupOid                 varchar(64)                                                 not null,
companyOid                     varchar(64)                                                 not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_LedgerSubGroup                                         primary key    (oid),
constraint                     ck_isBalanceSheetItem_t_LedgerSubGroup                      check          (isBalanceSheetItem = 'Yes' or isBalanceSheetItem = 'No'),
constraint                     ck_status_t_LedgerSubGroup                                  check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledgerGroupOid_t_LedgerSubGroup                          foreign key    (ledgerGroupOid)
                                                                                           references     t_LedgerGroup(oid),
constraint                     fk_companyOid_t_LedgerSubGroup                              foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ledgerName                     : 
ledgerCode                     : 
mnemonic                       : 
ledgerType                     : 
isBalanceSheetItem             : 
ledgerBalance                  : 
openingBalance                 : 
closingBalance                 : -
ledgerSubGroupCode             : -
versionId                      : -
status                         : -
ledgerSubGroupOid              : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   t_Ledger
(
oid                            varchar(64)                                                 not null,
ledgerName                     varchar(128)                                                not null,
ledgerCode                     varchar(32)                                                 not null,
mnemonic                       varchar(64),
ledgerType                     varchar(8)                                                  not null,
isBalanceSheetItem             varchar(8)                                                  not null       default 'No',
ledgerBalance                  numeric(20,2)                                               not null       default 0,
openingBalance                 numeric(20,2),
closingBalance                 numeric(20,2),
ledgerSubGroupCode             varchar(4)                                                  not null,
versionId                      varchar(4)                                                  not null       default '1',
status                         varchar(32)                                                 not null       default 'Active',
ledgerSubGroupOid              varchar(64)                                                 not null,
companyOid                     varchar(64)                                                 not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_t_Ledger                                                 primary key    (oid),
constraint                     ck_isBalanceSheetItem_t_Ledger                              check          (isBalanceSheetItem = 'Yes' or isBalanceSheetItem = 'No'),
constraint                     ck_status_t_Ledger                                          check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_ledgerSubGroupOid_t_Ledger                               foreign key    (ledgerSubGroupOid)
                                                                                           references     t_LedgerSubGroup(oid),
constraint                     fk_companyOid_t_Ledger                                      foreign key    (companyOid)
                                                                                           references     Company(oid)
);



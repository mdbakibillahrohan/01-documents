/*

oid                            : Surrogate primary key
transactionNo                  : 
transactionDate                : 
amount                         : 
status                         : 
transactionType                : 
description                    : 
accountOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
companyOid                     : 
*/
create table                   AccountTransaction
(
oid                            varchar(128)                                                not null,
transactionNo                  varchar(64)                                                 not null,
transactionDate                date                                                        not null,
amount                         numeric(18,2)                                               not null       default 0,
status                         varchar(32)                                                 not null       default 'Active',
transactionType                varchar(32)                                                 not null,
description                    text,
accountOid                     varchar(128)                                                not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_AccountTransaction                                       primary key    (oid),
constraint                     uk_transactionNo_AccountTransaction                         unique         (transactionNo),
constraint                     ck_status_AccountTransaction                                check          (status = 'Active' or status = 'Inactive' or status = 'Draft'),
constraint                     ck_transactionType_AccountTransaction                       check          (transactionType = 'Debit' or transactionType = 'Credit'),
constraint                     fk_accountOid_AccountTransaction                            foreign key    (accountOid)
                                                                                           references     Account(oid),
constraint                     fk_companyOid_AccountTransaction                            foreign key    (companyOid)
                                                                                           references     Company(oid)
);



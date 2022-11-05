/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
expenseNo                      : 
expenseDate                    : 
expenseBy                      : 
referenceNo                    : 
status                         : 
description                    : 
imagePath                      : 
expenseAmount                  : 
paidAmount                     : 
dueAmount                      : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   ExpenseSummary
(
oid                            varchar(64)                                                 not null,
expenseNo                      varchar(64)                                                 not null,
expenseDate                    date                                                        not null,
expenseBy                      varchar(64)                                                 not null,
referenceNo                    varchar(128),
status                         varchar(32)                                                 not null       default 'Draft',
description                    text,
imagePath                      text,
expenseAmount                  numeric(10,2)                                               not null       default 0,
paidAmount                     numeric(10,2)                                               not null       default 0,
dueAmount                      numeric(10,2)                                               not null       default 0,
companyOid                     varchar(64)                                                 not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_ExpenseSummary                                           primary key    (oid),
constraint                     fk_expenseBy_ExpenseSummary                                 foreign key    (expenseBy)
                                                                                           references     Employee(oid),
constraint                     fk_companyOid_ExpenseSummary                                foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
description                    : 
amount                         : 
sortOrder                      : 
expenseOid                     : 
companyOid                     : 
*/
create table                   ExpenseDetail
(
oid                            varchar(64)                                                 not null,
description                    text,
amount                         numeric(10,2)                                               not null       default 0,
sortOrder                      numeric(5,0)                                                not null,
expenseOid                     varchar(64)                                                 not null,
companyOid                     varchar(64)                                                 not null,
constraint                     pk_ExpenseDetail                                            primary key    (oid),
constraint                     fk_expenseOid_ExpenseDetail                                 foreign key    (expenseOid)
                                                                                           references     ExpenseSummary(oid),
constraint                     fk_companyOid_ExpenseDetail                                 foreign key    (companyOid)
                                                                                           references     Company(oid)
);



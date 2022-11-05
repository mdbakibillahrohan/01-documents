/*
Audit log information of Login
oid                            : Surrogate primary key
paymentNo                      : 
paymentDate                    : 
amount                         : 
status                         : 
chequeIssueDate                : Cheque Issue Date
checkNo                        : 
accountHolderName              : 
bankAccountNo                  : 
bankName                       : 
branchName                     : 
description                    : 
paymentNature                  : 
paymentType                    : Credit - Money In, Debit - Money Out
paymentMode                    : 
entryType                      : Manual - General Entry, Auto - Payment Adjustment Entry
referenceType                  : 
referenceOid                   : 
referenceBy                    : 
referenceByMobileNo            : 
receivedBy                     : Employee Oid
accountOid                     : 
imagePath                      : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
companyOid                     : 
*/
create table                   Payment
(
oid                            varchar(128)                                                not null,
paymentNo                      varchar(64)                                                 not null,
paymentDate                    date                                                        not null,
amount                         numeric(18,2)                                               not null       default 0,
status                         varchar(32)                                                 not null       default 'Active',
chequeIssueDate                date,
checkNo                        varchar(32),
accountHolderName              varchar(128),
bankAccountNo                  varchar(32),
bankName                       varchar(128),
branchName                     varchar(128),
description                    text,
paymentNature                  varchar(32)                                                 not null,
paymentType                    varchar(32),
paymentMode                    varchar(32)                                                                default 'Cash',
entryType                      varchar(32)                                                                default 'Manual',
referenceType                  varchar(32)                                                 not null,
referenceOid                   varchar(128)                                                not null,
referenceBy                    varchar(128),
referenceByMobileNo            varchar(128),
receivedBy                     varchar(128),
accountOid                     varchar(128),
imagePath                      varchar(256),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_Payment                                                  primary key    (oid),
constraint                     uk_paymentNo_Payment                                        unique         (paymentNo),
constraint                     ck_status_Payment                                           check          (status = 'Active' or status = 'Inactive' or status = 'Draft'),
constraint                     ck_paymentNature_Payment                                    check          (paymentNature = 'CreditNote' or paymentNature = 'Withdraw' or paymentNature = 'CashWithdraw' or paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment'),
constraint                     ck_paymentType_Payment                                      check          (paymentType = 'Debit' or paymentType = 'Credit'),
constraint                     ck_paymentMode_Payment                                      check          (paymentMode = 'Cheque' or paymentMode = 'BankDeposit' or paymentMode = 'Cash' or paymentMode = 'CreditCard' or paymentMode = 'CreditNote'),
constraint                     ck_entryType_Payment                                        check          (entryType = 'Manual' or entryType = 'Auto'),
constraint                     ck_referenceType_Payment                                    check          (referenceType = 'Customer' or referenceType = 'Supplier' or referenceType = 'Expense'),
constraint                     fk_receivedBy_Payment                                       foreign key    (receivedBy)
                                                                                           references     Employee(oid),
constraint                     fk_accountOid_Payment                                       foreign key    (accountOid)
                                                                                           references     Account(oid),
constraint                     fk_companyOid_Payment                                       foreign key    (companyOid)
                                                                                           references     Company(oid)
);



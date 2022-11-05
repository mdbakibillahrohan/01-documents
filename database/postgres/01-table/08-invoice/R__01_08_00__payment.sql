/*

oid                            : Surrogate primary key
refInvoiceType                 : 
amount                         : 
remarks                        : 
status                         : 
paymentOid                     : 
refInvoiceOid                  : 
companyOid                     : 
*/
create table                   InvoiceBillPayment
(
oid                            varchar(128)                                                not null,
refInvoiceType                 varchar(32),
amount                         numeric(10,2)                                                              default 0,
remarks                        text,
status                         varchar(32)                                                 not null,
paymentOid                     varchar(128),
refInvoiceOid                  varchar(128),
companyOid                     varchar(128)                                                not null,
constraint                     pk_InvoiceBillPayment                                       primary key    (oid),
constraint                     ck_status_InvoiceBillPayment                                check          (status = 'Draft' or status = 'Active'),
constraint                     fk_paymentOid_InvoiceBillPayment                            foreign key    (paymentOid)
                                                                                           references     Payment(oid),
constraint                     fk_companyOid_InvoiceBillPayment                            foreign key    (companyOid)
                                                                                           references     Company(oid)
);



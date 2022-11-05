/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
subject                        : 
pnr                            : 
ticketNo                       : 
ticketJson                     : 
status                         : 
ticketCloneOid                 : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
companyOid                     : 
*/
create table                   DraftTicket
(
oid                            varchar(128)                                                not null,
subject                        varchar(128),
pnr                            varchar(128),
ticketNo                       varchar(128),
ticketJson                     text,
status                         varchar(32)                                                 not null       default 'Draft',
ticketCloneOid                 varchar(64),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
companyOid                     varchar(128)                                                not null,
constraint                     pk_DraftTicket                                              primary key    (oid),
constraint                     ck_status_DraftTicket                                       check          (status = 'Draft' or status = 'Active'),
constraint                     fk_companyOid_DraftTicket                                   foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*

oid                            : Surrogate primary key
invoiceNo                      : 
invoiceDate                    : 
emailSubject                   : Json string array
serviceCharge                  : 
totalServiceCharge             : 
companyServiceCharge           : 
totalCompanyServiceCharge      : 
commissionType                 : 
commissionValue                : 
totalCommission                : 
totalExtCommission             : 
purchasePrice                  : 
incentiveAmount                : 
netPurchasePrice               : 
salesPrice                     : 
discountAmount                 : 
netSalesPrice                  : 
customerActualPanaltyAmount    : Airlines Penalty Amount
customerPanaltyAmount          : Company Penalty Amount
customerRefundAmount           : 
customerAdditionalServiceAmount : 
customerAdcAmount              : 
vendorActualPanaltyAmount      : Airlines Penalty Amount
vendorPanaltyAmount            : Company Penalty Amount
vendorRefundAmount             : 
vendorAdditionalServiceAmount  : 
vendorAdcAmount                : 
payableAmount                  : 
receivableAmount               : 
additionalProfitAmount         : 
profitAmount                   : 
remarks                        : 
source                         : 
invoiceForWhom                 : 
status                         : 
lifeCycle                      : 
issueDate                      : 
sector                         : 
pnr                            : 
airlines                       : 
airlineOid                     : 
customerOid                    : 
supplierOid                    : 
invoiceCloneOid                : 
companyOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
*/
create table                   TicketInvoice
(
oid                            varchar(128)                                                not null,
invoiceNo                      varchar(64)                                                 not null,
invoiceDate                    date,
emailSubject                   text,
serviceCharge                  numeric(20,2)                                                              default 0,
totalServiceCharge             numeric(20,2)                                                              default 0,
companyServiceCharge           numeric(20,2)                                                              default 0,
totalCompanyServiceCharge      numeric(20,2)                                                              default 0,
commissionType                 varchar(8),
commissionValue                numeric(20,2)                                                              default 0,
totalCommission                numeric(10,2)                                                              default 0,
totalExtCommission             numeric(10,2)                                                              default 0,
purchasePrice                  numeric(10,2)                                                              default 0,
incentiveAmount                numeric(10,2)                                                              default 0,
netPurchasePrice               numeric(10,2)                                                              default 0,
salesPrice                     numeric(10,2)                                                              default 0,
discountAmount                 numeric(10,2)                                                              default 0,
netSalesPrice                  numeric(10,2)                                                              default 0,
customerActualPanaltyAmount    numeric(10,2)                                                              default 0,
customerPanaltyAmount          numeric(10,2)                                                              default 0,
customerRefundAmount           numeric(10,2)                                                              default 0,
customerAdditionalServiceAmount numeric(10,2)                                                              default 0,
customerAdcAmount              numeric(10,2)                                                              default 0,
vendorActualPanaltyAmount      numeric(10,2)                                                              default 0,
vendorPanaltyAmount            numeric(10,2)                                                              default 0,
vendorRefundAmount             numeric(10,2)                                                              default 0,
vendorAdditionalServiceAmount  numeric(10,2)                                                              default 0,
vendorAdcAmount                numeric(10,2)                                                              default 0,
payableAmount                  numeric(10,2)                                                              default 0,
receivableAmount               numeric(10,2)                                                              default 0,
additionalProfitAmount         numeric(10,2)                                                              default 0,
profitAmount                   numeric(10,2)                                                              default 0,
remarks                        text,
source                         varchar(32)                                                 not null       default 'Ticket',
invoiceForWhom                 varchar(32),
status                         varchar(32)                                                 not null,
lifeCycle                      varchar(32)                                                                default 'Ongoing',
issueDate                      date,
sector                         varchar(128),
pnr                            varchar(32),
airlines                       varchar(128),
airlineOid                     varchar(128),
customerOid                    varchar(128),
supplierOid                    varchar(128),
invoiceCloneOid                varchar(128),
companyOid                     varchar(128)                                                not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
constraint                     pk_TicketInvoice                                            primary key    (oid),
constraint                     uk_invoiceNo_TicketInvoice                                  unique         (invoiceNo),
constraint                     ck_commissionType_TicketInvoice                             check          (commissionType = 'Pct' or commissionType = 'Fixed'),
constraint                     ck_source_TicketInvoice                                     check          (source = 'Ticket' or source = 'ReIssueTicket' or source = 'Miscellaneouses'),
constraint                     ck_invoiceForWhom_TicketInvoice                             check          (invoiceForWhom = 'Customer' or invoiceForWhom = 'Supplier' or invoiceForWhom = 'Both'),
constraint                     ck_status_TicketInvoice                                     check          (status = 'Draft' or status = 'Active'),
constraint                     ck_lifeCycle_TicketInvoice                                  check          (lifeCycle = 'Ongoing' or lifeCycle = 'Completed'),
constraint                     fk_airlineOid_TicketInvoice                                 foreign key    (airlineOid)
                                                                                           references     Airline(oid),
constraint                     fk_customerOid_TicketInvoice                                foreign key    (customerOid)
                                                                                           references     Customer(oid),
constraint                     fk_supplierOid_TicketInvoice                                foreign key    (supplierOid)
                                                                                           references     Supplier(oid),
constraint                     fk_companyOid_TicketInvoice                                 foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
ticketNo                       : 
issueDate                      : 
airlineOid                     : 
airlines                       : 
sector                         : 
pnr                            : 
paxName                        : 
ticketType                     : Selection box in UI
passengerType                  : Selection box in UI
totalValue                     : 
baseValue                      : 
taxType                        : Selection box in UI
taxValue                       : 
taxAmount                      : 
isAitApplicable                : 
aitBaseValue                   : 
aitAmount                      : 
commissionType                 : Selection box in UI
commissionValue                : 
commissionAmount               : 
extCommissionType              : Selection box in UI
extCommissionValue             : 
extCommissionAmount            : 
serviceCharge                  : 
companyServiceCharge           : 
purchasePrice                  : 
incentiveAmount                : 
netPurchasePrice               : 
salesPrice                     : 
discountValue                  : 
discountAmount                 : 
netSalesPrice                  : 
customerActualPanaltyAmount    : Airlines Penalty Amount
customerPanaltyAmount          : Company Penalty Amount
customerRefundAmount           : 
customerAdditionalServiceAmount : 
customerAdcAmount              : 
vendorActualPanaltyAmount      : Airlines Penalty Amount
vendorPanaltyAmount            : Company Penalty Amount
vendorRefundAmount             : 
vendorAdditionalServiceAmount  : 
vendorAdcAmount                : 
payableAmount                  : 
receivableAmount               : 
additionalProfitAmount         : 
profitAmount                   : 
remarks                        : 
status                         : 
customerStatusChange           : 
vendorStatusChange             : 
sortOrder                      : 
cloneOid                       : 
ticketCloneOid                 : 
passportOid                    : 
ticketInvoiceOid               : 
departureCardOid               : 
companyOid                     : 
*/
create table                   Ticket
(
oid                            varchar(128)                                                not null,
ticketNo                       varchar(128),
issueDate                      date,
airlineOid                     varchar(128),
airlines                       varchar(128),
sector                         varchar(128),
pnr                            varchar(32),
paxName                        varchar(128),
ticketType                     varchar(64),
passengerType                  varchar(64),
totalValue                     numeric(10,2)                                                              default 0,
baseValue                      numeric(10,2)                                                              default 0,
taxType                        varchar(32),
taxValue                       numeric(10,2)                                                              default 0,
taxAmount                      numeric(10,2)                                                              default 0,
isAitApplicable                varchar(32)                                                                default 'true',
aitBaseValue                   numeric(10,2)                                                              default 0,
aitAmount                      numeric(10,2)                                                              default 0,
commissionType                 varchar(8),
commissionValue                numeric(20,2)                                                              default 0,
commissionAmount               numeric(10,2)                                                              default 0,
extCommissionType              varchar(8),
extCommissionValue             numeric(20,2)                                                              default 0,
extCommissionAmount            numeric(10,2)                                                              default 0,
serviceCharge                  numeric(20,2)                                                              default 0,
companyServiceCharge           numeric(20,2)                                                              default 0,
purchasePrice                  numeric(10,2)                                                              default 0,
incentiveAmount                numeric(10,2)                                                              default 0,
netPurchasePrice               numeric(10,2)                                                              default 0,
salesPrice                     numeric(10,2)                                                              default 0,
discountValue                  numeric(20,2)                                                              default 0,
discountAmount                 numeric(10,2)                                                              default 0,
netSalesPrice                  numeric(10,2)                                                              default 0,
customerActualPanaltyAmount    numeric(10,2)                                                              default 0,
customerPanaltyAmount          numeric(10,2)                                                              default 0,
customerRefundAmount           numeric(10,2)                                                              default 0,
customerAdditionalServiceAmount numeric(10,2)                                                              default 0,
customerAdcAmount              numeric(10,2)                                                              default 0,
vendorActualPanaltyAmount      numeric(10,2)                                                              default 0,
vendorPanaltyAmount            numeric(10,2)                                                              default 0,
vendorRefundAmount             numeric(10,2)                                                              default 0,
vendorAdditionalServiceAmount  numeric(10,2)                                                              default 0,
vendorAdcAmount                numeric(10,2)                                                              default 0,
payableAmount                  numeric(10,2)                                                              default 0,
receivableAmount               numeric(10,2)                                                              default 0,
additionalProfitAmount         numeric(10,2)                                                              default 0,
profitAmount                   numeric(10,2)                                                              default 0,
remarks                        text,
status                         varchar(32)                                                 not null       default 'Issue',
customerStatusChange           varchar(32)                                                                default 'false',
vendorStatusChange             varchar(32)                                                                default 'false',
sortOrder                      numeric(5,0)                                                not null,
cloneOid                       varchar(64),
ticketCloneOid                 varchar(64),
passportOid                    varchar(64),
ticketInvoiceOid               varchar(64)                                                 not null,
departureCardOid               varchar(64),
companyOid                     varchar(64)                                                 not null,
constraint                     pk_Ticket                                                   primary key    (oid),
constraint                     fk_airlineOid_Ticket                                        foreign key    (airlineOid)
                                                                                           references     Airline(oid),
constraint                     ck_ticketType_Ticket                                        check          (ticketType = 'One Way' or ticketType = 'Return' or ticketType = 'Multiple'),
constraint                     ck_passengerType_Ticket                                     check          (passengerType = 'Adult' or passengerType = 'Infant' or passengerType = 'Child'),
constraint                     ck_taxType_Ticket                                           check          (taxType = 'Pct' or taxType = 'Fixed'),
constraint                     ck_isAitApplicable_Ticket                                   check          (isAitApplicable = 'true' or isAitApplicable = 'false'),
constraint                     ck_commissionType_Ticket                                    check          (commissionType = 'Pct' or commissionType = 'Fixed'),
constraint                     ck_extCommissionType_Ticket                                 check          (extCommissionType = 'Pct' or extCommissionType = 'Fixed'),
constraint                     ck_status_Ticket                                            check          (status = 'Draft' or status = 'Issue' or status = 'Re-Issue' or status = 'Void' or status = 'Refund'),
constraint                     ck_customerStatusChange_Ticket                              check          (customerStatusChange = 'true' or customerStatusChange = 'false'),
constraint                     ck_vendorStatusChange_Ticket                                check          (vendorStatusChange = 'true' or vendorStatusChange = 'false'),
constraint                     fk_passportOid_Ticket                                       foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_ticketInvoiceOid_Ticket                                  foreign key    (ticketInvoiceOid)
                                                                                           references     TicketInvoice(oid),
constraint                     fk_companyOid_Ticket                                        foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
taxCode                        : 
taxAmount                      : 
ticketOid                      : 
ticketInvoiceOid               : 
companyOid                     : 
*/
create table                   Tax
(
oid                            varchar(64)                                                 not null,
taxCode                        varchar(16),
taxAmount                      numeric(10,2)                                                              default 0,
ticketOid                      varchar(64)                                                 not null,
ticketInvoiceOid               varchar(64)                                                 not null,
companyOid                     varchar(64)                                                 not null,
constraint                     pk_Tax                                                      primary key    (oid),
constraint                     fk_ticketOid_Tax                                            foreign key    (ticketOid)
                                                                                           references     Ticket(oid),
constraint                     fk_ticketInvoiceOid_Tax                                     foreign key    (ticketInvoiceOid)
                                                                                           references     TicketInvoice(oid),
constraint                     fk_companyOid_Tax                                           foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
flightNo                       : 
bag                            : 
ticketClass                    : Selection box in UI
ticketClassType                : Text box in UI
departureTerminal              : Text box in UI
arrivalTerminal                : Text box in UI
terminal                       : Text box in UI
departure                      : 
arrival                        : 
departureDateTime              : 
arrivalDateTime                : 
durationInHour                 : 
durationInMinute               : 
status                         : 
additionalService              : 
vendorAdditionalServiceAmount  : 
customerAdditionalServiceAmount : 
sortOrder                      : 
airportOid                     : 
ticketOid                      : 
ticketInvoiceOid               : 
companyOid                     : 
*/
create table                   Route
(
oid                            varchar(64)                                                 not null,
flightNo                       varchar(16),
bag                            varchar(16),
ticketClass                    varchar(64),
ticketClassType                varchar(64),
departureTerminal              varchar(32),
arrivalTerminal                varchar(32),
terminal                       varchar(32),
departure                      varchar(128),
arrival                        varchar(128),
departureDateTime              timestamp,
arrivalDateTime                timestamp,
durationInHour                 numeric(5,0)                                                               default 0,
durationInMinute               numeric(5,0)                                                               default 0,
status                         varchar(32)                                                 not null       default 'Issue',
additionalService              text,
vendorAdditionalServiceAmount  numeric(10,2)                                                              default 0,
customerAdditionalServiceAmount numeric(10,2)                                                              default 0,
sortOrder                      numeric(5,0)                                                not null,
airportOid                     varchar(64),
ticketOid                      varchar(64)                                                 not null,
ticketInvoiceOid               varchar(64)                                                 not null,
companyOid                     varchar(64)                                                 not null,
constraint                     pk_Route                                                    primary key    (oid),
constraint                     ck_ticketClass_Route                                        check          (ticketClass = 'Premium Economy' or ticketClass = 'Economy' or ticketClass = 'Business' or ticketClass = 'First Class' or ticketClass = 'Others'),
constraint                     fk_airportOid_Route                                         foreign key    (airportOid)
                                                                                           references     Airport(oid),
constraint                     fk_ticketOid_Route                                          foreign key    (ticketOid)
                                                                                           references     Ticket(oid),
constraint                     fk_ticketInvoiceOid_Route                                   foreign key    (ticketInvoiceOid)
                                                                                           references     TicketInvoice(oid),
constraint                     fk_companyOid_Route                                         foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
passengerName                  : 
gender                         : 
birthDate                      : 
nationality                    : 
passportNumber                 : 
passportExpiryDate             : 
flightNumber                   : 
departureDate                  : 
addressForForeigners           : 
visaNumber                     : 
visaExpiryDate                 : 
visaType                       : 
purposeOfVisit                 : 
companyOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
editedBy                       : Who last update
editedOn                       : When it was updated
*/
create table                   DepartureCard
(
oid                            varchar(64)                                                 not null,
passengerName                  varchar(128),
gender                         varchar(16),
birthDate                      date,
nationality                    varchar(64),
passportNumber                 varchar(32),
passportExpiryDate             date,
flightNumber                   varchar(64),
departureDate                  date,
addressForForeigners           text,
visaNumber                     varchar(64),
visaExpiryDate                 date,
visaType                       varchar(64),
purposeOfVisit                 text,
companyOid                     varchar(64)                                                 not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
editedBy                       varchar(128),
editedOn                       timestamp,
constraint                     pk_DepartureCard                                            primary key    (oid),
constraint                     fk_companyOid_DepartureCard                                 foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*

oid                            : Surrogate primary key
invoiceLogDate                 : 
netPurchasePrice               : 
netSalesPrice                  : 
customerActualPanaltyAmount    : Airlines Penalty Amount
customerPanaltyAmount          : Company Penalty Amount
customerRefundAmount           : 
customerAdditionalServiceAmount : 
vendorActualPanaltyAmount      : Airlines Penalty Amount
vendorPanaltyAmount            : Company Penalty Amount
vendorRefundAmount             : 
vendorAdditionalServiceAmount  : 
payableAmount                  : 
receivableAmount               : 
profitAmount                   : 
presentNetPurchasePrice        : 
presentNetSalesPrice           : 
presentCustomerActualPanaltyAmount : Airlines Penalty Amount
presentCustomerPanaltyAmount   : Company Penalty Amount
presentCustomerRefundAmount    : 
presentCustomerAdditionalServiceAmount : 
presentVendorActualPanaltyAmount : Airlines Penalty Amount
presentVendorPanaltyAmount     : Company Penalty Amount
presentVendorRefundAmount      : 
presentVendorAdditionalServiceAmount : 
presentPayableAmount           : 
presentReceivableAmount        : 
presentProfitAmount            : 
type                           : Update: Generally update. Modification: Ticket Void, Refund, Re-Issue etc.
lifeCycle                      : 
remarks                        : 
ticketInvoiceOid               : 
customerOid                    : 
supplierOid                    : 
companyOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
*/
create table                   TicketInvoiceLog
(
oid                            varchar(128)                                                not null,
invoiceLogDate                 date,
netPurchasePrice               numeric(10,2)                                                              default 0,
netSalesPrice                  numeric(10,2)                                                              default 0,
customerActualPanaltyAmount    numeric(10,2)                                                              default 0,
customerPanaltyAmount          numeric(10,2)                                                              default 0,
customerRefundAmount           numeric(10,2)                                                              default 0,
customerAdditionalServiceAmount numeric(10,2)                                                              default 0,
vendorActualPanaltyAmount      numeric(10,2)                                                              default 0,
vendorPanaltyAmount            numeric(10,2)                                                              default 0,
vendorRefundAmount             numeric(10,2)                                                              default 0,
vendorAdditionalServiceAmount  numeric(10,2)                                                              default 0,
payableAmount                  numeric(10,2)                                                              default 0,
receivableAmount               numeric(10,2)                                                              default 0,
profitAmount                   numeric(10,2)                                                              default 0,
presentNetPurchasePrice        numeric(10,2)                                                              default 0,
presentNetSalesPrice           numeric(10,2)                                                              default 0,
presentCustomerActualPanaltyAmount numeric(10,2)                                                              default 0,
presentCustomerPanaltyAmount   numeric(10,2)                                                              default 0,
presentCustomerRefundAmount    numeric(10,2)                                                              default 0,
presentCustomerAdditionalServiceAmount numeric(10,2)                                                              default 0,
presentVendorActualPanaltyAmount numeric(10,2)                                                              default 0,
presentVendorPanaltyAmount     numeric(10,2)                                                              default 0,
presentVendorRefundAmount      numeric(10,2)                                                              default 0,
presentVendorAdditionalServiceAmount numeric(10,2)                                                              default 0,
presentPayableAmount           numeric(10,2)                                                              default 0,
presentReceivableAmount        numeric(10,2)                                                              default 0,
presentProfitAmount            numeric(10,2)                                                              default 0,
type                           varchar(32),
lifeCycle                      varchar(32)                                                                default 'Ongoing',
remarks                        text,
ticketInvoiceOid               varchar(64)                                                 not null,
customerOid                    varchar(128),
supplierOid                    varchar(128),
companyOid                     varchar(128)                                                not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_TicketInvoiceLog                                         primary key    (oid),
constraint                     ck_type_TicketInvoiceLog                                    check          (type = 'Update' or type = 'Modification'),
constraint                     ck_lifeCycle_TicketInvoiceLog                               check          (lifeCycle = 'Ongoing' or lifeCycle = 'Completed'),
constraint                     fk_ticketInvoiceOid_TicketInvoiceLog                        foreign key    (ticketInvoiceOid)
                                                                                           references     TicketInvoice(oid),
constraint                     fk_customerOid_TicketInvoiceLog                             foreign key    (customerOid)
                                                                                           references     Customer(oid),
constraint                     fk_supplierOid_TicketInvoiceLog                             foreign key    (supplierOid)
                                                                                           references     Supplier(oid),
constraint                     fk_companyOid_TicketInvoiceLog                              foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*

oid                            : Surrogate primary key
netPurchasePrice               : 
netSalesPrice                  : 
customerActualPanaltyAmount    : Airlines Penalty Amount
customerPanaltyAmount          : Company Penalty Amount
customerRefundAmount           : 
customerAdditionalServiceAmount : 
vendorActualPanaltyAmount      : Airlines Penalty Amount
vendorPanaltyAmount            : Company Penalty Amount
vendorRefundAmount             : 
vendorAdditionalServiceAmount  : 
payableAmount                  : 
receivableAmount               : 
profitAmount                   : 
presentNetPurchasePrice        : 
presentNetSalesPrice           : 
presentCustomerActualPanaltyAmount : Airlines Penalty Amount
presentCustomerPanaltyAmount   : Company Penalty Amount
presentCustomerRefundAmount    : 
presentCustomerAdditionalServiceAmount : 
presentVendorActualPanaltyAmount : Airlines Penalty Amount
presentVendorPanaltyAmount     : Company Penalty Amount
presentVendorRefundAmount      : 
presentVendorAdditionalServiceAmount : 
presentPayableAmount           : 
presentReceivableAmount        : 
presentProfitAmount            : 
status                         : 
remarks                        : 
ticketInvoiceLogOid            : 
ticketInvoiceOid               : 
ticketCloneOid                 : 
companyOid                     : 
createdBy                      : Who created, default is System
createdOn                      : when it was created
*/
create table                   TicketLog
(
oid                            varchar(128)                                                not null,
netPurchasePrice               numeric(10,2)                                                              default 0,
netSalesPrice                  numeric(10,2)                                                              default 0,
customerActualPanaltyAmount    numeric(10,2)                                                              default 0,
customerPanaltyAmount          numeric(10,2)                                                              default 0,
customerRefundAmount           numeric(10,2)                                                              default 0,
customerAdditionalServiceAmount numeric(10,2)                                                              default 0,
vendorActualPanaltyAmount      numeric(10,2)                                                              default 0,
vendorPanaltyAmount            numeric(10,2)                                                              default 0,
vendorRefundAmount             numeric(10,2)                                                              default 0,
vendorAdditionalServiceAmount  numeric(10,2)                                                              default 0,
payableAmount                  numeric(10,2)                                                              default 0,
receivableAmount               numeric(10,2)                                                              default 0,
profitAmount                   numeric(10,2)                                                              default 0,
presentNetPurchasePrice        numeric(10,2)                                                              default 0,
presentNetSalesPrice           numeric(10,2)                                                              default 0,
presentCustomerActualPanaltyAmount numeric(10,2)                                                              default 0,
presentCustomerPanaltyAmount   numeric(10,2)                                                              default 0,
presentCustomerRefundAmount    numeric(10,2)                                                              default 0,
presentCustomerAdditionalServiceAmount numeric(10,2)                                                              default 0,
presentVendorActualPanaltyAmount numeric(10,2)                                                              default 0,
presentVendorPanaltyAmount     numeric(10,2)                                                              default 0,
presentVendorRefundAmount      numeric(10,2)                                                              default 0,
presentVendorAdditionalServiceAmount numeric(10,2)                                                              default 0,
presentPayableAmount           numeric(10,2)                                                              default 0,
presentReceivableAmount        numeric(10,2)                                                              default 0,
presentProfitAmount            numeric(10,2)                                                              default 0,
status                         varchar(32)                                                 not null       default 'Issue',
remarks                        text,
ticketInvoiceLogOid            varchar(64)                                                 not null,
ticketInvoiceOid               varchar(64)                                                 not null,
ticketCloneOid                 varchar(64)                                                 not null,
companyOid                     varchar(128)                                                not null,
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_TicketLog                                                primary key    (oid),
constraint                     ck_status_TicketLog                                         check          (status = 'Draft' or status = 'Issue' or status = 'Re-Issue' or status = 'Void' or status = 'Refund'),
constraint                     fk_ticketInvoiceLogOid_TicketLog                            foreign key    (ticketInvoiceLogOid)
                                                                                           references     TicketInvoiceLog(oid),
constraint                     fk_ticketInvoiceOid_TicketLog                               foreign key    (ticketInvoiceOid)
                                                                                           references     TicketInvoice(oid),
constraint                     fk_companyOid_TicketLog                                     foreign key    (companyOid)
                                                                                           references     Company(oid)
);



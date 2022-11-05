--By Liton @ 16-Jun-2019 17:00
alter	table	customer 	add discountType                   varchar(8);
alter	table	customer 	add discountValue	               numeric(20,2)		default 0;
alter	table	Supplier 	add imagePath                      varchar(256);
alter	table	Customer 	add imagePath                      varchar(256);
alter	table	Payment 	add imagePath                      varchar(256);

--By Liton @ 19-Jun-2019 13:00
alter	table	Supplier 	add commissionType                 varchar(8);
alter	table	Supplier 	add commissionValue                numeric(20,2)		default 0;
alter	table	Supplier 	add serviceCharge                  numeric(20,2)		default 0;

--By Liton @ 24-Jun-2019 16:30
alter	table	Supplier 	add customerId                 	   varchar(128);

--By Liton @ 27-Jun-2019 17:00
alter	table	Ticket 	add departureCardOid                   varchar(128);

--By Liton @ 02-Jul-2019 21:30
alter table payment alter accountOid drop not null, alter paymentType drop not null;

--By Liton @ 28-Jul-2019 17:00
alter	table	TicketInvoice	add companyServiceCharge        numeric(20,2) 		default 0;
alter	table	TicketInvoice	add totalCompanyServiceCharge   numeric(20,2) 		default 0;
alter	table	Ticket 			add companyServiceCharge        numeric(20,2) 		default 0;

--By Liton @ 05-Aug-2019 15:00
alter	table	Ticket 			add totalValue			        numeric(10,2) 		default 0;
alter	table	Ticket 			add aitBaseValue                numeric(10,2)       default 0;

--By Liton @ 27-Aug-2019 18:00
alter	table	TicketInvoice	add totalExtCommission	        numeric(10,2) 		default 0;
alter	table	Ticket 			add extCommissionType           varchar(8);
alter	table	Ticket 			add extCommissionValue	        numeric(10,2) 		default 0;
alter	table	Ticket 			add extCommissionAmount	        numeric(10,2) 		default 0;

--By Liton @ 19-Sep-2019 18:50
alter	table	Passport		add mobileNo                    varchar(128);

--By Liton @ 08-Oct-2019 16:50
alter	table	Company			add website                   	varchar(128);
alter	table	Company			add telephone                   varchar(128);
alter	table	Company			add contactNo                   varchar(128);
alter	table	Company			add hotlineNumber               varchar(64);
alter	table	Customer		add customerId                  varchar(64);

--By Liton @ 12-Oct-2019 17:30
alter	table	Payment			add chequeIssueDate                date;
alter	table	Payment			add accountHolderName              varchar(128);
alter	table	Payment			add bankAccountNo                  varchar(32);
alter	table	Payment			add bankName                       varchar(128);
alter	table	Payment			add branchName                     varchar(128);
alter	table	Payment			add paymentMode                    varchar(32)       default 'Cash';
alter	table	Payment			add referenceBy                    varchar(128);
alter	table	Payment			add referenceByMobileNo            varchar(128);
alter	table	Payment			add receivedBy                     varchar(128);
alter	table	Payment			add constraint ck_paymentMode_Payment     check  (paymentMode = 'Cheque' or paymentMode = 'BankDeposit' or paymentMode = 'Cash' or paymentMode = 'CreditCard');
alter	table	Payment			add constraint fk_receivedBy_Payment      foreign key    (receivedBy) references     People(oid);

--By Liton @ 13-Oct-2019 22:20
alter	table	TicketInvoice	add lifeCycle                      varchar(32)       default 'Ongoing';

--By Liton @ 14-Oct-2019 19:00
alter	table	TicketInvoice	add incentiveAmount                numeric(10,2)     default 0;
alter	table	TicketInvoice	add netPurchasePrice               numeric(10,2)     default 0;
alter	table	Ticket      	add incentiveAmount                numeric(10,2)     default 0;
alter	table	Ticket      	add netPurchasePrice               numeric(10,2)     default 0;

alter	table	TicketInvoice	add customerPanaltyAmount          numeric(10,2)    default 0;
alter	table	TicketInvoice	add customerRefundAmount           numeric(10,2)    default 0;
alter	table	TicketInvoice	add vendorPanaltyAmount            numeric(10,2)    default 0;
alter	table	TicketInvoice	add vendorRefundAmount             numeric(10,2)    default 0;
alter	table	Ticket      	add customerPanaltyAmount          numeric(10,2)    default 0;
alter	table	Ticket      	add customerRefundAmount           numeric(10,2)    default 0;
alter	table	Ticket      	add vendorPanaltyAmount            numeric(10,2)    default 0;
alter	table	Ticket      	add vendorRefundAmount             numeric(10,2)    default 0;
alter	table	TicketInvoice	add profitAmount                   numeric(10,2)    default 0;
alter	table	Ticket      	add profitAmount                   numeric(10,2)    default 0;

alter	table	TicketInvoice	add payableAmount                  numeric(10,2)    default 0;
alter	table	TicketInvoice   add receivableAmount               numeric(10,2)    default 0;
alter	table	Ticket      	add payableAmount                  numeric(10,2)    default 0;
alter	table	Ticket      	add receivableAmount               numeric(10,2)    default 0;

--By Liton @ 31-Oct-2019 16:00
alter	table	Ticket      	add cloneOid                       varchar(64);

--By Liton @ 03-Nov-2019 18:00
alter	table	Company      	add packageOid                     varchar(128);
-- First Insert Package Table. R01_00_01__meta.sql
alter	table	Company      	add constraint        fk_packageOid_Company  foreign key    (packageOid)     references     Package(oid);

--By Liton @ 04-Nov-2019 16:00
alter	table	People      	add peopleType                     varchar(32);
alter	table	People      	add status                         varchar(32)       default 'Active';
alter	table	People      	add constraint ck_status_People    check             (status = 'Active' or status = 'Inactive');
alter	table	Supplier      	add status                         varchar(32)       default 'Active';
alter	table	Supplier      	add constraint ck_status_Supplier  check             (status = 'Active' or status = 'Inactive');
alter	table	Customer      	add status                         varchar(32)       default 'Active';
alter	table	Customer      	add constraint ck_status_Customer  check             (status = 'Active' or status = 'Inactive');
alter	table	Login      	    add referenceOid                   varchar(128);
alter	table	Login      	    add referenceType                  varchar(32);
alter	table	Login      	    add constraint ck_referenceType_Login    check   (referenceType = 'Supplier' or referenceType = 'Customer' or referenceType = 'People');
alter	table	Payment      	add entryType                      varchar(32)       default 'Manual';
alter	table	Payment      	add constraint ck_entryType_Payment check          (entryType = 'Manual' or entryType = 'Auto');

--By Liton @ 17-Nov-2019 19:20
alter	table	Payment         DROP CONSTRAINT ck_paymentNature_Payment;
alter	table	Payment      	add constraint                     ck_paymentNature_Payment                                    check          (paymentNature = 'CreditNote' or paymentNature = 'Withdraw' or paymentNature = 'CashWithdraw' or paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment');

-- Live Insert done

--By Liton @ 28-Jan-2020 15:55
create table                   Country
(
oid                            varchar(128)                                                not null,
name                           text                                                        not null,
capital                        varchar(128),
isoCodeAlphaTwo                varchar(16),
isoCodeAlphaThree              varchar(16),
countryCode                    varchar(32),
dialingCode                    varchar(32),
createdBy                      varchar(128)                                                not null       default 'System',
createdOn                      timestamp                                                   not null       default current_timestamp,
constraint                     pk_Country                                                  primary key    (oid)
);
alter	table	Passport      	add countryOid                     varchar(128);
alter	table	Passport      	add constraint    fk_countryOid_Passport  foreign key    (countryOid) references     Country(oid);
create table                   PassportCommand
(
oid                            varchar(128)                                                not null,
title                          varchar(128),
command                        text,
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassportCommand                                          primary key    (oid),
constraint                     fk_passportOid_PassportCommand                              foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassportCommand                               foreign key    (companyOid)
                                                                                           references     Company(oid)
);

--By Liton @ 03-Feb-2020 14:10
alter	table	DraftTicket     add     status              varchar(32)                 not null       default 'Draft';
alter	table	DraftTicket     add     ticketCloneOid      varchar(64);
alter	table	DraftTicket     add     editedBy            varchar(128);
alter	table	DraftTicket     add     editedOn            timestamp;
alter	table	DraftTicket     add     constraint          ck_status_DraftTicket       check          (status = 'Draft' or status = 'Active');

--By Liton @ 21-Mar-2020 19:00
ALTER TABLE passport ALTER COLUMN passportimagepath DROP DEFAULT;
update passport set passportImagePath = null;
alter	table	passport     add     email   varchar(128);

--By Liton @ 23-Apr-2020 19:00
alter	table	TicketInvoice	add customerActualPanaltyAmount               numeric(10,2)    default 0;
alter	table	TicketInvoice	add vendorActualPanaltyAmount                 numeric(10,2)    default 0;
alter	table	TicketInvoice	add customerAdditionalServiceAmount           numeric(10,2)    default 0;
alter	table	Ticket      	add vendorAdditionalServiceAmount             numeric(10,2)    default 0;

alter	table	Ticket      	add customerActualPanaltyAmount               numeric(10,2)    default 0;
alter	table	Ticket      	add vendorActualPanaltyAmount                 numeric(10,2)    default 0;
alter	table	Ticket      	add customerAdditionalServiceAmount           numeric(10,2)    default 0;
alter	table	Ticket      	add vendorAdditionalServiceAmount             numeric(10,2)    default 0;

alter	table	Route      	add additionalService                         text;
alter	table	Route      	add customerAdditionalServiceAmount           numeric(10,2)    default 0;
alter	table	Route      	add vendorAdditionalServiceAmount             numeric(10,2)    default 0;

--By Liton @ 16-Sep-2020 15:30
alter	table	Supplier      	add supplierType                              varchar(64)      default 'Vendor';
alter	table	Supplier        add constraint  ck_supplierType_Supplier      check            (supplierType = 'Vendor' or supplierType = 'Airlines');

--By Liton @ 28-Sep-2020 16:50
alter	table	TicketInvoice   add source      varchar(32)     not null      default 'Ticket';
alter	table	TicketInvoice   add constraint  ck_source_TicketInvoice       check  (source = 'Ticket' or source = 'ReIssueTicket');


--By Liton @ 05-Oct-2020 19:30
alter	table	TicketInvoice   add customerAdcAmount           numeric(10,2)    default 0;
alter	table	TicketInvoice   add vendorAdcAmount             numeric(10,2)    default 0;
alter	table	Ticket          add customerAdcAmount           numeric(10,2)    default 0;
alter	table	Ticket          add vendorAdcAmount             numeric(10,2)    default 0;
alter	table	Ticket          add customerStatusChange        varchar(32)      default 'false';
alter	table	Ticket          add vendorStatusChange          varchar(32)      default 'false';
alter	table	Ticket          add constraint  ck_customerStatusChange_Ticket   check   (customerStatusChange = 'true' or customerStatusChange = 'false');
alter	table	Ticket          add constraint  ck_vendorStatusChange_Ticket     check   (vendorStatusChange = 'true' or vendorStatusChange = 'false');


--By Liton @ 25-Oct-2020 10:30
alter	table	TicketInvoice   add invoiceCloneOid             varchar(128);

--By Liton @ 28-Oct-2020 02:15
alter	table	Ticket          add ticketCloneOid                 varchar(64);

--By Liton @ 31-Oct-2020 23:00
alter	table	Payment         DROP CONSTRAINT ck_paymentMode_Payment;
alter	table	Payment      	add  constraint ck_paymentMode_Payment  check (paymentMode = 'Cheque' or paymentMode = 'BankDeposit' or paymentMode = 'Cash' or paymentMode = 'CreditCard' or paymentMode = 'CreditNote');

--By Liton @ 28-Nov-2020 15:00
alter	table	TicketInvoice   DROP CONSTRAINT ck_source_TicketInvoice;
alter	table	TicketInvoice   add  constraint ck_source_TicketInvoice check (source = 'Ticket' or source = 'ReIssueTicket' or source = 'Miscellaneouses');
alter	table	Ticket      	add  remarks   text;

update Role set menuJson = '[{"id":"dashboard","url":"dashboard","text":"Dashboard","enable":true,"class":"fa fa-dashboard"},{"id":"tickets","url":"tickets","text":"Tickets","class":"fa fa-ticket","enable":true,"children":[{"id":"draft_tickets","url":"draft/tickets","text":"Drafts","class":"fa fa-ticket","enable":true},{"id":"tickets","url":"tickets","text":"Tickets","class":"fa fa-ticket","enable":true},{"id":"ticketsmodification","url":"ticketsmodification","text":"Modification","class":"fa fa-eraser","enable":true}]},{"id":"customer","url":"customers","text":"Customer","class":"fa fa-user","enable":true,"children":[{"id":"customer","url":"customers","text":"Customers","class":"fa fa-user","enable":true},{"id":"passport","url":"passports","text":"Passports","class":"fa fa-columns","enable":true},{"id":"invoices","url":"invoices","text":"Invoices","class":"fa fa-italic","enable":true},{"id":"miscellaneouseslist","url":"miscellaneouseslist","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"paymentreceiveds","url":"paymentreceiveds","text":"Payment Receiveds","class":"fa fa-money","enable":true},{"id":"creditnotes","url":"creditnotes","text":"Credit Notes","class":"fa fa-shopping-cart","enable":true},{"id":"customerwithdraws","url":"customerwithdraws","text":"Customer Withdraws","class":"fa fa-pencil","enable":true}]},{"id":"supplier","url":"suppliers","text":"Vendor","enable":true,"class":"fa fa-male","children":[{"id":"supplier","url":"suppliers","text":"Vendors","class":"fa fa-male","enable":true},{"id":"bills","url":"bills","text":"Bills","class":"fa fa-sticky-note-o","enable":true},{"id":"paymentmades","url":"paymentmades","text":"Payment Made","class":"fa fa-tags","enable":true},{"id":"vendorcredits","url":"vendorcredits","text":"Vendor Credits","class":"fa fa-rocket","enable":true},{"id":"vendorwithdraws","url":"vendorwithdraws","text":"Vendor Withdraws","class":"fa fa-plus","enable":true}]},{"id":"expense","url":"expense","text":"Expense","enable":true,"class":"fa fa-sign-out"},{"id":"account","url":"accounts","text":"Account","class":"fa fa-font","enable":true,"children":[{"id":"account","url":"accounts","text":"Accounts","class":"fa fa-font","enable":true},{"id":"transactions","url":"transactions","text":"Transactions","class":"fa fa-suitcase","enable":true}]},{"id":"report","url":"report","text":"Report","class":"fa fa-bar-chart-o","enable":true},{"id":"calculator","url":"calculator","text":"Calculator","class":"fa fa-calculator","enable":true},{"id":"office","url":"office","text":"Office","enable":true,"class":"fa fa-university","children":[{"id":"Employee","url":"employees","text":"Employees","class":"fa fa-users","enable":true},{"id":"departments","url":"departments","text":"Department","class":"fa fa-home","enable":true},{"id":"designations","url":"designations","text":"Designation","class":"fa fa-graduation-cap","enable":true}]},{"id":"payrolls","url":"payrolls","text":"Payroll","class":"fa fa-credit-card","enable":true,"children":[{"id":"payroll","url":"payroll","text":"Payroll","class":"fa fa-credit-card","enable":true}]},{"id":"settings","url":"settings","text":"Setting","enable":true,"class":"fa fa-cogs","children":[{"id":"users","url":"users","text":"User","class":"fa fa-users","enable":true},{"id":"changepassword","url":"change-password","text":"Change Password","class":"fa fa-key","enable":true}]},{"id":"guidelines","url":"guidelines","text":"Guideline","enable":true,"children":[],"class":"fa fa-book"}]' where oid = 'Admin';
update Role set menuJson = '[{"id":"customer-dashboard","url":"customer-dashboard","text":"Dashboard","enable":true,"class":"fa fa-dashboard"},{"id":"customer-profile","url":"customer-profile","text":"Profile","enable":true,"class":"fa fa-user"},{"id":"customer-passport","url":"customer-passports","text":"Passports","class":"fa fa-columns","enable":true},{"id":"customer-tickets","url":"customer-tickets","text":"Tickets","class":"fa fa-ticket","enable":true},{"id":"customer-visa","url":"customer-visa","text":"Visa","class":"fa fa-cc-visa","enable":true},{"id":"customer-invoices","url":"customer-invoices","text":"Invoices","enable":true,"class":"fa fa-italic"},{"id":"miscellaneouseslist","url":"miscellaneouseslist","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"customer-payments","url":"customer-payments","text":"Payments","enable":true,"class":"fa fa-money"},{"id":"customer-creditnotes","url":"customer-creditnotes","text":"Credit Notes","class":"fa fa-shopping-cart","enable":true},{"id":"customer-withdraws","url":"customer-withdraws","text":"Withdraws","class":"fa fa-pencil","enable":true},{"id":"report","url":"report","text":"Report","enable":true,"class":"fa fa-bar-chart-o"},{"id":"settings","url":"settings","text":"Setting","enable":true,"children":[{"id":"changepassword","url":"change-password","text":"Change Password","class":"fa fa-key","enable":true}],"class":"fa fa-cogs"},{"id":"customer-guidelines","url":"customer-guidelines","text":"Guideline","enable":true,"children":[],"class":"fa fa-book"}]' where oid = 'Customer';
-- Live Insert done

--By Liton @ 23-Dec-2020 15:00
alter	table	TicketInvoice   add invoiceForWhom      varchar(32);
alter	table	TicketInvoice   add constraint ck_invoiceForWhom_TicketInvoice     check   (invoiceForWhom = 'Customer' or invoiceForWhom = 'Supplier' or invoiceForWhom = 'Both');


--By Liton @ 09-Jan-2021 13:00
alter	table	Passport   add fullName                 varchar(128);
alter	table	Passport   add birthRegistrationNo      varchar(32);

--By Liton @ 09-Jan-2021 19:00
create table                   PassengerNotification
(
oid                            varchar(128)                                                not null,
name                           varchar(128),
notificationValue              text,
subscribe                      text,
remarks                        text,
sortOrder                      numeric(3,0)                                                not null,
passportOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
constraint                     pk_PassengerNotification                                    primary key    (oid),
constraint                     fk_passportOid_PassengerNotification                        foreign key    (passportOid)
                                                                                           references     Passport(oid),
constraint                     fk_companyOid_PassengerNotification                         foreign key    (companyOid)
                                                                                           references     Company(oid)
);

update Role set menuJson = '[{"id":"dashboard","url":"dashboard","text":"Dashboard","enable":true,"class":"fa fa-dashboard"},{"id":"tickets","url":"tickets","text":"Tickets","class":"fa fa-ticket","enable":true,"children":[{"id":"draft_tickets","url":"draft/tickets","text":"Drafts","class":"fa fa-ticket","enable":true},{"id":"tickets","url":"tickets","text":"Tickets","class":"fa fa-ticket","enable":true},{"id":"ticketsmodification","url":"ticketsmodification","text":"Modification","class":"fa fa-eraser","enable":true}]},{"id":"customer","url":"customers","text":"Customer","class":"fa fa-user","enable":true,"children":[{"id":"customer","url":"customers","text":"Customers","class":"fa fa-user","enable":true},{"id":"passport","url":"passports","text":"Passports","class":"fa fa-columns","enable":true},{"id":"invoices","url":"invoices","text":"Invoices","class":"fa fa-italic","enable":true},{"id":"miscellaneouseslist","url":"miscellaneouseslist","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"paymentreceiveds","url":"paymentreceiveds","text":"Payment Receiveds","class":"fa fa-money","enable":true},{"id":"creditnotes","url":"creditnotes","text":"Credit Notes","class":"fa fa-shopping-cart","enable":true},{"id":"customerwithdraws","url":"customerwithdraws","text":"Customer Withdraws","class":"fa fa-pencil","enable":true}]},{"id":"supplier","url":"suppliers","text":"Vendor","enable":true,"class":"fa fa-male","children":[{"id":"supplier","url":"suppliers","text":"Vendors","class":"fa fa-male","enable":true},{"id":"bills","url":"bills","text":"Bills","class":"fa fa-sticky-note-o","enable":true},{"id":"miscellaneousesbilllist","url":"miscellaneousesbilllist","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"paymentmades","url":"paymentmades","text":"Payment Made","class":"fa fa-tags","enable":true},{"id":"vendorcredits","url":"vendorcredits","text":"Vendor Credits","class":"fa fa-rocket","enable":true},{"id":"vendorwithdraws","url":"vendorwithdraws","text":"Vendor Withdraws","class":"fa fa-plus","enable":true}]},{"id":"expense","url":"expense","text":"Expense","enable":true,"class":"fa fa-sign-out"},{"id":"account","url":"accounts","text":"Account","class":"fa fa-font","enable":true,"children":[{"id":"account","url":"accounts","text":"Accounts","class":"fa fa-font","enable":true},{"id":"transactions","url":"transactions","text":"Transactions","class":"fa fa-suitcase","enable":true}]},{"id":"report","url":"report","text":"Report","class":"fa fa-bar-chart-o","enable":true},{"id":"calculator","url":"calculator","text":"Calculator","class":"fa fa-calculator","enable":true},{"id":"office","url":"office","text":"Office","enable":true,"class":"fa fa-university","children":[{"id":"Employee","url":"employees","text":"Employees","class":"fa fa-users","enable":true},{"id":"departments","url":"departments","text":"Department","class":"fa fa-home","enable":true},{"id":"designations","url":"designations","text":"Designation","class":"fa fa-graduation-cap","enable":true}]},{"id":"payrolls","url":"payrolls","text":"Payroll","class":"fa fa-credit-card","enable":true,"children":[{"id":"payroll","url":"payroll","text":"Payroll","class":"fa fa-credit-card","enable":true}]},{"id":"settings","url":"settings","text":"Setting","enable":true,"class":"fa fa-cogs","children":[{"id":"users","url":"users","text":"User","class":"fa fa-users","enable":true},{"id":"changepassword","url":"change-password","text":"Change Password","class":"fa fa-key","enable":true}]},{"id":"guidelines","url":"guidelines","text":"Guideline","enable":true,"children":[],"class":"fa fa-book"}]'
where oid = 'Admin';
update Role set menuJson = '[{"id":"customer-dashboard","url":"customer-dashboard","text":"Dashboard","enable":true,"class":"fa fa-dashboard"},{"id":"customer-profile","url":"customer-profile","text":"Profile","enable":true,"class":"fa fa-user"},{"id":"customer-passport","url":"customer-passports","text":"Passports","class":"fa fa-columns","enable":true},{"id":"customer-tickets","url":"customer-tickets","text":"Tickets","class":"fa fa-ticket","enable":true},{"id":"customer-visa","url":"customer-visa","text":"Visa","class":"fa fa-cc-visa","enable":true},{"id":"customer-invoices","url":"customer-invoices","text":"Invoices","enable":true,"class":"fa fa-italic"},{"id":"miscellaneouseslist","url":"miscellaneouseslist","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"customer-payments","url":"customer-payments","text":"Payments","enable":true,"class":"fa fa-money"},{"id":"customer-creditnotes","url":"customer-creditnotes","text":"Credit Notes","class":"fa fa-shopping-cart","enable":true},{"id":"customer-withdraws","url":"customer-withdraws","text":"Withdraws","class":"fa fa-pencil","enable":true},{"id":"report","url":"report","text":"Report","enable":true,"class":"fa fa-bar-chart-o"},{"id":"settings","url":"settings","text":"Setting","enable":true,"children":[{"id":"changepassword","url":"change-password","text":"Change Password","class":"fa fa-key","enable":true}],"class":"fa fa-cogs"},{"id":"customer-guidelines","url":"customer-guidelines","text":"Guideline","enable":true,"children":[],"class":"fa fa-book"}]'
where oid = 'Customer';
update Role set menuJson = '[{"id":"supplier-dashboard","url":"supplier-dashboard","text":"Dashboard","enable":true},{"id":"supplier-tickets","url":"supplier-tickets","text":"Tickets","enable":true,"class":"fa fa-ticket"},{"id":"supplier","url":"suppliers","text":"Vendor","class":"fa fa-male","enable":true,"children":[{"id":"supplier-bills","url":"supplier-bills","text":"Bills","class":"fa fa-sticky-note-o","enable":true},{"id":"supplier-miscellaneouses","url":"supplier-miscellaneouses","text":"Miscellaneous","class":"fa fa-tasks","enable":true},{"id":"supplier-paymentmades","url":"supplier-paymentmades","text":"Payment Made","class":"fa fa-tags","enable":true},{"id":"supplier-vendorcredits","url":"supplier-vendorcredits","text":"Vendor Credits","class":"fa fa-rocket","enable":true},{"id":"supplier-vendorwithdraws","url":"supplier-vendorwithdraws","text":"Vendor Withdraws","class":"fa fa-plus","enable":true}]},{"id":"report","url":"report","text":"Report","class":"fa fa-bar-chart-o","enable":true},{"id":"calculator","url":"calculator","text":"Calculator","class":"fa fa-calculator","enable":true},{"id":"settings","url":"settings","text":"Setting","enable":true,"class":"fa fa-cogs","children":[{"id":"changepassword","url":"change-password","text":"Change Password","class":"fa fa-key","enable":true}]},{"id":"supplier-guidelines","url":"supplier-guidelines","text":"Guideline","enable":true,"class":"fa fa-book","children":[]}]'
where oid = 'Supplier';



--By Liton @ 13-Feb-2021 10:40
alter	table	Airline         add logoPath        text;
alter	table	Airline         add companyOid      varchar(128);
alter	table	Airline         add constraint      fk_companyOid_Airline        foreign key    (companyOid)  references     Company(oid);
alter	table	TicketInvoice   add issueDate       date;
alter	table	TicketInvoice   add sector          varchar(128);
alter	table	TicketInvoice   add pnr             varchar(32);
alter	table	TicketInvoice   add airlineOid      varchar(128);
alter	table	TicketInvoice   add airlines        varchar(128);
alter	table	TicketInvoice   add constraint      fk_airlineOid_TicketInvoice  foreign key    (airlineOid)  references     Airline(oid);
alter	table	Ticket          add airlineOid      varchar(128);
alter	table	Ticket          add constraint      fk_airlineOid_Ticket         foreign key    (airlineOid)  references     Airline(oid);

--By Liton @ 27-Feb-2021 20:30
alter	table	Route           add departureTerminal              varchar(32);
alter	table	Route           add arrivalTerminal                varchar(32);


--By Liton @ 23-Aug-2021 17:00
alter	table	TicketInvoice	add additionalProfitAmount	         numeric(10,2) 		default 0;
alter	table	Ticket      	add additionalProfitAmount	         numeric(10,2) 		default 0;

--By Liton @ 18-Sep-2021 19:44
alter	table	Ticket		add isAitApplicable                    	 varchar(32)       	default 'true';
alter	table	Ticket          add constraint  ck_isAitApplicable_Ticket   check   (isAitApplicable = 'true' or isAitApplicable = 'false');









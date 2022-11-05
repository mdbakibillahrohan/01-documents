/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
mobileNo                       : 
operator                       : 
billAmount                     : 
fileName                       : 
employeeOid                    : 
companyCalendarOid             : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
*/
create table                   MobileBill
(
oid                            varchar(128)                                                not null,
mobileNo                       varchar(64),
operator                       varchar(64),
billAmount                     numeric(12,2)                                                              default 0,
fileName                       varchar(128),
employeeOid                    varchar(128),
companyCalendarOid             varchar(128),
companyOid                     varchar(128),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
constraint                     pk_MobileBill                                               primary key    (oid),
constraint                     fk_employeeOid_MobileBill                                   foreign key    (employeeOid)
                                                                                           references     Employee(oid),
constraint                     fk_companyCalendarOid_MobileBill                            foreign key    (companyCalendarOid)
                                                                                           references     CompanyCalendar(oid),
constraint                     fk_companyOid_MobileBill                                    foreign key    (companyOid)
                                                                                           references     Company(oid)
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
basic                          : 
hr                             : 
conveyance                     : 
medical                        : 
late                           : 
lwp                            : 
totalAllowance                 : 
advance                        : 
mobile                         : 
tax                            : 
totalDeduction                 : 
netPayable                     : 
paymentMode                    : 
employeeOid                    : 
companyCalendarOid             : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   EmployeeSalary
(
oid                            varchar(128)                                                not null,
basic                          numeric(12,2)                                                              default 0,
hr                             numeric(12,2)                                                              default 0,
conveyance                     numeric(12,2)                                                              default 0,
medical                        numeric(12,2)                                                              default 0,
late                           numeric(12,2)                                                              default 0,
lwp                            numeric(12,2)                                                              default 0,
totalAllowance                 numeric(12,2)                                                              default 0,
advance                        numeric(12,2)                                                              default 0,
mobile                         numeric(12,2)                                                              default 0,
tax                            numeric(12,2)                                                              default 0,
totalDeduction                 numeric(12,2)                                                              default 0,
netPayable                     numeric(12,2)                                                              default 0,
paymentMode                    varchar(64),
employeeOid                    varchar(128),
companyCalendarOid             varchar(128),
companyOid                     varchar(128),
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_EmployeeSalary                                           primary key    (oid),
constraint                     fk_employeeOid_EmployeeSalary                               foreign key    (employeeOid)
                                                                                           references     Employee(oid),
constraint                     fk_companyCalendarOid_EmployeeSalary                        foreign key    (companyCalendarOid)
                                                                                           references     CompanyCalendar(oid),
constraint                     fk_companyOid_EmployeeSalary                                foreign key    (companyOid)
                                                                                           references     Company(oid)
);



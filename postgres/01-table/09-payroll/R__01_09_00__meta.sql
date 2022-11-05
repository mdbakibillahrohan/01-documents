/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
status                         : 
reason                         : 
mobileBillStatus               : 
calendarOid                    : 
companyOid                     : 
createdOn                      : When was created
createdBy                      : Who was created
editedOn                       : When was edited
editedBy                       : Who was edited
*/
create table                   CompanyCalendar
(
oid                            varchar(128)                                                not null,
status                         varchar(64),
reason                         text,
mobileBillStatus               varchar(64),
calendarOid                    varchar(128)                                                not null,
companyOid                     varchar(128)                                                not null,
createdOn                      timestamp                                                   not null       default current_timestamp,
createdBy                      varchar(64)                                                 not null       default 'System',
editedOn                       timestamp,
editedBy                       varchar(64),
constraint                     pk_CompanyCalendar                                          primary key    (oid),
constraint                     fk_calendarOid_CompanyCalendar                              foreign key    (calendarOid)
                                                                                           references     Calendar(oid),
constraint                     fk_companyOid_CompanyCalendar                               foreign key    (companyOid)
                                                                                           references     Company(oid)
);



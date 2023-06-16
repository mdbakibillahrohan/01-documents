/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
financial_period_name          : 
period_type                    : 
start_date                     : 
end_date                       : 
status                         : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   financial_period
(
oid                            varchar(128)                                                not null,
financial_period_name          varchar(128)                                                not null,
period_type                    varchar(64)                                                 not null,
start_date                     date                                                        not null,
end_date                       date                                                        not null,
status                         varchar(16)                                                 not null       default 'Opened',
company_oid                    varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_financial_period                                         primary key    (oid),
constraint                     ck_period_type_financial_period                             check          (period_type = 'Yearly' or period_type = 'HalfYearly' or period_type = 'Quarterly' or period_type = 'Custom'),
constraint                     ck_status_financial_period                                  check          (status = 'Created' or status = 'Opened' or status = 'Closed'),
constraint                     fk_company_oid_financial_period                             foreign key    (company_oid)
                                                                                           references     company(oid)
);



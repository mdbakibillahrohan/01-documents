/*
This table to be used to store audit log information of Login
oid                            : Surrogate primary key
login_id                       : Login on which the log is
access_token                   : Acesstoken of user
signin_time                    : User's singin time 
sign_out_time                  : User's signout time
status                         : User's Status
*/
create table                   login_log
(
oid                            varchar(128)                                                not null,
login_id                       varchar(128),
access_token                   text,
signin_time                    timestamp,
sign_out_time                  timestamp,
status                         varchar(16)                                                                default 'Signin',
constraint                     pk_login_log                                                primary key    (oid),
constraint                     ck_status_login_log                                         check          (status = 'Signin' or status = 'Signout')
);

/*
This table to be used to store audit log information of Login
description                    : Login on which the log is
reference_id                   : Acesstoken of user
reference_name                 : User's singin time 
created_on                     : User's signout time
created_by                     : User's Status
company_oid                    : 
*/
create table                   activity_log
(
description                    text                                                        not null,
reference_id                   varchar(128)                                                not null,
reference_name                 varchar(128)                                                not null,
created_on                     timestamp                                                   not null       default clock_timestamp(),
created_by                     varchar(64)                                                 not null       default 'System',
company_oid                    varchar(128)                                                not null
);

/*
This table to be used to store audit log information of Login
oid                            : Surrogate primary key
service_name                   : 
route_name                     : 
request_json                   : 
response_json                  : 
request_on                     : 
response_on                    : 
duration_in_ms                 : 
created_by                     : 
company_oid                    : 
*/
create table                   api_log
(
oid                            varchar(128),
service_name                   varchar(128),
route_name                     varchar(128),
request_json                   json,
response_json                  json,
request_on                     timestamp,
response_on                    timestamp,
duration_in_ms                 numeric(12,0),
created_by                     varchar(64),
company_oid                    varchar(128)
);



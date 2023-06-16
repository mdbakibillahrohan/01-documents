/*
-
oid                            : Surrogate Primary Key
airport_id                     : 
airport_name                   : 
city                           : 
country                        : 
iata                           : 
icao                           : 
latitude                       : 
longitude                      : 
altitude                       : 
timezone_in_hour               : 
dst                            : 
timezone                       : 
status                         : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   airport
(
oid                            varchar(128)                                                not null,
airport_id                     varchar(64)                                                 not null,
airport_name                   varchar(128)                                                not null,
city                           varchar(64),
country                        varchar(64),
iata                           varchar(32),
icao                           varchar(32),
latitude                       numeric(18,12),
longitude                      numeric(18,12),
altitude                       varchar(32),
timezone_in_hour               numeric(5,3),
dst                            varchar(32),
timezone                       varchar(32),
status                         varchar(32)                                                 not null       default 'Active',
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_airport                                                  primary key    (oid),
constraint                     ck_status_airport                                           check          (status = 'Active' or status = 'Inactive')
);

/*
-
oid                            : Surrogate Primary Key
airline_id                     : 
airline_name                   : 
alias_name                     : 
country                        : 
iata                           : 
icao                           : 
callsign                       : 
status                         : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   airline
(
oid                            varchar(128)                                                not null,
airline_id                     varchar(64)                                                 not null,
airline_name                   varchar(128)                                                not null,
alias_name                     varchar(64),
country                        varchar(64),
iata                           varchar(32),
icao                           varchar(32),
callsign                       varchar(64),
status                         varchar(32)                                                 not null       default 'Active',
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_airline                                                  primary key    (oid),
constraint                     ck_status_airline                                           check          (status = 'Active' or status = 'Inactive')
);



/*
Log for every request to (and response from) Antarika
oid                            : Surrogate Primary Key
role_id                        : 
role_description               : 
menu_json                      : 
report_json                    : 
status                         : 
*/
create table                   role
(
oid                            varchar(128)                                                not null,
role_id                        varchar(64)                                                 not null,
role_description               varchar(256),
menu_json                      json,
report_json                    json,
status                         varchar(16)                                                 not null       default 'Active',
constraint                     pk_role                                                     primary key    (oid),
constraint                     uk_role_id_role                                             unique         (role_id),
constraint                     ck_status_role                                              check          (status = 'Active' or status = 'Inactive')
);

/*
Log for every request to (and response from) Antarika
oid                            : Surrogate Primary Key
login_id                       : 
password                       : 
name                           : 
image_path                     : 
status                         : 
role_oid                       : 
company_oid                    : 
created_on                     : When was created
created_by                     : Who was created
edited_on                      : When was edited
edited_by                      : Who was edited
*/
create table                   login
(
oid                            varchar(128)                                                not null,
login_id                       varchar(64)                                                 not null,
password                       varchar(128)                                                not null,
name                           varchar(128),
image_path                     text,
status                         varchar(16)                                                 not null       default 'Active',
role_oid                       varchar(64),
company_oid                    varchar(128),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
edited_on                      timestamp,
edited_by                      varchar(64),
constraint                     pk_login                                                    primary key    (oid),
constraint                     uk_login_id_login                                           unique         (login_id),
constraint                     ck_status_login                                             check          (status = 'Active' or status = 'Inactive'),
constraint                     fk_role_oid_login                                           foreign key    (role_oid)
                                                                                           references     role(oid),
constraint                     fk_company_oid_login                                        foreign key    (company_oid)
                                                                                           references     company(oid)
);



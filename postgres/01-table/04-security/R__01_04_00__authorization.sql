/*
Roles used for users
oid                            : Surrogate primary key
roleId                         : Role Id
roleDescription                : Description of Role
status                         : Role status
menuJson                       : Access JSON array comes from ANP sheet
reportJson                     : Json schema to generate report menu
sortOrder                      : 
*/
create table                   Role
(
oid                            varchar(128)                                                not null,
roleId                         varchar(128)                                                not null,
roleDescription                text                                                        not null,
status                         varchar(32)                                                 not null       default 'Active',
menuJson                       text                                                                       default '[]',
reportJson                     text                                                        not null       default '[]',
sortOrder                      numeric(3,0)                                                not null,
constraint                     pk_Role                                                     primary key    (oid),
constraint                     uk_roleId_Role                                              unique         (roleId),
constraint                     ck_status_Role                                              check          (status = 'Active' or status = 'Inactive')
);



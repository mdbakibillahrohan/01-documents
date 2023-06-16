/*

oid                            : Surrogate primary key
json_data                      : 
*/
create table                   meta_property
(
oid                            varchar(128)                                                not null,
json_data                      json                                                        not null       default '{}',
constraint                     pk_meta_property                                            primary key    (oid)
);



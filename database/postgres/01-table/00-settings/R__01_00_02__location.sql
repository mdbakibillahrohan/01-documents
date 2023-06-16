/*
-
oid                            : Surrogate Primary Key
name                           : 
capital                        : 
iso_code_alpha_two             : 
iso_code_alpha_three           : 
country_code                   : 
dialing_code                   : 
created_on                     : When was created
created_by                     : Who was created
*/
create table                   country
(
oid                            varchar(128)                                                not null,
name                           varchar(256)                                                not null,
capital                        varchar(128),
iso_code_alpha_two             varchar(16),
iso_code_alpha_three           varchar(16),
country_code                   varchar(32),
dialing_code                   varchar(32),
created_on                     timestamp                                                   not null       default current_timestamp,
created_by                     varchar(64)                                                 not null       default 'System',
constraint                     pk_country                                                  primary key    (oid)
);

/*
-
oid                            : Surrogate Primary Key
division_code                  : 
name_en                        : 
name_bn                        : 
*/
create table                   division
(
oid                            varchar(128)                                                not null,
division_code                  varchar(32)                                                 not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
constraint                     pk_division                                                 primary key    (oid),
constraint                     uk_division_code_division                                   unique         (division_code),
constraint                     uk_name_en_division                                         unique         (name_en)
);

/*
-
oid                            : Surrogate Primary Key
district_code                  : 
name_en                        : 
name_bn                        : 
division_oid                   : 
*/
create table                   district
(
oid                            varchar(128)                                                not null,
district_code                  varchar(32)                                                 not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
division_oid                   varchar(128)                                                not null,
constraint                     pk_district                                                 primary key    (oid),
constraint                     uk_district_code_district                                   unique         (district_code),
constraint                     uk_name_en_district                                         unique         (name_en),
constraint                     fk_division_oid_district                                    foreign key    (division_oid)
                                                                                           references     division(oid)
);

/*
-
oid                            : Surrogate Primary Key
thana_code                     : 
name_en                        : 
name_bn                        : 
district_oid                   : 
*/
create table                   thana
(
oid                            varchar(128)                                                not null,
thana_code                     varchar(32)                                                 not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
district_oid                   varchar(128)                                                not null,
constraint                     pk_thana                                                    primary key    (oid),
constraint                     uk_thana_code_thana                                         unique         (thana_code),
constraint                     fk_district_oid_thana                                       foreign key    (district_oid)
                                                                                           references     district(oid)
);

/*
-
oid                            : Surrogate Primary Key
post_code                      : 
name_en                        : 
name_bn                        : 
thana_oid                      : 
*/
create table                   post_office
(
oid                            varchar(128)                                                not null,
post_code                      varchar(32)                                                 not null,
name_en                        varchar(128)                                                not null,
name_bn                        varchar(128),
thana_oid                      varchar(128)                                                not null,
constraint                     pk_post_office                                              primary key    (oid),
constraint                     uk_post_code_post_office                                    unique         (post_code),
constraint                     fk_thana_oid_post_office                                    foreign key    (thana_oid)
                                                                                           references     thana(oid)
);



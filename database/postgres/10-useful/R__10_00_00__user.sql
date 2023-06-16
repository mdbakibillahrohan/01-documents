
PGPASSWORD='postgres' /usr/bin/psql --username=postgres --dbname=postgres

drop database if exists gds;
drop user if exists gds;
create user gds password 'gds';
create database gds WITH owner=gds encoding='UTF8';

PGPASSWORD='gds' /usr/bin/psql --username=gds --dbname=gds

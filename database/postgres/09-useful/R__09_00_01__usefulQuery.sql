
drop database if exists bms;
drop tablespace if exists absspace;
SELECT * FROM pg_tablespace;

-- Extra work
create tablespace absspace location '/var/lib/pgsql/10/abs';
create database bms WITH owner=bms encoding='UTF8' tablespace = absspace;

-- useful DDL of partition
alter table AntarikaRequestLog detach partition AntarikaRequestLog_y2018m01;
drop table if exists AntarikaRequestLog_y2018m01;

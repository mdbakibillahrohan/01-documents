------------------------- Production DB Server -------------------------
-- open terminal login as postgres in operation system
vagrant ssh postgres
sudo su
su - postgres

-- to create data directory for each tablespace
mkdir -p /var/lib/pgsql/10/abs/abstbs
mkdir -p /var/lib/pgsql/10/abs/logtbs_y2016m01

-- login database of postgres using postgres user
vagrant ssh postgres
sudo -u postgres psql -U postgres

create user gds password 'gds';
create database gds WITH owner=gds encoding='UTF8';

-- Create User
create user gds password 'gds';
alter user gds with superuser;

-- Create tablespace from 00-init/

-- Create Database
create database gds WITH owner=gds encoding='UTF8';
create database gds WITH owner=gds encoding='UTF8' tablespace = abstbs;

-- Create Schema absnew as default, absold
create schema if not exists absnew authorization gds;
create schema if not exists absold authorization gds;

-- Rename Schema
alter schema public rename to my_schema;
alter schema original_public rename to public;


create database testgds WITH owner=gds encoding='UTF8';
sudo -u postgres PGPASSWORD="ticlpostgres" psql -U postgres -d testgds -f /opt/backup/db_bak/gds/gds__2019-01-17__23.55.01.sql


sudo -u postgres PGPASSWORD="gds" pg_dump -U gds -d gds > /opt/backup/db_bak/gds/gds_$(date +%Y-%m-%d__%H.%M.%S).sql
sudo -u postgres psql -U gds -d gds < /home/tanim/Desktop/project/gta/gds.sql

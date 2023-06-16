set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".uuid();
CREATE OR REPLACE FUNCTION "public".uuid()
RETURNS varchar(128) AS $uuid$
    BEGIN
		RETURN (SELECT uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' from 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text from 17)::cstring));
    END;
$uuid$ language plpgsql;


DROP FUNCTION IF EXISTS "public".convert_en(p_bn varchar(64));
CREATE OR REPLACE FUNCTION "public".convert_en(p_bn varchar(64))
RETURNS text AS $convert_en$
    DECLARE
        i char;
        j char;
        str text := '';
    BEGIN
        FOR i IN SELECT tbl.col FROM regexp_split_to_table(p_bn, '') AS tbl(col) LOOP
            j := (case
                when i = '০' then '0'
                when i = '১' then '1'
                when i = '২' then '2'
                when i = '৩' then '3'
                when i = '৪' then '4'
                when i = '৫' then '5'
                when i = '৬' then '6'
                when i = '৭' then '7'
                when i = '৮' then '8'
                when i = '৯' then '9'
                else i::char
            end);
            str :=  str || j;
        END LOOP;
        RETURN str;
    END;
$convert_en$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS "public".convert_bn(p_bn varchar(64));
CREATE OR REPLACE FUNCTION "public".convert_bn(p_bn varchar(64))
RETURNS text AS $convert_bn$
    DECLARE
        i char;
        j char;
        str text := '';
    BEGIN
        FOR i IN SELECT tbl.col FROM regexp_split_to_table(p_bn, '') AS tbl(col) LOOP
            j := (case
                when i = '0' then '০'
                when i = '1' then '১'
                when i = '2' then '২'
                when i = '3' then '৩'
                when i = '4' then '৪'
                when i = '5' then '৫'
                when i = '6' then '৬'
                when i = '7' then '৭'
                when i = '8' then '৮'
                when i = '9' then '৯'
                else i::char
            end);
            str :=  str || j;
        END LOOP;
        RETURN str;
    END;
$convert_bn$ LANGUAGE plpgsql;


-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_00_00__base.sql

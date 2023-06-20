set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".generate_calendar_month();
CREATE OR REPLACE FUNCTION "public".generate_calendar_month()
RETURNS void AS $generate_calendar_month$
    DECLARE
        v_year                      int := 20;
        c                           int;
        v_start_date                date;
        v_end_date                  date;
    BEGIN
        RAISE INFO '% - Starting - %', to_char(clock_timestamp(), 'YYYY-MM-DD HH24:MI:SS.MS'), 'generate_calendar_month';

        select date_trunc('year', current_date)::date into v_start_date;
        EXECUTE format('select current_date + interval ''%s year''', v_year) into v_end_date;

        WHILE v_start_date <= v_end_date LOOP
            insert into calendar_month (oid, year_en, month_name, month_number)
            values (to_char(v_start_date, 'YYYYMM'), to_char(v_start_date, 'YYYY')::int,
            to_char(v_start_date, 'Month'), to_char(v_start_date, 'MM')::int)
            on conflict on constraint pk_calendar_month do nothing;
            v_start_date := v_start_date + interval '1 month';
        END LOOP;
        RAISE INFO '% - terminated - %', to_char(clock_timestamp(), 'YYYY-MM-DD HH24:MI:SS.MS'), 'generate_calendar_month';
    END;
$generate_calendar_month$ language plpgsql;


-- select "public".generate_calendar_month();
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_00_01__calendar.sql

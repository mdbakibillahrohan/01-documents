set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_company_by_login_id(p_login_id varchar(64));
CREATE OR REPLACE FUNCTION "public".get_company_by_login_id(p_login_id varchar(64))
RETURNS json AS $get_company_by_login_id$
    DECLARE
        l                                 record;
        c                                 record;
    BEGIN
        select login_id, lower(status) as status, name, company_oid into l
        from login where login_id = p_login_id;

        if l.login_id is null then
            raise exception 'Not found user - %', p_login_id;
        end if;

        if l.status is null or l.status != 'active' then
            raise exception 'Not found user as active - %', p_login_id;
        end if;

        if l.company_oid is null then
            raise exception 'Not found company, login_id - %', p_login_id;
        end if;

        select cm.oid, lower(cm.status) as status, cm.short_name, lg.name, lg.login_id into c
        from company cm, login lg
        where lg.company_oid = cm.oid
        and lg.login_id = p_login_id;

        if c.oid is null then
            raise exception 'Not found company - %', l.company_oid;
        end if;

        if c.status is null or c.status != 'active' then
            raise exception 'Not found company as active - %', c.short_name;
        end if;
        return row_to_json(c);
    END;
$get_company_by_login_id$ language plpgsql;


-- select "public".get_company_by_login_id('admin');
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_00_02__security.sql

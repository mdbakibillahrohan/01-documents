set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_financial_period_by_company_oid(p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_financial_period_by_company_oid(p_company_oid varchar(128))
RETURNS json AS $get_financial_period_by_company_oid$
    DECLARE 
        fp                          record;
    BEGIN
        select oid, start_date, end_date, lower(status) as status into fp
        from financial_period 
        where company_oid = p_company_oid
        order by end_date desc limit 1;

        if fp.oid is null then 
            raise exception 'Not found financial_period - %', p_company_oid;
        end if;

        if fp.status is null or fp.status != 'opened' then
            raise exception 'Not found financial_period as opened - %', fp.oid;
        end if;

        return row_to_json(fp);
    END;
$get_financial_period_by_company_oid$ language plpgsql;

DROP FUNCTION IF EXISTS "public".close_financial_period(p_json json);
CREATE OR REPLACE FUNCTION "public".close_financial_period(p_json json)
RETURNS void AS $close_financial_period$
    DECLARE
        v_company                   json;
        v_fp                        json;
        v_revenue                   float;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select get_financial_period_by_company_oid(v_company->>'oid') into v_fp;

        select (sum(case when lg.ledger_group_code = '04' then l.ledger_balance else 0 end) - sum(case when lg.ledger_group_code = '05' then l.ledger_balance else 0 end))
        into v_revenue
        from ledger_group lg, ledger_subgroup lsg, ledger l 
        where lg.oid = lsg.ledger_group_oid
        and lsg.oid = l.ledger_subgroup_oid
        and lg.company_oid = v_company->>'oid';

        update ledger set ledger_balance = v_revenue
        where oid = (select ledger_oid from ledger_setting where ledger_key = 'RetainedEarning');

        insert into ledger_history (oid, ledger_code, ledger_name, mnemonic, ledger_type, balance_sheet_item, initial_balance,
        ledger_balance, status, ledger_subgroup_oid, financial_period_oid, company_oid, created_by, parent_oid)
        select uuid(), ledger_code, ledger_name, mnemonic, ledger_type, balance_sheet_item, initial_balance, ledger_balance, status, ledger_subgroup_oid, p_json->>'oid', company_oid, v_company->>'login_id', oid 
        from ledger
        where company_oid = v_company->>'oid';

        update subledger_history
        set ledger_history_oid = (select oid from ledger_history where parent_oid = ledger_oid limit 1)
        where company_oid = v_company->>'oid' and financial_period_oid = p_json->>'oid';

        update financial_period set status = 'Closed' where oid = p_json->>'oid' and company_oid = v_company->>'oid';

        update ledger set initial_balance = ledger_balance, ledger_balance = 0.00
        where company_oid = v_company->>'oid'
        and (ledger_code like '04%' or ledger_code like '05%');

        update subledger set initial_balance = subledger_balance, subledger_balance = 0.00
        where company_oid = v_company->>'oid'
        and (subledger_code like '04%' or subledger_code like '05%');
    END;
$close_financial_period$ language plpgsql;

DROP IF EXISTS "public".save_update_financial_period(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_financial_period(p_json json)
RETURNS varchar(128) AS $save_update_financial_period$
    DECLARE
        v_company                           json;
        v_action_type                       varchar(128);
        v_oid                               varchar(128);
        v_description                       text;
    BEGIN
        select get_company_by_login_id(p_json->>"created_by") into v_company;

        if length(coalesce(p_json->>'oid', '')) = 0 then 
            v_action_type := 'Save';
            select uuid() into v_oid;
            
            insert into financial_period (oid, financial_period_name, period_type, 
                start_date, end_date, company_oid, created_by )
            values (v_oid, p_json->>'financial_period_name', p_json->>'period_type', p_json->>'start_date', p_json->>'end_date', v_company->>'oid', v_company->>'login_id' );
        else
            v_action_type := 'Update';
            v_oid := p_json->>'oid';

            update financial_period financial_period_name = 
                p_json->>'financial_period_name', period_type = p_json->>'period_type',
                start_date = p_json->>'start_date', end_date = p_json->>'end_date'
            where oid = v_oid and company_oid = v_company->>'oid';
        end if;

        v_description := concat(v_action_type, ' ', p_json->>'financial_period_name', ' as financial period by ', v_company->>'login_id');
        insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
        values (v_description, v_oid, 'financial period', v_company->>'login_id', v_company->>'oid');
        
        return v_oid;
    END;
$save_update_financial_period$ LANGUAGE plpgsql;

-- PGPASSWORD='password' psql -h localhost -U postgres -d gds -f ./R__05_03_05__financial-period.sql
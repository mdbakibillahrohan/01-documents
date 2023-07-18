
set client_min_messages = 'warning';


DROP FUNCTION IF EXISTS "public".get_financial_period_by_company_oid(p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_financial_period_by_company_oid(p_company_oid varchar(128)) RETURNS json AS $get_financial_period_by_company_oid$
    DECLARE
        fp                                record;
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

        -- if (current_date between fp.start_date and fp.end_date) = false then
            -- raise exception 'Not found financial_period between date range - %', fp.oid;
        -- end if;
        return row_to_json(fp);
    END;
$get_financial_period_by_company_oid$ language plpgsql;

-- { "oid": "", "created_by": "papiya" }

DROP FUNCTION IF EXISTS "public".close_financial_period(p_json json);
CREATE OR REPLACE FUNCTION "public".close_financial_period(p_json json) RETURNS void AS $close_financial_period$
    DECLARE
        v_company                                   json;
        v_fp                                        json;
        v_revenue                                   float;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select get_financial_period_by_company_oid(v_company->>'oid') into v_fp;

        select (sum(case when lg.ledger_group_code = '04' then l.ledger_balance else 0 end) -
        sum(case when lg.ledger_group_code = '05' then l.ledger_balance else 0 end))
        into v_revenue
        from ledger_group lg, ledger_subgroup lsg, ledger l
        where lg.oid = lsg.ledger_group_oid
        and lsg.oid = l.ledger_subgroup_oid
        and lg.company_oid = v_company->>'oid';

        update ledger set ledger_balance = v_revenue
        where oid = (select ledger_oid from ledger_setting where ledger_key = 'RetainedEarning');

        insert into ledger_history (oid, ledger_code, ledger_name, mnemonic, ledger_type, balance_sheet_item, initial_balance,
        ledger_balance, status, ledger_subgroup_oid, financial_period_oid, company_oid, created_by, parent_oid)
        select uuid(), ledger_code, ledger_name, mnemonic, ledger_type, balance_sheet_item, initial_balance,
        ledger_balance, status, ledger_subgroup_oid, p_json->>'oid', company_oid, v_company->>'login_id', oid
        from ledger
        where company_oid = v_company->>'oid';

        insert into subledger_history (oid, ledger_key, subledger_code, subledger_name, subledger_type, balance_sheet_item, initial_balance,
        subledger_balance, status, reference_oid, ledger_oid, financial_period_oid, company_oid, created_by, parent_oid)
        select uuid(), ledger_key, subledger_code, subledger_name, subledger_type, balance_sheet_item, initial_balance,
        subledger_balance, status, reference_oid, ledger_oid, p_json->>'oid', company_oid, v_company->>'login_id', oid
        from subledger
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

-- select "public".get_financial_period_by_company_oid('celloscope');
-- select "public".close_financial_period('{ "oid": "fp-celloscope-2022-2023", "created_by": "papiya" }');
 -- PGPASSWORD='celac' psql -h localhost -U celac -d celac -f ./R__04_03_05__financial-period.sql
-- PGPASSWORD='celac' psql -h 172.16.6.68 -U celac -d celac -f ./R__04_03_05__financial-period.sql
set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_subledger_code(p_ledger_oid varchar(128), p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_subledger_code(p_ledger_oid varchar(128), p_company_oid varchar(128))
RETURNS varchar(10) AS $get_subledger_code$
	DECLARE
        v_data                                      record;
  		v_subledger_code 				            varchar(10);
    BEGIN
        select to_char((to_number(subledger_code, 'FM9999999999') + 1), 'FM0000000000')
        into v_subledger_code
        from subledger
        where company_oid = p_company_oid
        and ledger_oid = p_ledger_oid
        order by to_number(subledger_code, 'FM9999999999') desc
        limit 1;
        if v_subledger_code is null then
            select * into v_data from ledger where oid = p_ledger_oid and company_oid = p_company_oid;
            v_subledger_code := concat(v_data.ledger_code, '001');
        end if;
        return v_subledger_code;
    END;
$get_subledger_code$ language plpgsql;



-- { "oid": "", "subledger_name": "Operating Expenses - Test Remuneration & Salary", "subledger_group_oid": "lg-celloscope-05", "created_by": "papiya" }
DROP FUNCTION IF EXISTS "public".save_update_subledger(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_subledger(p_json json)
RETURNS varchar(128) AS $save_update_subledger$
    DECLARE
        v_company                                   json;
        v_data                                      record;
        v_action_type                               varchar(64);
        v_timestamp                                 varchar(64);
        v_oid                                       varchar(128);
        v_description                               text;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select * into v_data from ledger where oid = p_json->>'ledger_oid' and company_oid = v_company->>'oid';

        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'Save';
            select uuid() into v_oid;
            select get_subledger_code(p_json->>'ledger_oid', v_company->>'oid') into v_timestamp;
            insert into subledger (oid, subledger_code, subledger_name, ubledger_type, balance_sheet_item,
				initial_balance, subledger_balance,  ledger_oid, status, company_oid, created_by)
            values (v_oid, v_timestamp, p_json->>'subledger_name', v_data.ledger_type,
                v_data.balance_sheet_item, coalesce((p_json->>'initial_balance')::float, 0),
                coalesce((p_json->>'initial_balance')::float, 0), p_json->>'ledger_oid',
				p_json->>'status', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'Update';
            v_oid := p_json->>'oid';
            select subledger_code into v_timestamp from subledger where oid = v_oid;
            update subledger set subledger_name = p_json->>'subledger_name',
                initial_balance = coalesce((p_json->>'initial_balance')::float, 0),
                ledger_oid =  p_json->>'ledger_oid', subledger_type = v_data.ledger_type,
                balance_sheet_item = v_data.balance_sheet_item, status = p_json->>'status',
                company_oid = v_company->>'oid', edited_by = v_company->>'login_id', edited_on = clock_timestamp()
            where oid = v_oid;
        end if;

        v_description := concat(v_action_type, ' ', p_json->>'subledger_name', ' as subledger by ', v_company->>'login_id');
		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_timestamp, 'Subledger', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_subledger$ language plpgsql;


-- select "public".save_update_subledger('{ "oid": "", "subledger_name": "demo subledger",
-- 									  "initial_balance":"1253245.",
-- 									  "ledger_oid": "e2cf5bb6-5c96-4f07-b0a3-88c4db541e0d",
-- 									  "created_by": "admin" }');
-- select "public".save_update_subledger('{ "oid": "4a266dfb-67e2-4108-b189-43716923a457", "subledger_name": "demo updated subledger",
-- 									  "initial_balance":"1253245.",
-- 									  "ledger_oid": "e2cf5bb6-5c96-4f07-b0a3-88c4db541e0d",
-- 									  "created_by": "admin" }');

-- PGPASSWORD='celac' psql -h localhost -U celac -d celac -f ./R__05_04_01__sub_subledger.sql

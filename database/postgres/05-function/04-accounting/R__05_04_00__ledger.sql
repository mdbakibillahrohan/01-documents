set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_ledger_code(p_ledger_subgroup_oid varchar(128), p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_ledger_code(p_ledger_subgroup_oid varchar(128), p_company_oid varchar(128))
RETURNS varchar(7) AS $get_ledger_code$
	DECLARE
        v_data                                  record;
  		v_ledger_code 				            varchar(7);
    BEGIN
        select to_char((to_number(ledger_code, 'FM9999999') + 1), 'FM0000000')
        into v_ledger_code
        from ledger
        where company_oid = p_company_oid
        and ledger_subgroup_oid = p_ledger_subgroup_oid
        order by to_number(ledger_code, 'FM9999999') desc
        limit 1;
        if v_ledger_code is null then
            select * into v_data from ledger_subgroup where oid = p_ledger_subgroup_oid and company_oid = p_company_oid;
            v_ledger_code := concat(v_data.ledger_subgroup_code, '001');
        end if;
        return v_ledger_code;
    END;
$get_ledger_code$ language plpgsql;



-- { "oid": "", "ledger_name": "Operating Expenses - Test Remuneration & Salary", "ledger_group_oid": "lg-celloscope-05", "created_by": "papiya" }
DROP FUNCTION IF EXISTS "public".save_update_ledger(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_ledger(p_json json)
RETURNS varchar(128) AS $save_update_ledger$
    DECLARE
        v_company                                   json;
        v_data                                      record;
        v_action_type                               varchar(64);
        v_timestamp                                 varchar(64);
        v_oid                                       varchar(128);
        v_description                               text;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
		select * into v_data from ledger_subgroup where oid = p_json->>'ledger_subgroup_oid' and company_oid = v_company->>'oid';
        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'Save';
            select uuid() into v_oid;
            select get_ledger_code(p_json->>'ledger_subgroup_oid', v_company->>'oid') into v_timestamp;
            insert into ledger (oid, ledger_code, ledger_name, mnemonic,
                ledger_type, balance_sheet_item, initial_balance, ledger_balance, ledger_subgroup_oid, status, company_oid, created_by)
            values (v_oid, v_timestamp, p_json->>'ledger_name', p_json->>'mnemonic', v_data.ledger_subgroup_type,
                v_data.balance_sheet_item, coalesce((p_json->>'initial_balance')::float, 0),
                coalesce((p_json->>'initial_balance')::float, 0), p_json->>'ledger_subgroup_oid',
				p_json->>'status', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'Update';
            v_oid := p_json->>'oid';
            select ledger_code into v_timestamp from ledger where oid = v_oid;
            update ledger set ledger_name = p_json->>'ledger_name', mnemonic = p_json->>'mnemonic',
                initial_balance = coalesce((p_json->>'initial_balance')::float, 0),
                ledger_subgroup_oid =  p_json->>'ledger_subgroup_oid', ledger_type = v_data.ledger_subgroup_type,
                balance_sheet_item = v_data.balance_sheet_item, status = p_json->>'status', company_oid = v_company->>'oid',
                edited_by = v_company->>'login_id', edited_on = clock_timestamp()
            where oid = v_oid;
        end if;

        v_description := concat(v_action_type, ' ', p_json->>'ledger_name', ' as ledger by ', v_company->>'login_id');
		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_timestamp, 'Ledger', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_ledger$ language plpgsql;


-- select "public".save_update_ledger('{ "oid": "", "ledger_name": "demo ledger", "mnemonic":"dmo", "initial_balance":"1253245.", "ledger_subgroup_oid": "lsg-demo-0401", "created_by": "admin" }');
-- select "public".save_update_ledger('{ "oid": "fd72500d-5f20-4631-939d-bdf2b39a8090", "ledger_name": "Operating Expenses - Test Remuneration & Salary-20", "ledger_group_oid": "lg-celloscope-05", "created_by": "admin" }');

-- PGPASSWORD='celac' psql -h localhost -U celac -d celac -f ./R__05_04_00__sub_ledger.sql

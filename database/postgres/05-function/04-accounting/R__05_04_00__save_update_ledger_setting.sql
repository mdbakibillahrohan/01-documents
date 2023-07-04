set client_min_messages = 'warning';


DROP FUNCTION IF EXISTS "public".get_ledger_code(p_table_name varchar(128), p_ledger_oid varchar(128), p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_ledger_code(p_table_name varchar(128),p_ledger_oid varchar(128), p_company_oid varchar(128))
RETURNS varchar(4) AS $get_ledger_code$
	DECLARE
        v_data                                      record;
  		v_ledger_code 				        varchar(4);
    BEGIN
        
    END;
$get_ledger_code$ language plpgsql;


DROP FUNCTION IF EXISTS "public".save_update_ledger_setting(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_ledger_setting(p_json json)
RETURNS varchar(128) AS $save_update_ledger_setting$
    DECLARE 
        v_company                               json;
        v_action_type                           varchar(64);
        v_oid                                   varchar(128);
        v_description                           text;
        v_total_count                           int;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;

        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'save';
            select get_transaction_id(v_company->>'oid', 'ledger_setting') into v_oid;

            insert into ledger_setting (oid, ledger_key, ledger_name, ledger_code, ledger_oid, company_oid) 
            values (v_oid, p_json->>'ledger_key', p_json->>'ledger_name', p_json->>'branch_name', p_json->>'initial_balance', p_json->>'status', p_json->>'bank_oid', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update ledger_setting set account_no = p_json->>'account_no', account_name = p_json->>'account_name', branch_name = p_json->>'branch_name', initial_balance = p_json->>'initial_balance', status = p_json->>'status', bank_oid = p_json->>'bank_oid'
            where oid = p_json->>'oid' and company_oid = v_company->>'oid';
        end if;

        -- bank account save/update by admin
        v_description := concat(v_action_type, 'ledger_setting');

        insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
        values (v_description, v_oid, 'ledger_setting', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_ledger_setting$ LANGUAGE plpgsql;
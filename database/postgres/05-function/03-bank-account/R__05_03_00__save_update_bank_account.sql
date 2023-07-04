set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_bank_account(p_json json);
CReATE OR REPLACE FUNCTION "public".save_update_bank_account(p_json json)
RETURNS varchar(128) AS $save_update_bank_account$
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
            select get_transaction_id(v_company->>'oid', 'bank_account') into v_oid;

            insert into bank_account (oid, account_no, account_name, branch_name, initial_balance, status, bank_oid, company_oid, created_by) 
            values (v_oid, p_json->>'account_no', p_json->>'account_name', p_json->>'branch_name', p_json->>'initial_balance', p_json->>'status', p_json->>'bank_oid', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update bank_account set account_no = p_json->>'account_no', account_name = p_json->>'account_name', branch_name = p_json->>'branch_name', initial_balance = p_json->>'initial_balance', status = p_json->>'status', bank_oid = p_json->>'bank_oid'
            where oid = p_json->>'oid' and company_oid = v_company->>'oid';
        end if;

        -- bank account save/update by admin
        v_description := concat(v_action_type, 'bank_account');

        insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
        values (v_description, v_oid, 'bank_account', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_bank_account$ LANGUAGE plpgsql;
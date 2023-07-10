set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_ledger_setting(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_ledger_setting(p_json json)
RETURNS varchar(128) AS $save_update_ledger_setting$
    DECLARE
        v_company                               json;
        v_action_type                           varchar(64);
        v_oid                                   varchar(128);
        v_description                           text;
        v_ledger                                record;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select * into v_ledger from ledger  where 1 = 1 and oid = p_json->>'ledger_oid' and company_oid = v_company->>'oid';

        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'save';
            select get_transaction_id(v_company->>'oid', 'ledger_setting') into v_oid;
            insert into ledger_setting (oid, ledger_key, ledger_name, ledger_code, ledger_oid, company_oid)
            values (v_oid, p_json->>'ledger_key', v_ledger.ledger_name,
            v_ledger.ledger_code, p_json->>'ledger_oid', v_company->>'oid' );
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update ledger_setting set ledger_key = p_json->>'ledger_key', ledger_name = v_ledger.ledger_name,
            ledger_code = v_ledger.ledger_code, ledger_oid = p_json->>'ledger_oid'
            where oid = p_json->>'oid' and company_oid = v_company->>'oid';
        end if;

        -- ledger setting save/update by admin
        v_description := concat('Ledger setting ', v_action_type, ' by ', v_company->>'login_id');

        insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
        values (v_description, v_oid, 'ledger_setting', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_ledger_setting$ LANGUAGE plpgsql;

-- select "public".save_update_ledger_setting('{"ledger_key": "create","ledger_oid": "lg-demo-0504006","created_by":"admin"}');
-- PGPASSWORD='password' psql -U postgres -d gds -f ./R__05_04_02__save_update_ledger_setting.sql

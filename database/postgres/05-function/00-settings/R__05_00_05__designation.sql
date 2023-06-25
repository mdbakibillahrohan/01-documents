set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_designation(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_designation(p_json json)
RETURNS varchar(128) AS $save_update_designation$
    DECLARE
        v_company                                   json;
        v_action_type                               varchar(64);
        v_oid                                       varchar(128);
        v_description                               text;
        v_total_count                               int;
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;

        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'save';
            select (count(*) + 1) into v_total_count from designation where company_oid = v_company->>'oid';
            select get_transaction_id(v_company->>'oid', 'designation') into v_oid;
            
            insert into designation (oid, name, sort_order, status, company_oid, created_by)
            values (v_oid, p_json->>'name', v_total_count, p_json->>'status', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update designation set name = p_json->>'name', status = p_json->>'status'
            where oid = p_json->>'oid';
        end if;

        -- designation save/update by admin
        v_description := concat(v_action_type, ' designation');

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_oid, 'designation', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_designation$ LANGUAGE plpgsql;

-- select "public".save_update_designation('{"name": "Software Division", "status": "Active", "created_by": "admin"}');
-- select "public".save_update_designation('{"oid": "jCS7VE", "name": "Service Division", "status": "Active", "created_by": "admin"}');
-- PGPASSWORD='password' psql -U postgres -d new_gds -f ./R__05_00_05__designation.sql

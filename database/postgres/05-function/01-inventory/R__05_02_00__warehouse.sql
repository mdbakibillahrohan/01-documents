set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_warehouse(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_warehouse(p_json json)
RETURNS varchar(128) AS $save_update_warehouse$
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
            select get_transaction_id(v_company->>'oid', 'warehouse') into v_oid;
            insert into warehouse (oid, name, address, status, company_oid)
            values (v_oid, p_json->>'name', p_json->>'address', p_json->>'status', v_company->>'oid');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update warehouse set name = p_json->>'name', address = p_json->>'address', status = p_json->>'status'
            where oid = p_json->>'oid';
        end if;

        -- Warehouse save/update by admin
        v_description := concat(v_action_type, ' warehouse');

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_oid, 'Warehouse', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_warehouse$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS "public".change_default_warehouse(p_json json);
CREATE OR REPLACE FUNCTION "public".change_default_warehouse(p_json json)
RETURNS varchar(128) AS $change_default_warehouse$
    DECLARE
        v_company                                   json;
        v_oid                                       varchar(128);
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        v_oid := p_json->>'oid';

        update warehouse set is_default = 'No' where company_oid = v_company->>'oid';
        update warehouse set is_default = 'Yes' where oid = v_oid and company_oid = v_company->>'oid';

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values ('Changed warehouse as default', v_oid, 'Warehouse', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$change_default_warehouse$ LANGUAGE plpgsql;

-- select "public".change_default_warehouse('{"oid":"ZdBGNj","created_by":"admin"}');
-- select "public".save_update_warehouse('{"name":"Warehouse-2", "address":"335/5 Ease Nakhalpara", "status":"Active", "created_by":"admin"}');
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_02_00__warehouse.sql

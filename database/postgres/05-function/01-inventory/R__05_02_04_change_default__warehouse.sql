set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".change_default_warehouse(p_json json);
CREATE OR REPLACE FUNCTION "public".change_default_warehouse(p_json json)
RETURNS varchar(128) AS $change_default_warehouse$
    DECLARE
        v_company                                   json;
        v_action_type                               varchar(64);
        v_oid                                       varchar(128);
        v_description                               text;
        v_default_warehouse_oid                     varchar(128);
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select oid into v_default_warehouse_oid from warehouse where is_default = 'Yes' and company_oid = v_company->>'oid';
        v_action_type := 'change default';
        v_oid := p_json->>'oid';
        update warehouse set is_default = 'Yes'
        where oid = p_json->>'oid' and company_oid = v_company->>'oid';

        update warehouse set is_default = 'No' where oid = v_default_warehouse_oid and company_oid = v_company->>'oid';

        -- Warehouse save/update by admin
        v_description := concat(v_action_type, ' warehouse');

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_oid, 'Warehouse', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$change_default_warehouse$ LANGUAGE plpgsql;

-- select "public".change_default_warehouse('{"oid":"KpGLn","created_by":"admin"}');
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_02_04__change_default_warehouse.sql

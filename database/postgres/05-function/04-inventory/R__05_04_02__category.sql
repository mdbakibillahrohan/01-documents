set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_product_category(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_product_category(p_json json)
RETURNS varchar(128) AS $save_update_product_category$
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
            select get_transaction_id(v_company->>'oid', 'product_category') into v_oid;
            insert into product_category (oid, name, status, company_oid)
            values (v_oid, p_json->>'name', p_json->>'status', v_company->>'oid');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update product_category set name = p_json->>'name', status = p_json->>'status'
            where oid = p_json->>'oid';
        end if;

        -- product_category save/update by admin
        v_description := concat(v_action_type, ' product_category');

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_oid, 'Product Category', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_product_category$ LANGUAGE plpgsql;

-- select "public".save_update_product_category('{"name":"Kg",  "status":"Active", "created_by":"admin"}');
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_02_02__product_category.sql

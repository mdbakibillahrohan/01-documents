set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_product(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_product(p_json json)
RETURNS varchar(128) AS $save_update_product$
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
            select get_transaction_id(v_company->>'oid', 'product') into v_oid;
            insert into product (oid, name, product_type, selling_price, purchase_price, minimum_qty,initial_qty, initial_value, status, product_unit_oid, product_category_oid, company_oid, created_by)
            values (v_oid, p_json->>'name', p_json->>'product_type', CAST(p_json->>'selling_price' AS DECIMAL), CAST(p_json->>'purchase_price' AS DECIMAL), CAST(p_json->>'minimum_qty' AS DECIMAL), CAST(p_json->>'initial_qty' AS DECIMAL), CAST(p_json->>'initial_value' AS DECIMAL), p_json->>'status', p_json->>'product_unit_oid', p_json->>'product_category_oid', v_company->>'oid', p_json->>'created_by');
        else
            v_action_type := 'update';
            v_oid := p_json->>'oid';
            update product set name = p_json->>'name', product_type = p_json->>'product_type', selling_price = CAST(p_json->>'selling_price' AS DECIMAL), purchase_price = CAST(p_json->>'purchase_price' AS DECIMAL), minimum_qty = CAST(p_json->>'minimum_qty' AS DECIMAL), initial_qty = CAST(p_json->>'initial_qty' AS DECIMAL), initial_value = CAST(p_json->>'initial_value' AS DECIMAL), status = p_json->>'status', product_unit_oid = p_json->>'product_unit_oid', product_category_oid = p_json->>'product_category_oid', edited_by = p_json->>'created_by', edited_on = now()
            where oid = p_json->>'oid';
        end if;

        -- product save/update by admin
        v_description := concat(v_action_type, ' product');

		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_oid, 'Product', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_product$ LANGUAGE plpgsql;

--Save Query
-- select "public".save_update_product('{"name":"Fan", "product_type":"Product", "selling_price":1200, "purchase_price":1000, "minimum_qty":1, "initial_qty":5, "initial_value":5, "status":"Active", "product_unit_oid":"PU-101", "product_category_oid":"PC-101", "created_by":"admin"}');

--Update Query
-- select "public".save_update_product('{"oid":"XN7nsK", "name":"Computer", "product_type":"Product", "selling_price":1200, "purchase_price":1000, "minimum_qty":1, "initial_qty":5, "initial_value":5, "status":"Active", "product_unit_oid":"PU-101", "product_category_oid":"PC-101", "created_by":"admin"}');

-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_02_03__product.sql

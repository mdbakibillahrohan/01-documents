set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".save_update_people(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_people(p_json json)
RETURNS varchar(128) AS $save_update_people$
    DECLARE
        v_people_oid                    varchar(128);
        v_company                       json;
        v_action_type                   varchar(64);
        v_description                   text;
        v_reference_id                  varchar(128);
    BEGIN    
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        if length(coalesce(p_json->>'oid', '')) = 0 then
            select get_transaction_id(v_company->>'oid', 'people') into v_people_oid;
            v_action_type := 'Save';
            v_reference_id := v_people_oid;
            insert into people (oid, name, mobile_no, email, people_type, payable_balance, 
            receivable_balance, designation_oid, department_oid, image_path, company_oid, created_by, status)
            values (v_people_oid, p_json->>'name',  p_json->>'mobile_no', p_json->>'email', 
                cast(p_json->>'people_type' as json),
                coalesce((p_json->>'payable_balance')::float, 0), 
                coalesce((p_json->>'receivable_balance')::float, 0),
                p_json->>'designation_oid', p_json->>'department_oid', NULLIF(p_json->>'image_path', ''), v_company->>'oid', p_json->>'created_by', p_json->>'status');
        else
            v_action_type := 'Update';
            v_reference_id := p_json->>'oid';
            update people set 
                name = p_json->>'name', mobile_no = p_json->>'mobile_no', email = p_json->>'email',
                people_type = cast(p_json->>'people_type' as json), 
                payable_balance = coalesce((p_json->>'payable_balance')::float, 0),
                receivable_balance = coalesce((p_json->>'receivable_balance')::float, 0),
                department_oid = p_json->>'department_oid', 
                designation_oid = p_json->>'designation_oid',
                image_path = p_json->>'image_path' 
                where oid = p_json->>'oid' and company_oid = v_company->>'oid';
        END IF;

        v_description := concat(v_action_type, ' ', p_json->>'name', ' as ', 
        string_agg(p_json->>'people_type', ', '), ' by ', v_company->>'login_id');
		insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
		values (v_description, v_reference_id, 'People', v_company->>'login_id', v_company->>'oid');
        return v_reference_id;
    END;
$save_update_people$ language plpgsql;

-- select "public".save_update_people('{ "name": "Tanim", "email": "tanim1109135@gmail.com", "people_type": ["Employee"], "company_oid": "C_DEMO", "created_by": "admin", "designation_oid": "Des-GM","department_oid": "Dept-Fin", "receivable_balance": 500, "payable_balance": 100, "status": "Active" }');
-- select "public".save_update_people('{ "oid": "RgzLNI", "name": "Rohan", "email": "tanim1109135@gmail.com", "people_type": ["Employee"], "company_oid": "C_DEMO", "created_by": "admin", "designation_oid": "Des-GM","department_oid": "Dept-Fin", "receivable_balance": 500, "payable_balance": 100, "status": "Active" }');

-- PGPASSWORD='gds' psql -h localhost -U gds -d gds -f ./R__05_05_00__people.sql

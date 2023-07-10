set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_ledger_subgroup_code(p_ledger_group_oid varchar(128), p_company_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".get_ledger_subgroup_code(p_ledger_group_oid varchar(128), p_company_oid varchar(128))
RETURNS varchar(4) AS $get_ledger_subgroup_code$
	DECLARE
        v_data                                      record;
  		v_ledger_subgroup_code 				        varchar(4);
    BEGIN
        select to_char((to_number(ledger_subgroup_code, 'FM9999') + 1), 'FM0000') into v_ledger_subgroup_code
        from ledger_subgroup
        where company_oid = p_company_oid
        and ledger_group_oid = p_ledger_group_oid
        order by to_number(ledger_subgroup_code, 'FM9999') desc
        limit 1;
        if v_ledger_subgroup_code is null then
            select * into v_data from ledger_group
            where oid = p_ledger_group_oid and company_oid = p_company_oid;
            v_ledger_subgroup_code := concat(v_data.ledger_group_code, '01');
        end if;
        return v_ledger_subgroup_code;
    END;
$get_ledger_subgroup_code$ language plpgsql;


DROP FUNCTION IF EXISTS "public".save_update_ledger_subgroup(p_json json);
CREATE OR REPLACE FUNCTION "public".save_update_ledger_subgroup(p_json json)
RETURNS varchar(128) AS $save_update_ledger_subgroup$
    DECLARE
        v_company                               json;
        v_ledger_group                          record;
        v_action_type                           varchar(64);
        v_oid                                   varchar(128);
        v_description                           text;
        v_ledger_subgroup_code 				    varchar(4);
    BEGIN
        select get_company_by_login_id(p_json->>'created_by') into v_company;
        select * into v_ledger_group from ledger_group where oid = p_json->>'ledger_group_oid' and company_oid = v_company->>'oid';
        if v_ledger_group.oid is null then
            return null;
        end if;

        if length(coalesce(p_json->>'oid', '')) = 0 then
            v_action_type := 'Save';
            select uuid() into v_oid;
            select get_ledger_subgroup_code(p_json->>'ledger_group_oid', v_company->>'oid')
            into v_ledger_subgroup_code;
            insert into ledger_subgroup (oid, ledger_subgroup_code, ledger_subgroup_name, ledger_subgroup_type, balance_sheet_item, ledger_group_oid, company_oid, created_by)
            values (v_oid, v_ledger_subgroup_code, p_json->>'ledger_subgroup_name', v_ledger_group.ledger_group_type, v_ledger_group.balance_sheet_item, p_json->>'ledger_group_oid', v_company->>'oid', v_company->>'login_id');
        else
            v_action_type := 'Update';
            v_oid := p_json->>'oid';
            update ledger_subgroup set ledger_subgroup_name = p_json->>'ledger_subgroup_name',
			ledger_group_oid = p_json->>'ledger_group_oid', ledger_subgroup_type = v_ledger_group.ledger_group_type,
			balance_sheet_item = v_ledger_group.balance_sheet_item, company_oid = v_company->>'oid',
			edited_by = v_company->>'login_id', edited_on = clock_timestamp()
            where oid = v_oid and company_oid = v_company->>'oid';
        end if;

        -- ledger subgroup as save/update by admin
        v_description := concat('Ledger Subgroup ', p_json->>'ledger_subgroup_name', ' as ' v_action_type, ' by ', v_company->>'login_id');
        insert into activity_log (description, reference_id, reference_name, created_by, company_oid)
        values (v_description, v_oid, 'ledger_subgroup', v_company->>'login_id', v_company->>'oid');
        return v_oid;
    END;
$save_update_ledger_subgroup$ LANGUAGE plpgsql;

-- select "public".save_update_ledger_subgroup('{"oid": "","ledger_subgroup_name": "Operating Expenses", "ledger_group_oid": "lg-demo-03","created_by":"admin"}');
-- PGPASSWORD='password' psql -U postgres -d gds -f ./R__05_04_03__save_update_ledger_subgroup.sql

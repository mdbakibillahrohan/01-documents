
set client_min_messages = 'warning';


DROP FUNCTION IF EXISTS "public".get_ledger_oid(p_company_oid varchar(128), p_ledger_key varchar(64));


CREATE OR REPLACE FUNCTION "public".get_ledger_oid(p_company_oid varchar(128), p_ledger_key varchar(64)) RETURNS varchar(128) AS $get_ledger_oid$
    DECLARE
        v_ledger_oid                varchar(128);
    BEGIN
        select ledger_oid
        into v_ledger_oid
        from ledger_setting
        where company_oid = p_company_oid
        and ledger_key = p_ledger_key;
        return v_ledger_oid;
    END;
$get_ledger_oid$ language plpgsql;


DROP FUNCTION IF EXISTS "public".get_subledger_oid(p_company_oid varchar(128), p_reference_oid varchar(128), p_ledger_key varchar(64));


CREATE OR REPLACE FUNCTION "public".get_subledger_oid(p_company_oid varchar(128), p_reference_oid varchar(128), p_ledger_key varchar(64)) RETURNS varchar(128) AS $get_subledger_oid$
    DECLARE
        v_sub_ledger_oid                varchar(128);
    BEGIN
        select oid
        into v_sub_ledger_oid
        from subledger
        where company_oid = p_company_oid
        and reference_oid = p_reference_oid
        and ledger_oid = (select ledger_oid from ledger_setting where ledger_key = p_ledger_key and company_oid = p_company_oid);
        return v_sub_ledger_oid;
    END;
$get_subledger_oid$ language plpgsql;


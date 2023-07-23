set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_new_ledger_balance(p_ledger_oid varchar(128), p_debited_amount float, p_credited_amount float);
CREATE OR REPLACE FUNCTION "public".get_new_ledger_balance(p_ledger_oid varchar(128), p_debited_amount float default 0, p_credited_amount float default 0) 
RETURNS float AS $get_new_ledger_balance$
    DECLARE
        v_ledger_balance                    float;
        v_debit_type                        varchar(16) := 'Debit';
        v_credit_type                       varchar(16) := 'Credit';
    BEGIN 
        select coalesce ((
            select (
                case when ledger_type = v_debit_type and p_debited_amount > p_credited_amount then (ledger_balance + p_debited_amount)
                when ledger_type = v_debit_type and p_debited_amount < p_credited_amount then (ledger_balance - p_credited_amount)
                when ledger_type = v_credit_type and p_debited_amount > p_credited_amount then (ledger_balance - p_debited_amount)
                when ledger_type = v_credit_type and p_debited_amount < p_credited_amount then (ledger_balance + p_credited_amount)
                else 0 end
            )
            from ledger
            where oid = p_ledger_oid
        ), 0) into v_ledger_balance;
        return v_ledger_balance;
    END;
$get_new_ledger_balance$ language plpgsql;

DROP FUNCTION IF EXISTS "public".get_new_subledger_balance(p_subledger_oid varchar(128), p_debited_amount float, p_credited_amount float);
CREATE OR REPLACE FUNCTION "public".get_new_subledger_balance(p_subledger_oid varchar(128), p_debited_amount float default 0, p_credited_amount float default 0)
RETURNS float AS $get_new_subledger_balance$
    DECLARE
        v_subledger_balance                      float;
        v_debit_type                             varchar(16) := 'Debit';
        v_credit_type                            varchar(16) := 'Credit';
    BEGIN
        select coalesce ((
            select (
                case when subledger_type = v_debit_type and p_debited_amount > p_credited_amount then (subledger_balance + p_debited_amount)
                when subledger_type = v_debit_type and p_debited_amount < p_credited_amount then (subledger_balance - p_credited_amount)
                when subledger_type = v_credit_type and p_debited_amount > p_credited_amount then (subledger_balance - p_debited_amount)
                when subledger_type = v_credit_type and p_debited_amount < p_credited_amount then (subledger_balance + p_credited_amount)
                else 0 end
            )
            from subledger 
            where oid = p_subledger_oid
        ), 0) into v_subledger_balance;
    END;
$get_new_subledger_balance$ language plpgsql;

DROP FUNCTION IF EXISTS "public".post_journal(p_data json);
CREATE OR REPLACE FUNCTION "public".post_journal(p_data json)
RETURNS void AS $post_journal$
    DECLARE
        v_amount                        record;
        v_journal                       json;
        v_ledger_balance                float;
        v_subledger_balance             float;
        v_debited_amount                float;
        v_credited_amount               float;
        v_counter                       int := 0;
        v_js_oid                        varchar(128);
        v_company                       json;
        v_fp                            json;
        v_debit_type                    varchar(16) := 'Debit';
        v_credit_type                   varchar(16) := 'Credit';
    BEGIN
        select get_company_by_login_id(p_data->>'created_by') into v_company;
        select get_financial_period_by_company_oid(v_company->>'oid') into v_fp;

        select sum((t->>'debited_amount')::float) as debited_amount, sum((t->>'credited_amount')::float) as credited_amount 
        into v_amount 
        from json_array_elements((p_data->>'journal_list')::json) t;

        if v_amount.debited_amount != v_amount.credited_amount then 
            raise exception 'debit amount is not equal to credit amount for %', v_company->>'short_name';
            return;
        end if;

        select uuid() into v_js_oid;

        insert into journal_summary (oid, journal_date, journal_type, journal_manner, description, amount, reference_no,   financial_period_oid, company_oid, created_by)
        values (v_js_oid, current_data, nullif(p_data->>'journal_type', ''), coalesce(p_data->>'journal_manner', 'Auto'),
        nullif(p_data->>'description', ''), v_amount.credited_amount, 
        nullif(p_data->>'reference_no', ''), v_fp->>'oid', v_company->>'oid', p_data->>'created_by');

        FOR v_journal in select * from json_array_elements((p_data->>'journal_list')::json) Loop 
                v_counter := v_counter + 1;
                v_debited_amount := coalesce((v_journal->>'debited_amount')::float, 0);
                v_credited_amount := coalesce((v_journal->>'credited_amount')::float, 0);

                select get_new_ledger_balance(v_journal->>'ledger_oid', v_debited_amount, v_credited_amount) into v_ledger_balance;
                if length(coalesce(v_journal->>'subledger_oid', '')) != 0 then 
                    select get_new_subledger_balance(v_journal->>'subledger_oid', v_debited_amount, v_credited_amount) into v_subledger_balance;
                end if;

            insert into journal (oid, entry_no, description, debited_amount, credited_amount, ledger_oid, ledger_balance, subledger_oid, subledger_balance, journal_summary_oid,  financial_period_oid, company_oid, created_by)
            values (uuid(), v_counter, nullif(v_journal->>'description', ''), v_debited_amount, v_credited_amount, v_journal->>'ledger_oid', v_ledger_balance, nullif(v_journal->>'subledger_oid', ''), v_subledger_balance,
            v_js_oid, v_fp->>'oid', v_company->>'oid', p_data->>'created_by');

            update ledger set ledger_balance = v_ledger_balance 
            where oid = v_journal->>'ledger_oid';

            if length(coalesce(v_journal->>'subledger_oid', '')) != 0 then 
                update subledger set subledger_balance = v_subledger_balance
                where oid = v_journal->>'subledger_oid';
            end if;
        END LOOP;
    END;
$post_journal$ language plpgsql;

--save journal
-- select "public".post_journal('{"description": "", "amount": "12", "reference_no":  '11', "journal_list": [{"ledger_oid": "", "description": "", "subLedger_oid": "", "debited_amount": "", "credited_amount": "" }, {"ledger_oid": "", "description": "", "subLedger_oid": "", "debited_amount": "", "credited_amount": "" }] }');

--PGPASSWORD='password' psql -h localhost -U postgres -d gds -f ./R__05_03_05__journal.sql
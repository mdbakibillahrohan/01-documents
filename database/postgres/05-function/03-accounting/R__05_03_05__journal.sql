DROP FUNCTION IF EXISTS "public".post_journal(p_data json);


CREATE OR REPLACE FUNCTION "public".post_journal(p_data json) RETURNS void AS $post_journal$
    DECLARE
        v_amount                                record;
        v_journal                               json;
        v_ledger_balance                        float;
        v_subledger_balance                     float;
        v_debited_amount                        float;
        v_credited_amount                       float;
        v_counter				                int := 0;
        v_js_oid                                varchar(128);
        v_company                               json;
        v_fp                                    json;
        v_debit_type                            varchar(16) := 'Debit';
        v_credit_type                           varchar(16) := 'Credit';
    BEGIN
        select get_company_by_login_id(p_data->>'created_by') into v_company;
        select get_financial_period_by_company_oid(v_company->>'oid') into v_fp;

        select sum((t->> 'debited_amount')::float) as debited_amount, sum((t->> 'credited_amount')::float) as credited_amount
        into v_amount
        from json_array_elements((p_data->>'journal_list')::json) t;

        if v_amount.debited_amount != v_amount.credited_amount then
            raise exception 'debit amount is not equal to credit amount for %', v_company->>'mnemonic';
            return;
        end if;

        select uuid() into v_js_oid;

        insert into journal_summary (oid, journal_date, journal_type, journal_manner, description, amount,
            reference_no, financial_period_oid, company_oid, created_by)
        values (v_js_oid, current_date, nullif(p_data->>'journal_type', ''), coalesce(p_data->>'journal_manner', 'Auto'),
            nullif(p_data->>'description', ''), v_amount.credited_amount,
            nullif(p_data->>'reference_no', ''), v_fp->>'oid', v_company->>'oid', p_data->>'created_by');

        FOR v_journal in select * from json_array_elements((p_data->>'journal_list')::json) LOOP
            v_counter := v_counter + 1;
            v_debited_amount := coalesce((v_journal->>'debited_amount')::float, 0);
            v_credited_amount := coalesce((v_journal->>'credited_amount')::float, 0);

            select get_new_ledger_balance(v_journal->>'ledger_oid', v_debited_amount, v_credited_amount) into v_ledger_balance;
            select get_new_subledger_balance(v_journal->>'subledger_oid', v_debited_amount, v_credited_amount) into v_subledger_balance;

        	insert into journal (oid, entry_no, description, debited_amount, credited_amount, ledger_oid, ledger_balance,
                subledger_oid, subledger_balance, journal_summary_oid, financial_period_oid, company_oid, created_by)
	        values (uuid(), v_counter, nullif(v_journal->>'description', ''), v_debited_amount, v_credited_amount,
                v_journal->>'ledger_oid', v_ledger_balance, v_journal->>'subledger_oid', v_subledger_balance,
    	        v_js_oid, v_fp->>'oid', v_company->>'oid', p_data->>'created_by');

	       	update ledger set ledger_balance = v_ledger_balance
        	where oid = v_journal->>'ledger_oid';

	       	update subledger set subledger_balance = v_subledger_balance
        	where oid = v_journal->>'subledger_oid';
        END LOOP;
    END;
$post_journal$ language plpgsql;


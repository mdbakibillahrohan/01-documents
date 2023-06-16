set client_min_messages = 'warning';

DROP FUNCTION IF EXISTS "public".get_transaction_id(p_oid varchar(128), p_table_name varchar(128));
CREATE OR REPLACE FUNCTION "public".get_transaction_id(p_oid varchar(128), p_table_name varchar(128))
RETURNS text AS $get_transaction_id$
    DECLARE
  		random_string 				varchar(6);
    BEGIN
        LOOP
            select code
            into random_string
            from reserve_transaction_id
            where company_oid = p_oid
            FETCH FIRST ROW ONLY;
            if random_string is null then
            	perform "public".calculate_and_generate_transaction_id(p_oid);
            	continue;
            end if;
            BEGIN
                EXECUTE FORMAT('insert into transaction_id(code, company_oid, table_name) values (%L, %L, %L)', random_string, p_oid, p_table_name);
                EXECUTE FORMAT('delete from reserve_transaction_id where code = %L', random_string);
                RETURN random_string;
            EXCEPTION WHEN unique_violation THEN

            END;
        END LOOP;
    END;
$get_transaction_id$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS "public".generate_reserve_transaction_id(p_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".generate_reserve_transaction_id(p_oid varchar(128))
RETURNS void AS $generate_reserve_transaction_id$
    DECLARE
  		alphanum 		CONSTANT 	varchar(64) := 'ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijklmnpqrstuvwxyz123456789';
  		range_head 		CONSTANT 	int := 50;
  		range_tail 		CONSTANT 	int := 60;
  		random_string 				varchar(6);
  		_length						int := 6;
  		ct 							int;
    BEGIN
  		LOOP
    		SELECT substring(alphanum from trunc(random() * range_head + 1)::integer for 1) ||
      		array_to_string(array_agg(substring(alphanum from trunc(random() * range_tail + 1)::integer for 1)), '')
      		INTO random_string
            FROM generate_series(1, _length - 1);
    		EXECUTE FORMAT('select count(a.code) from (select code from reserve_transaction_id union all select code from transaction_id) a where a.code = %L', random_string) INTO ct;
    		if ct = 0 then
    			EXECUTE FORMAT('insert into reserve_transaction_id(code, company_oid) values (%L, %L)', random_string, p_oid);
    			EXIT;
    		end if;
  		END LOOP;
    END;
$generate_reserve_transaction_id$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS "public".calculate_and_generate_transaction_id(p_oid varchar(128));
CREATE OR REPLACE FUNCTION "public".calculate_and_generate_transaction_id(p_oid varchar(128) default null)
RETURNS void AS $calculate_and_generate_transaction_id$
    DECLARE
        c                                   record;
        v_sql                 	            text;
        counter                             int8;
        no_company                          int4 := 0;
        reserve_code                        int8 := 0;
        qr_code                             int8 := 0;
        require_qr_code                     int8 := 0;
        reserve_pct                         int4 := 0;
        chk_reserve_pct                     int4 := 25;
        default_code                        int4 := 5000;
        generated_code_pct                  float4 := 40.0;
    BEGIN
		RAISE INFO '% - Starting - %', to_char(clock_timestamp(), 'YYYY-MM-DD HH24:MI:SS.MS'), 'calculate_and_generate_transaction_id';
		select format('select oid from company where 1 = 1 and status = %L', 'Active') into v_sql;
		if p_oid is not null then
			v_sql := concat(v_sql, format(' and oid = %L', p_oid));
		end if;
		v_sql := concat(v_sql, ' order by oid asc');
		FOR c IN EXECUTE v_sql LOOP
            EXECUTE FORMAT('select count(*) from reserve_transaction_id where company_oid = %L', c.oid) into reserve_code;
            EXECUTE FORMAT('select count(*) from transaction_id where company_oid = %L', c.oid) into qr_code;

            if (reserve_code + qr_code) = 0 then
                FOR counter in 1..default_code LOOP
                    EXECUTE FORMAT('select generate_reserve_transaction_id(%L)', c.oid);
                END LOOP;
                EXECUTE FORMAT('select count(*) from reserve_transaction_id where company_oid = %L', c.oid) into reserve_code;
                EXECUTE FORMAT('select count(*) from transaction_id where company_oid = %L', c.oid) into qr_code;
            end if;

            select floor((reserve_code::float/(reserve_code + qr_code)) * 100)::int into reserve_pct;
            continue when reserve_pct > chk_reserve_pct;
            no_company := no_company + 1;
            select floor((reserve_code + qr_code) * (generated_code_pct/100))::int into require_qr_code;

            FOR counter in 1..require_qr_code LOOP
                EXECUTE FORMAT('select generate_reserve_transaction_id(%L)', c.oid);
            END LOOP;
            RAISE INFO '% - %-% existing code - %, generated - %', to_char(clock_timestamp(), 'YYYY-MM-DD HH24:MI:SS.MS'),
                trim(to_char(no_company,'00')), c.oid, concat(reserve_pct, '%'), require_qr_code;
        END LOOP;
    	RAISE INFO '% - Terminated - %', to_char(clock_timestamp(), 'YYYY-MM-DD HH24:MI:SS.MS'), 'calculate_and_generate_transaction_id';
    END
$calculate_and_generate_transaction_id$ LANGUAGE plpgsql;


-- select "public".calculate_and_generate_transaction_id();
-- PGPASSWORD='gds' psql -U gds -d gds -f ./R__05_00_09__transaction-id.sql

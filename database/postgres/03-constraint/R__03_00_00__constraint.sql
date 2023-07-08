set client_min_messages = 'warning';

alter table if exists ledger_setting drop constraint if exists uk_ledger_key_company_ledger_setting;
alter table ledger_setting add constraint uk_ledger_key_company_ledger_setting unique (ledger_key, company_oid);

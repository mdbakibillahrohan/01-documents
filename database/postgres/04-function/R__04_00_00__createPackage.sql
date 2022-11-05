-- DROP FUNCTION IF EXISTS increment(INT);
CREATE OR REPLACE FUNCTION increment(i INT)
	RETURNS INT AS
$$
    BEGIN
      RETURN i + 1;
    END;
$$
LANGUAGE plpgsql;

-- An example how to use the function (Returns: 11)
-- SELECT increment(10);

-- DROP FUNCTION IF EXISTS supplier_balance(varchar(128));
CREATE OR REPLACE FUNCTION supplier_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $supplier_balance$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select coalesce(initialbalance, 0) from Supplier where 1 = 1 and oid = p_oid);
		bill_payble					NUMERIC(18,2) := (select coalesce(sum(payableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and supplierOid = p_oid);
		total_paid_balance			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid);
		refund_credit_note_balance	NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.paymentoid = p.oid and p.referenceoid = p_oid and p.paymentnature = 'CreditNote' and p.paymentType = 'Debit' and p.referenceType = 'Supplier');
		refund_cash_amount			NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.paymentoid = p.oid and p.referenceoid = p_oid and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Credit' and p.referenceType = 'Supplier');
    BEGIN
	  RETURN (initial_balance + bill_payble) - (total_paid_balance - refund_credit_note_balance - refund_cash_amount);
    END;
$supplier_balance$ LANGUAGE plpgsql;
-- SELECT supplier_balance('10');

-- DROP FUNCTION IF EXISTS supplier_balance_before_date(varchar(128));
CREATE OR REPLACE FUNCTION supplier_balance_before_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $supplier_balance_before_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select coalesce(initialbalance, 0) from Supplier where 1 = 1 and oid = p_oid);
		bill_payble					NUMERIC(18,2) := (select coalesce(sum(payableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and supplierOid = p_oid and invoiceDate < to_date(p_date, 'YYYY-MM-DD')::date);
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN (initial_balance + bill_payble) - payment_balance;
    END;
$supplier_balance_before_date$ LANGUAGE plpgsql;
-- SELECT supplier_balance_before_date('10');

-- DROP FUNCTION IF EXISTS supplier_balance_till_date(varchar(128));
CREATE OR REPLACE FUNCTION supplier_balance_till_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $supplier_balance_till_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select coalesce(initialbalance, 0) from Supplier where 1 = 1 and oid = p_oid);
		bill_payble					NUMERIC(18,2) := (select coalesce(sum(payableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and supplierOid = p_oid);
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN (initial_balance + bill_payble) - payment_balance;
    END;
$supplier_balance_till_date$ LANGUAGE plpgsql;
-- SELECT supplier_balance_till_date('10');

-- DROP FUNCTION IF EXISTS customer_balance(varchar(128));
CREATE OR REPLACE FUNCTION customer_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $customer_balance$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Customer where oid = p_oid);
		invoice_receivable			NUMERIC(18,2) := (select coalesce(sum(receivableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and customerOid = p_oid);
		total_received_balance		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid);
		refund_credit_note_balance	NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.paymentoid = p.oid and p.referenceoid = p_oid and p.paymentnature = 'CreditNote' and p.paymentType = 'Credit' and p.referenceType = 'Customer');
		refund_cash_amount			NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.paymentoid = p.oid and p.referenceoid = p_oid and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Debit' and p.referenceType = 'Customer');
    BEGIN
      RETURN (initial_balance + invoice_receivable) - (total_received_balance - refund_credit_note_balance - refund_cash_amount);
    END;
$customer_balance$ LANGUAGE plpgsql;
-- SELECT customer_balance('10');

-- DROP FUNCTION IF EXISTS customer_balance_before_date(varchar(128));
CREATE OR REPLACE FUNCTION customer_balance_before_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $customer_balance_before_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Customer where oid = p_oid);
		invoice_receivable			NUMERIC(18,2) := (select coalesce(sum(receivableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and customerOid = p_oid and invoiceDate < to_date(p_date, 'YYYY-MM-DD')::date);
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN (initial_balance + invoice_receivable) - payment_balance;
    END;
$customer_balance_before_date$ LANGUAGE plpgsql;
-- SELECT customer_balance_before_date('10');

-- DROP FUNCTION IF EXISTS customer_balance_till_date(varchar(128));
CREATE OR REPLACE FUNCTION customer_balance_till_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $customer_balance_till_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Customer where oid = p_oid);
		invoice_receivable			NUMERIC(18,2) := (select coalesce(sum(receivableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and customerOid = p_oid);
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN (initial_balance + invoice_receivable) - payment_balance;
    END;
$customer_balance_till_date$ LANGUAGE plpgsql;
-- SELECT customer_balance_till_date('10');

-- DROP FUNCTION IF EXISTS supplier_creditnote_balance(varchar(128));
CREATE OR REPLACE FUNCTION supplier_creditnote_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $supplier_creditnote_balance$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'CreditNote' and referenceType = 'Supplier' and referenceOid = p_oid);
		creditnote_withdraw			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'Withdraw' and referenceType = 'Supplier' and referenceOid = p_oid);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Supplier' and referenceOid = p_oid);
    BEGIN
		RETURN creditnote_receivable - (creditnote_withdraw + creditnote_adjustment);
    END;
$supplier_creditnote_balance$ LANGUAGE plpgsql;
-- SELECT supplier_creditnote_balance('10');

-- DROP FUNCTION IF EXISTS supplier_creditnote_balance_before_date(varchar(128));
CREATE OR REPLACE FUNCTION supplier_creditnote_balance_before_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $supplier_creditnote_balance_before_date$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'CreditNote' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_withdraw			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'Withdraw' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      	RETURN creditnote_receivable - (creditnote_withdraw + creditnote_adjustment);
    END;
$supplier_creditnote_balance_before_date$ LANGUAGE plpgsql;
-- SELECT supplier_creditnote_balance_before_date('10');

-- DROP FUNCTION IF EXISTS supplier_creditnote_balance_till_date(varchar(128));
CREATE OR REPLACE FUNCTION supplier_creditnote_balance_till_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $supplier_creditnote_balance_till_date$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'CreditNote' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_withdraw			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'Withdraw' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Supplier' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      	RETURN creditnote_receivable - (creditnote_withdraw + creditnote_adjustment);
    END;
$supplier_creditnote_balance_till_date$ LANGUAGE plpgsql;
-- SELECT supplier_creditnote_balance_till_date('10');

-- DROP FUNCTION IF EXISTS customer_creditnote_balance(varchar(128));
CREATE OR REPLACE FUNCTION customer_creditnote_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $customer_creditnote_balance$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'CreditNote' and referenceType = 'Customer' and referenceOid = p_oid);
		creditnote_withdraw_credit	NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'Withdraw' and referenceType = 'Customer' and referenceOid = p_oid);
		creditnote_withdraw_debit	NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'Withdraw' and referenceType = 'Customer' and referenceOid = p_oid);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Customer' and referenceOid = p_oid);
    BEGIN
      RETURN creditnote_receivable - (creditnote_withdraw_credit + creditnote_withdraw_debit + creditnote_adjustment);
    END;
$customer_creditnote_balance$ LANGUAGE plpgsql;
-- SELECT customer_creditnote_balance('10');

-- DROP FUNCTION IF EXISTS customer_creditnote_balance_before_date(varchar(128));
CREATE OR REPLACE FUNCTION customer_creditnote_balance_before_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $customer_creditnote_balance_before_date$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'CreditNote' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_withdraw			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'Withdraw' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN creditnote_receivable - (creditnote_withdraw + creditnote_adjustment);
    END;
$customer_creditnote_balance_before_date$ LANGUAGE plpgsql;
-- SELECT customer_creditnote_balance_before_date('10');

-- DROP FUNCTION IF EXISTS customer_creditnote_balance_till_date(varchar(128));
CREATE OR REPLACE FUNCTION customer_creditnote_balance_till_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $customer_creditnote_balance_till_date$
    DECLARE
		creditnote_receivable		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Credit' and paymentNature = 'CreditNote' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_withdraw			NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentType = 'Debit' and paymentNature = 'Withdraw' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
		creditnote_adjustment		NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and paymentNature = 'CreditNoteAdjustment' and referenceType = 'Customer' and referenceOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN creditnote_receivable - (creditnote_withdraw + creditnote_adjustment);
    END;
$customer_creditnote_balance_till_date$ LANGUAGE plpgsql;
-- SELECT customer_creditnote_balance_till_date('10');

-- DROP FUNCTION IF EXISTS account_balance(varchar(128));
CREATE OR REPLACE FUNCTION account_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $account_balance$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Account where oid = p_oid);
		transaction_balance			NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN transactionType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN transactionType = 'Debit' THEN amount ELSE 0 END)), 0)) from AccountTransaction where 1 = 1 and status = 'Active' and accountOid = p_oid);
		payment_balance				NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN paymentType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN paymentType = 'Debit' THEN amount ELSE 0 END)), 0)) from Payment where 1 = 1 and status = 'Active' and accountOid = p_oid);
    BEGIN
      RETURN initial_balance + transaction_balance + payment_balance;
    END;
$account_balance$ LANGUAGE plpgsql;
-- SELECT account_balance('10');

-- DROP FUNCTION IF EXISTS account_balance_before_date(varchar(128));
CREATE OR REPLACE FUNCTION account_balance_before_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $account_balance_before_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Account where oid = p_oid);
		transaction_balance			NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN transactionType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN transactionType = 'Debit' THEN amount ELSE 0 END)), 0)) from AccountTransaction where 1 = 1 and status = 'Active' and accountOid = p_oid and transactionDate < to_date(p_date, 'YYYY-MM-DD')::date);
		payment_balance				NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN paymentType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN paymentType = 'Debit' THEN amount ELSE 0 END)), 0)) from Payment where 1 = 1 and status = 'Active' and accountOid = p_oid and paymentDate < to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN initial_balance + transaction_balance + payment_balance;
    END;
$account_balance_before_date$ LANGUAGE plpgsql;
-- SELECT account_balance_before_date('10');

-- DROP FUNCTION IF EXISTS account_balance_till_date(varchar(128));
CREATE OR REPLACE FUNCTION account_balance_till_date(p_oid varchar(128), p_date varchar(32))
RETURNS numeric(18, 2) AS $account_balance_till_date$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select initialbalance from Account where oid = p_oid);
		transaction_balance			NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN transactionType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN transactionType = 'Debit' THEN amount ELSE 0 END)), 0)) from AccountTransaction where 1 = 1 and status = 'Active' and accountOid = p_oid and transactionDate <= to_date(p_date, 'YYYY-MM-DD')::date);
		payment_balance				NUMERIC(18,2) := (select (coalesce(sum((CASE WHEN paymentType = 'Credit' THEN amount ELSE 0 END)), 0)) -(coalesce(sum((CASE WHEN paymentType = 'Debit' THEN amount ELSE 0 END)), 0)) from Payment where 1 = 1 and status = 'Active' and accountOid = p_oid and paymentDate <= to_date(p_date, 'YYYY-MM-DD')::date);
    BEGIN
      RETURN initial_balance + transaction_balance + payment_balance;
    END;
$account_balance_till_date$ LANGUAGE plpgsql;
-- SELECT account_balance_till_date('10');

-- DROP FUNCTION IF EXISTS company_account_receivable(varchar(128));
CREATE OR REPLACE FUNCTION company_account_receivable(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_account_receivable$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select coalesce(sum(initialbalance), 0) from Customer where 1 = 1 and companyOid = p_companyOid);
		invoice_ticket_receivable			NUMERIC(18,2) := (select coalesce(sum(receivableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and companyOid = p_companyOid);
    BEGIN
      RETURN (initial_balance + invoice_ticket_receivable);
    END;
$company_account_receivable$ LANGUAGE plpgsql;
-- SELECT company_account_receivable('10');

-- DROP FUNCTION IF EXISTS company_account_payable(varchar(128));
CREATE OR REPLACE FUNCTION company_account_payable(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_account_payable$
    DECLARE
		initial_balance				NUMERIC(18,2) := (select coalesce(sum(initialbalance), 0) from Supplier where 1 = 1 and companyOid = p_companyOid);
		bill_ticket_payable			NUMERIC(18,2) := (select coalesce(sum(payableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Active' and companyOid = p_companyOid);
    BEGIN
      RETURN (initial_balance + bill_ticket_payable);
    END;
$company_account_payable$ LANGUAGE plpgsql;
-- SELECT company_account_payable('10');

-- DROP FUNCTION IF EXISTS company_paid_account_receivable(varchar(128));
CREATE OR REPLACE FUNCTION company_paid_account_receivable(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_paid_account_receivable$
    DECLARE
		paid_account_receivable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'CashAdjustment' or paymentNature = 'CreditNoteAdjustment'));
		refund_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and p.companyOid = p_companyOid and p.status = 'Active' and ibp.paymentoid = p.oid and p.paymentType = 'Credit' and p.paymentNature = 'CreditNote' and p.referencetype = 'Customer');
		refund_cash_amount					NUMERIC(18,2) := (select coalesce(sum(p.amount), 0) from Payment p  where 1 = 1 and p.companyOid = p_companyOid and p.status = 'Active' and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Debit' and p.referenceType = 'Customer');
    BEGIN
      RETURN (paid_account_receivable - refund_received_amount - refund_cash_amount);
    END;
$company_paid_account_receivable$ LANGUAGE plpgsql;
-- SELECT company_paid_account_receivable('10');

-- DROP FUNCTION IF EXISTS company_paid_account_payable(varchar(128));
CREATE OR REPLACE FUNCTION company_paid_account_payable(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_paid_account_payable$
    DECLARE
		paid_account_payable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'CashAdjustment' or paymentNature = 'CreditNoteAdjustment'));
		refund_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and p.companyOid = p_companyOid and p.status = 'Active' and ibp.paymentoid = p.oid and p.paymentType = 'Debit' and p.paymentNature = 'CreditNote' and p.referencetype = 'Supplier');
		refund_cash_amount					NUMERIC(18,2) := (select coalesce(sum(p.amount), 0) from Payment p  where 1 = 1 and p.companyOid = p_companyOid and p.status = 'Active' and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Credit' and p.referenceType = 'Supplier');
    BEGIN
      RETURN (paid_account_payable - refund_received_amount - refund_cash_amount);
    END;
$company_paid_account_payable$ LANGUAGE plpgsql;
-- SELECT company_paid_account_payable('10');

-- DROP FUNCTION IF EXISTS company_vendor_credit(varchar(128));
CREATE OR REPLACE FUNCTION company_vendor_credit(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_vendor_credit$
    DECLARE
		paid_account_payable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Supplier' and paymentNature = 'CreditNote');
    BEGIN
      RETURN (paid_account_payable);
    END;
$company_vendor_credit$ LANGUAGE plpgsql;
-- SELECT company_vendor_credit('10');

-- DROP FUNCTION IF EXISTS company_credit_note(varchar(128));
CREATE OR REPLACE FUNCTION company_credit_note(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_credit_note$
    DECLARE
		paid_account_payable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Customer' and paymentNature = 'CreditNote');
    BEGIN
      RETURN (paid_account_payable);
    END;
$company_credit_note$ LANGUAGE plpgsql;
-- SELECT company_credit_note('10');

-- DROP FUNCTION IF EXISTS company_paid_vendor_credit(varchar(128));
CREATE OR REPLACE FUNCTION company_paid_vendor_credit(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_paid_vendor_credit$
    DECLARE
		paid_account_payable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'Withdraw' or paymentNature = 'CreditNoteAdjustment'));
    BEGIN
      RETURN (paid_account_payable);
    END;
$company_paid_vendor_credit$ LANGUAGE plpgsql;
-- SELECT company_paid_vendor_credit('10');

-- DROP FUNCTION IF EXISTS company_paid_credit_note(varchar(128));
CREATE OR REPLACE FUNCTION company_paid_credit_note(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $company_paid_credit_note$
    DECLARE
		paid_account_payable				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and companyOid = p_companyOid and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'Withdraw' or paymentNature = 'CreditNoteAdjustment'));
    BEGIN
      RETURN (paid_account_payable);
    END;
$company_paid_credit_note$ LANGUAGE plpgsql;
-- SELECT company_paid_credit_note('10');

-- DROP FUNCTION IF EXISTS customer_draft_ticket_invoice_balance(varchar(128));
CREATE OR REPLACE FUNCTION customer_draft_ticket_invoice_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $customer_draft_ticket_invoice_balance$
    DECLARE
		invoice_receivable			NUMERIC(18,2) := (select coalesce(sum(receivableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Draft' and customerOid = p_oid);
    BEGIN
      RETURN invoice_receivable;
    END;
$customer_draft_ticket_invoice_balance$ LANGUAGE plpgsql;
-- SELECT customer_draft_ticket_invoice_balance('10');


-- DROP FUNCTION IF EXISTS supplier_draft_ticket_invoice_balance(varchar(128));
CREATE OR REPLACE FUNCTION supplier_draft_ticket_invoice_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $supplier_draft_ticket_invoice_balance$
    DECLARE
		invoice_payable			NUMERIC(18,2) := (select coalesce(sum(payableAmount), 0) from TicketInvoice where 1 = 1 and status = 'Draft' and supplierOid = p_oid);
    BEGIN
      RETURN invoice_payable;
    END;
$supplier_draft_ticket_invoice_balance$ LANGUAGE plpgsql;
-- SELECT supplier_draft_ticket_invoice_balance('10');

-- DROP FUNCTION IF EXISTS customer_received_balance(varchar(128));
CREATE OR REPLACE FUNCTION customer_received_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $customer_received_balance$
    DECLARE
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Customer' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid);
    BEGIN
      RETURN payment_balance;
    END;
$customer_received_balance$ LANGUAGE plpgsql;
-- SELECT customer_received_balance('10');

-- DROP FUNCTION IF EXISTS supplier_paid_balance(varchar(128));
CREATE OR REPLACE FUNCTION supplier_paid_balance(p_oid varchar(128))
RETURNS numeric(18, 2) AS $supplier_paid_balance$
    DECLARE
		payment_balance				NUMERIC(18,2) := (select coalesce(sum(amount), 0) from Payment where 1 = 1 and status = 'Active' and referenceType = 'Supplier' and (paymentNature = 'CreditNoteAdjustment' or paymentNature = 'CashAdjustment') and referenceOid = p_oid);
    BEGIN
      RETURN payment_balance;
    END;
$supplier_paid_balance$ LANGUAGE plpgsql;
-- SELECT supplier_paid_balance('10');

-- DROP FUNCTION IF EXISTS ticket_invoice_received_amount(varchar(128));
/*CREATE OR REPLACE FUNCTION ticket_invoice_received_amount(p_customerOid varchar(128), p_invoiceOid varchar(128))
RETURNS numeric(18, 2) AS $ticket_invoice_received_amount$
    DECLARE
		invoice_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentType != 'Debit');
		refund_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentType = 'Debit');
    BEGIN
      RETURN (invoice_received_amount - refund_received_amount);
    END;
$ticket_invoice_received_amount$ LANGUAGE plpgsql;*/


-- DROP FUNCTION IF EXISTS ticket_invoice_received_amount(varchar(128));
CREATE OR REPLACE FUNCTION ticket_invoice_received_amount(p_customerOid varchar(128), p_invoiceOid varchar(128))
RETURNS numeric(18, 2) AS $ticket_invoice_received_amount$
    DECLARE
		invoice_cash_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentnature = 'CashAdjustment' and p.paymentType = 'Credit' and p.referenceType = 'Customer');
		invoice_credit_note_adjustment_amount		NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentnature = 'CreditNoteAdjustment' and p.referenceType = 'Customer');
		invoice_refund_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentnature = 'CreditNote' and p.paymentType = 'Credit' and p.referenceType = 'Customer');
		invoice_refund_cash_amount					NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_customerOid and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Debit' and p.referenceType = 'Customer');
    BEGIN
      RETURN ((invoice_cash_received_amount + invoice_credit_note_adjustment_amount) - (invoice_refund_received_amount + invoice_refund_cash_amount));
    END;
$ticket_invoice_received_amount$ LANGUAGE plpgsql;
-- SELECT ticket_invoice_received_amount('10', '10');

-- DROP FUNCTION IF EXISTS ticket_invoice_paid_amount(varchar(128));
CREATE OR REPLACE FUNCTION ticket_invoice_paid_amount(p_supplierOid varchar(128), p_invoiceOid varchar(128))
RETURNS numeric(18, 2) AS $ticket_invoice_paid_amount$
	DECLARE
		bill_cash_paid_amount					NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_supplierOid and p.paymentnature = 'CashAdjustment' and p.paymentType = 'Debit' and p.referenceType = 'Supplier');
		bill_vendor_credit_adjustment_amount	NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_supplierOid and p.paymentnature = 'CreditNoteAdjustment' and p.referenceType = 'Supplier');
		bill_refund_received_amount				NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_supplierOid and p.paymentnature = 'CreditNote' and p.paymentType = 'Debit' and p.referenceType = 'Supplier');
		bill_refund_cash_amount					NUMERIC(18,2) := (select coalesce(sum(ibp.amount), 0) from InvoiceBillPayment ibp, Payment p  where 1 = 1 and ibp.status = 'Active' and ibp.refinvoiceoid = p_invoiceOid and ibp.paymentoid = p.oid and p.referenceoid = p_supplierOid and p.paymentnature = 'CashWithdraw' and p.paymentType = 'Credit' and p.referenceType = 'Supplier');
	BEGIN
		RETURN ((bill_cash_paid_amount + bill_vendor_credit_adjustment_amount) - (bill_refund_received_amount + bill_refund_cash_amount));
	END;
$ticket_invoice_paid_amount$ LANGUAGE plpgsql;
-- SELECT ticket_invoice_paid_amount('10', '10');

-- DROP FUNCTION IF EXISTS total_customer(varchar(128));
CREATE OR REPLACE FUNCTION total_customer(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $total_customer$
DECLARE
no_of_customer				NUMERIC(18,2) := (select coalesce(count(c.oid), 0) from Customer c  where 1 = 1 and c.status = 'Active' and c.companyOid = p_companyOid);
BEGIN
RETURN no_of_customer;
END;
$total_customer$ LANGUAGE plpgsql;
-- SELECT total_customer('10');

-- DROP FUNCTION IF EXISTS total_supplier(varchar(128));
CREATE OR REPLACE FUNCTION total_supplier(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $total_supplier$
DECLARE
no_of_supplier				NUMERIC(18,2) := (select coalesce(count(s.oid), 0) from Supplier s  where 1 = 1 and s.status = 'Active' and s.companyOid = p_companyOid);
BEGIN
RETURN no_of_supplier;
END;
$total_supplier$ LANGUAGE plpgsql;
-- SELECT total_supplier('10');

-- DROP FUNCTION IF EXISTS total_user(varchar(128));
CREATE OR REPLACE FUNCTION total_user(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $total_user$
DECLARE
no_of_user				NUMERIC(18,2) := (select coalesce(count(p.oid), 0) from Employee p  where 1 = 1 and p.status = 'Active' and p.employeeType = 'User' and p.companyOid = p_companyOid);
BEGIN
RETURN no_of_user;
END;
$total_user$ LANGUAGE plpgsql;
-- SELECT total_user('10');

-- DROP FUNCTION IF EXISTS total_employee(varchar(128));
CREATE OR REPLACE FUNCTION total_employee(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $total_employee$
DECLARE
no_of_employee			NUMERIC(18,2) := (select coalesce(count(p.oid), 0) from Employee p  where 1 = 1 and p.status = 'Active' and p.employeeType = 'Employee' and p.companyOid = p_companyOid);
BEGIN
RETURN no_of_employee;
END;
$total_employee$ LANGUAGE plpgsql;
-- SELECT total_employee('10');

-- DROP FUNCTION IF EXISTS total_passport(varchar(128));
CREATE OR REPLACE FUNCTION total_passport(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $total_passport$
DECLARE
no_of_passport			NUMERIC(18,2) := (select coalesce(count(p.oid), 0) from Passport p  where 1 = 1 and p.status = 'Active' and p.companyOid = p_companyOid);
BEGIN
RETURN no_of_passport;
END;
$total_passport$ LANGUAGE plpgsql;
-- SELECT total_passport('10');

-- DROP FUNCTION IF EXISTS customer_total_transaction_amount(varchar(128));
CREATE OR REPLACE FUNCTION customer_total_transaction_amount(p_customerOid varchar(128))
RETURNS numeric(18, 2) AS $customer_total_transaction_amount$
	DECLARE
		ticket_total_receivable_amount					NUMERIC(18,2) := (select coalesce(sum(ti.receivableAmount), 0) from TicketInvoice ti where 1 = 1 and ti.status = 'Active' and ti.customerOid = p_customerOid);
	BEGIN
		RETURN ticket_total_receivable_amount;
	END;
$customer_total_transaction_amount$ LANGUAGE plpgsql;
-- SELECT customer_total_transaction_amount('10');

-- DROP FUNCTION IF EXISTS supplier_total_transaction_amount(varchar(128));
CREATE OR REPLACE FUNCTION supplier_total_transaction_amount(p_supplierOid varchar(128))
RETURNS numeric(18, 2) AS $supplier_total_transaction_amount$
	DECLARE
		ticket_total_payable_amount					NUMERIC(18,2) := (select coalesce(sum(ti.payableAmount), 0) from TicketInvoice ti where 1 = 1 and ti.status = 'Active' and ti.supplierOid = p_supplierOid);
	BEGIN
		RETURN ticket_total_payable_amount;
	END;
$supplier_total_transaction_amount$ LANGUAGE plpgsql;
-- SELECT supplier_total_transaction_amount('10');

-- DROP FUNCTION IF EXISTS today_total_sales_amount(varchar(128));
CREATE OR REPLACE FUNCTION today_total_sales_amount(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $today_total_sales_amount$
	DECLARE
		ticket_total_sales_amount					NUMERIC(18,2) := (select coalesce(sum(ti.receivableAmount), 0) from TicketInvoice ti where 1 = 1 and ti.status = 'Active' and ti.companyOid = p_companyOid and ti.invoiceDate = current_date);
	BEGIN
		RETURN ticket_total_sales_amount;
	END;
$today_total_sales_amount$ LANGUAGE plpgsql;
-- SELECT today_total_sales_amount('10');

-- DROP FUNCTION IF EXISTS today_total_bills_amount(varchar(128));
CREATE OR REPLACE FUNCTION today_total_bills_amount(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $today_total_bills_amount$
	DECLARE
		ticket_total_bills_amount					NUMERIC(18,2) := (select coalesce(sum(ti.payableAmount), 0) from TicketInvoice ti where 1 = 1 and ti.status = 'Active' and ti.companyOid = p_companyOid and ti.invoiceDate = current_date);
	BEGIN
		RETURN ticket_total_bills_amount;
	END;
$today_total_bills_amount$ LANGUAGE plpgsql;
-- SELECT today_total_bills_amount('10');

-- DROP FUNCTION IF EXISTS today_total_received_amount(varchar(128));
CREATE OR REPLACE FUNCTION today_total_received_amount(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $today_total_received_amount$
    DECLARE
		total_received_amount				NUMERIC(18,2) := (select coalesce(sum(p.amount), 0) from Payment p where 1 = 1 and p.status = 'Active' and p.companyOid = p_companyOid and p.paymentType = 'Credit' and p.paymentDate = current_date);
    BEGIN
      RETURN total_received_amount;
    END;
$today_total_received_amount$ LANGUAGE plpgsql;
-- SELECT today_total_received_amount('10');

-- DROP FUNCTION IF EXISTS today_total_paid_amount(varchar(128));
CREATE OR REPLACE FUNCTION today_total_paid_amount(p_companyOid varchar(128))
RETURNS numeric(18, 2) AS $today_total_paid_amount$
    DECLARE
		total_paid_amount				NUMERIC(18,2) := (select coalesce(sum(p.amount), 0) from Payment p where 1 = 1 and p.status = 'Active' and p.companyOid = p_companyOid and p.paymentType = 'Debit' and p.paymentDate = current_date);
    BEGIN
      RETURN total_paid_amount;
    END;
$today_total_paid_amount$ LANGUAGE plpgsql;
-- SELECT today_total_paid_amount('10');

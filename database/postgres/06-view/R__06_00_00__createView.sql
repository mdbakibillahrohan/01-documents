-- DROP view IF EXISTS "public".v_supplier_ledger;
CREATE OR REPLACE view "public".v_supplier_ledger as
    select oid, supplierOid as supplierOid, invoiceNo as receiptNo, invoiceDate as receiptDate, 'TicketBill' as receiptType, purchasePrice as amount, createdOn
    from TicketInvoice
    where 1 = 1 and status = 'Active'
    union
    select oid, referenceoid as supplieroid, paymentNo as receiptNo, paymentDate as receiptDate, 'Payment' as receiptType, amount, createdOn
    from Payment
    where 1 = 1 and status = 'Active' and paymentNature !='CreditNote' and referenceType = 'Supplier';

-- DROP view IF EXISTS "public".v_supplier_ticket_ledger;
CREATE OR REPLACE view "public".v_supplier_ticket_ledger as
    select t.oid, ti.supplierOid as supplierOid, ti.invoiceNo as receiptNo, ti.invoiceDate as receiptDate, 'Ticket' as receiptType,
	t.purchasePrice as amount, ti.createdOn, t.paxName, t.ticketNo, t.sector, t.pnr
    from Ticket t, TicketInvoice ti
    where 1 = 1 and t.ticketInvoiceOid = ti.oid and ti.status = 'Active'
    union
    select p.oid, p.referenceoid as supplieroid, p.paymentNo as receiptNo, p.paymentDate as receiptDate, 'Payment' as receiptType, p.amount, p.createdOn,
    null as paxName, p.paymentNo as ticketNo, null as sector, null as pnr
    from InvoiceBillPayment ibp, Payment p
    where 1 = 1 and ibp.paymentOid = p.oid and p.status = 'Active' and p.paymentNature !='CreditNote' and p.referenceType = 'Supplier';

-- DROP view IF EXISTS "public".v_customer_ledger;
CREATE OR REPLACE view "public".v_customer_ledger as
    select oid, customerOid as customerOid, invoiceNo as receiptNo, invoiceDate as receiptDate, 'TicketInvoice' as receiptType, netSalesPrice as amount, createdOn
    from TicketInvoice
    where 1 = 1 and status = 'Active'
    union
    select oid, referenceoid as customerOid, paymentNo as receiptNo, paymentDate as receiptDate, 'Payment' as receiptType, amount, createdOn
    from Payment
    where 1 = 1 and status = 'Active' and paymentNature !='CreditNote' and referenceType = 'Customer';

-- DROP view IF EXISTS "public".v_customer_ticket_ledger;
CREATE OR REPLACE view "public".v_customer_ticket_ledger as
    select t.oid, ti.customerOid as customerOid, ti.invoiceNo as receiptNo, ti.invoiceDate as receiptDate, 'Ticket' as receiptType,
	t.netSalesPrice as amount, ti.createdOn, t.paxName, t.ticketNo, t.sector, t.pnr
    from Ticket t, TicketInvoice ti
    where 1 = 1 and t.ticketInvoiceOid = ti.oid and ti.status = 'Active'
    union
    select p.oid, p.referenceoid as customerOid, p.paymentNo as receiptNo, p.paymentDate as receiptDate, 'Payment' as receiptType, p.amount, p.createdOn,
    null as paxName, p.paymentNo as ticketNo, null as sector, null as pnr
    from InvoiceBillPayment ibp, Payment p
    where 1 = 1 and ibp.paymentOid = p.oid and p.status = 'Active' and p.paymentNature !='CreditNote' and p.referenceType = 'Customer';

-- DROP view IF EXISTS "public".v_due_invoices;
CREATE OR REPLACE view "public".v_due_invoices as
    select * from (
    select 'Ticket' as invoiceType, t.supplierOid, t.customerOid, t.companyOid, t.oid, t.invoiceNo, t.invoiceDate as invoiceDate, t.netSalesPrice as amount,
    COALESCE(sum(ip.amount), 0) as paid, (t.netSalesPrice - COALESCE(sum(ip.amount), 0)) as due
    from TicketInvoice t
    left join InvoiceBillPayment ip on t.oid = ip.refInvoiceOid
    left join Payment p on p.oid = ip.paymentOid
    where 1 = 1
    and t.status = 'Active'
    and p.status = 'Active'
    group by t.oid
    ) a
    where 1 = 1 and a.due > 0;

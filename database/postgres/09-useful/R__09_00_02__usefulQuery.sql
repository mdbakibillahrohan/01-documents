
-- Supplier Balance before specific date
select supplier_balance_before_date('S-101', '2019-04-14');

-- Customer Balance before specific date
select customer_balance_before_date('C-101', '2019-04-14');

-- Supplier Ledger by supplierOid and date(with)
select *
from v_supplier_ledger
where supplierOid = 'S-101'
order by receiptDate asc;

-- Customer Ledger by customerOid and date(with)
select *
from v_customer_ledger
where customerOid = 'C-101'
order by receiptDate asc;

-- Wood Stock Report
select p.name as productName, wbd.detailNo, wbd.length, wbd.width, wbd.height, wbd.totalkb, (wb.rate * wbd.totalkb) as amount
from woodbill wb, wooddetail wbd, Product p
where 1 = 1
and wb.oid = wbd.woodbilloid
and p.oid = wb.productoid
and wb.status = 'Active'
and wbd.referenceType = 'Bill'
and wb.companyoid = 'C-ARS'
and wb.woodtype = 'Square'
order by p.name asc;

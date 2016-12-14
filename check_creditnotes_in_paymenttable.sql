with
inv_amount as
(
SELECT cui.invoiceid , cui.invoiceaccount, cui.salesid, cui.invoiceamount, ct.paymmode FROM "AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cui
Left Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" as ct
on ct.invoice = cui.invoiceid
--INNER Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANSOPEN" as cto
--on cto.refrecid = ct.recid
where cui.salesid <> '' and ct.paymmode in ('PAYOLUTION','payolution','paypal','PAYPAL','H_PAY_CC','h_pay_cc')
--and cui.invoiceid = 'IN00256340
)

Select 
	inv_amount.invoiceid , inv_amount.invoiceaccount, inv_amount.salesid, cast(inv_amount.invoiceamount as FLOAT) "OriginalAmount",inv_amount.paymmode, ifnull(upd.invoice_invoiceid,'')
from inv_amount
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD"  as upd
on upd.invoice_invoiceid = inv_amount.invoiceid
where upd.invoice_invoiceid IS NULL --and inv_amount.invoiceid = 'IN00256340' --and upd.winpaymenttype <> 0
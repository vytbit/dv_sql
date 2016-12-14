with pay_err_amount as 
(
SELECT upd.invoice_invoiceid, resp.iserror, cast(sum((upd.invoice_amount)) as FLOAT) "SummeWertError"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
Left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" as resp
on upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"
where upd.WINPAYMENTTYPE <> '0' and resp.iserror = '1'
group by upd.invoice_invoiceid, resp.iserror
),
pay_succ_amount as 
(
SELECT upd.invoice_invoiceid, resp.iserror, cast(sum((upd.invoice_amount)) as FLOAT) "SummeWertSuccess"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
Left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" as resp
on upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"
where upd.WINPAYMENTTYPE <> '0' and resp.iserror = '0'
group by upd.invoice_invoiceid, resp.iserror
),
inv_amount as
(
SELECT cui.invoiceid , cui.invoiceaccount, cui.salesid, cui.invoiceamount, ct.paymmode FROM "AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cui
Left Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" as ct
on ct.invoice = cui.invoiceid
where cui.salesid <> ''
)

Select 
	inv_amount.invoiceid , inv_amount.invoiceaccount, inv_amount.salesid, cast(inv_amount.invoiceamount as FLOAT) "OriginalAmount",inv_amount.paymmode,
	ifnull(pay_err_amount.SummeWertError,0) "SummeError", ifnull(pay_succ_amount.SummeWertSuccess,0) "SummeSuccess"
from inv_amount
left join pay_err_amount on pay_err_amount.invoice_invoiceid = inv_amount.invoiceid
left join pay_succ_amount on pay_succ_amount.invoice_invoiceid = inv_amount.invoiceid
where round((inv_amount.invoiceamount+ifnull(pay_succ_amount.SummeWertSuccess,0)),2) <> 0 
and ifnull(pay_err_amount.SummeWertError,0) = 0
and ifnull(pay_succ_amount.SummeWertSuccess,0) = 0
and inv_amount.invoiceid like 'IN%' 
and inv_amount.paymmode in ('paypal','PAYPAL','PAYOLUTION','payolution','H_PAY_CC','h_pay_cc')

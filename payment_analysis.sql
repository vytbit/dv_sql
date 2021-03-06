with pay_err_amount as 
(
SELECT upd.invoice_invoiceid, resp.iserror, cast(sum((upd.invoice_amount)) as FLOAT) "SummeWertError"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
Left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" as resp
on upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"
where upd.WINPAYMENTTYPE <> '0' and resp.iserror = '1' -- and upd.invoice_invoiceid = 'CN00002846'
group by upd.invoice_invoiceid, resp.iserror
),
pay_succ_amount as 
(
SELECT upd.invoice_invoiceid, resp.iserror, cast(sum((upd.invoice_amount)) as FLOAT) "SummeWertSuccess"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
Left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" as resp
on upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"
where upd.WINPAYMENTTYPE <> '0' and resp.iserror = '0'-- and upd.invoice_invoiceid = 'CN00002846'
group by upd.invoice_invoiceid, resp.iserror
),
inv_amount as
(
SELECT cui.invoiceid , cui.invoiceaccount, cui.salesid, cui.invoiceamount, ct.paymmode, sal.customerref, ct.transdate
 FROM "AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cui
Left Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" as ct
on ct.invoice = cui.invoiceid
LEFT Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANSOPEN" as cto
on cto.refrecid = ct.recid
LEFT Join "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as sal
on sal.salesid = cui.salesid
where cui.salesid <> ''
--and cui.invoiceid = 'CN00002846'
--and ct.paymmode in ('H_PAY_CC','h_pay_cc') /* ('payolution','PAYOLUTION')*/ /* ('paypal','PAYPAL') and cui.invoiceamount<>0  cui.invoiceamount<0*/
),
update_sent as
(
SELECT invoice_invoiceid, sendqueuestatus
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD"
where WINPAYMENTTYPE in ('2')  and invoice_invoiceid = 'CN00002846'
)
Select 
	inv_amount.invoiceid, update_sent.sendqueuestatus ,inv_amount.invoiceaccount, inv_amount.salesid "Auftragsnummer",inv_amount.customerref,cast(inv_amount.transdate as DATE) "DatumBuchung", cast(inv_amount.invoiceamount as FLOAT) "OriginalAmount",inv_amount.paymmode,
	ifnull(pay_err_amount.SummeWertError,0) "SummeError", ifnull(pay_succ_amount.SummeWertSuccess,0) "SummeSuccess"
from inv_amount
left join pay_err_amount on pay_err_amount.invoice_invoiceid = inv_amount.invoiceid
left join pay_succ_amount on pay_succ_amount.invoice_invoiceid = inv_amount.invoiceid
left join update_sent on update_sent.invoice_invoiceid = inv_amount.invoiceid
--Where inv_amount.customerref = '1005954330'
--where round((inv_amount.invoiceamount+ifnull(pay_succ_amount.SummeWertSuccess,0)),2) <> 0
--and update_sent.sendqueuestatus = 1
--and ifnull(pay_err_amount.SummeWertError,0) = 0
--and ifnull(pay_succ_amount.SummeWertSuccess,0) = 0
--and inv_amount.invoiceid like 'IN%' 
--and inv_amount.paymmode in ('paypal','PAYPAL','PAYOLUTION','payolution','H_PAY_CC','h_pay_cc')
order by inv_amount.customerref
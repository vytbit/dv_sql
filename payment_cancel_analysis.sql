WITH pay_err_amount AS (
SELECT
     upd.WINSTATUSMESSAGEID
    ,resp.iserror
    ,SUM (upd.invoice_amount) "SummeWertError"

FROM
    "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" AS upd 

LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" AS resp
    ON upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"

WHERE
    upd.WINPAYMENTTYPE <> 0
    AND resp.iserror = 1

GROUP BY
      upd.WINSTATUSMESSAGEID
    ,resp.iserror),
    
pay_succ_amount AS (
SELECT
     upd.WINSTATUSMESSAGEID
    ,resp.iserror
    ,SUM(upd.invoice_amount)"SummeWertSuccess"
FROM
    "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" AS upd 

LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" AS resp
    ON upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"

WHERE
    upd.WINPAYMENTTYPE <> 0
    AND resp.iserror = 0

GROUP BY
     upd.WINSTATUSMESSAGEID
    ,resp.iserror),
    
inv_amount AS (
SELECT
	 DISTINCT
     cui.invoiceid
    ,cui.invoiceaccount
    ,cui.invoiceamount
    ,ct.paymmode
    ,ct.transdate
    ,cui.CUSTOMERREF

FROM
    "AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" AS cui 

LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" AS ct
    ON ct.invoice = cui.invoiceid 
    AND ct.TRANSTYPE = 2

LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.CUSTTRANSOPEN" AS cto
    ON cto.refrecid = ct.recid
WHERE
    cui.salesid <> '' and
    ct.paymmode IN ('payolution','PAYOLUTION') 
    )


SELECT
     upd.custref AS Debitorenreferenz 
    ,upd.Invoice_CustPaymMode AS InvoicePaymentMethod
    ,upd.sendqueuestatus AS Sendqueuestatus
    ,upd.errorcode
    ,upd.invoice_amount
    ,NVL(pay_err_amount.SummeWertError,NULL) "SummeError"
    ,NVL(pay_succ_amount.SummeWertSuccess,NULL) "SummeSuccess"

FROM
    "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd 
    
LEFT JOIN pay_err_amount
    ON pay_err_amount.WINSTATUSMESSAGEID = upd.WINSTATUSMESSAGEID 

LEFT JOIN pay_succ_amount
    ON pay_succ_amount.WINSTATUSMESSAGEID = upd.WINSTATUSMESSAGEID 

where upd.winpaymenttype = 4 --and upd.custref = '312163465'


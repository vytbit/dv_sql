WITH pay_err_amount AS (
SELECT
     upd.invoice_invoiceid
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
      upd.invoice_invoiceid
    ,resp.iserror),
    
pay_succ_amount AS (
SELECT
     upd.invoice_invoiceid
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
     upd.invoice_invoiceid
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
    ),

update_sent AS (
SELECT
    DISTINCT 
    invoice_invoiceid
    ,sendqueuestatus
    ,custref

FROM
    "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD"

WHERE
    WINPAYMENTTYPE in(1,2) ) 

SELECT
     inv_amount.CustomerRef AS Debitorenreferenz 
    ,inv_amount.invoiceid AS InvoiceID
    ,inv_amount.paymmode AS InvoicePaymentMethod
    ,update_sent.sendqueuestatus AS Sendqueuestatus
    ,inv_amount.invoiceaccount AS Debitor
    ,NVL(update_sent.invoice_invoiceid,'NULL') AS InvoiceIinPayment
    ,NVL(update_sent.custref,'NULL') AS DebitorenreferenzInPayment 
    ,CAST(inv_amount.transdate AS DATE) "Buchungsdatum"
    ,inv_amount.invoiceamount "Rechnungsbetrag"
    ,NVL(pay_err_amount.SummeWertError,NULL) "SummeError"
    ,NVL(pay_succ_amount.SummeWertSuccess,NULL) "SummeSuccess"

FROM
    inv_amount 

LEFT JOIN pay_err_amount
    ON pay_err_amount.invoice_invoiceid = inv_amount.invoiceid 

LEFT JOIN pay_succ_amount
    ON pay_succ_amount.invoice_invoiceid = inv_amount.invoiceid 

LEFT JOIN update_sent
    ON update_sent.invoice_invoiceid = inv_amount.invoiceid

where update_sent.custref = '400272586'
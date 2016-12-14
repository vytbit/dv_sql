with upd_inv as
(
SELECT
    invoice_invoiceid
FROM
    "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD"
WHERE
    WINPAYMENTTYPE in(1,2) 
)

SELECT count(cui.invoiceid) "NumberBooked", count(upd_inv.invoice_invoiceid) "NumberInPaymentTable", count(cui.invoiceid)-count(upd_inv.invoice_invoiceid) "Difference",ct.paymmode
    
FROM
    "AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" AS cui 
    
LEFT JOIN
	upd_inv
	on cui.invoiceid = upd_inv.invoice_invoiceid
	
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" AS ct
    ON ct.invoice = cui.invoiceid 
    AND ct.TRANSTYPE = 2
	
WHERE
cui.invoiceamount < 0

group by ct.paymmode

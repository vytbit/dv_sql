Select cij.invoiceid, cast(cij.invoicedate as Date) as Datum ,ct.paymmode, st.customerref, cij.invoiceamount, cij.currencycode
From "PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cij
LEFT JOIN
    "PROD_DynamicsAX2012.dbo.CUSTTRANS" as ct
    on ct.invoice = cij.invoiceid
LEFT JOIN "PROD_DynamicsAX2012.dbo.SALESTABLE" as st
  on st.salesid = cij.salesid
Where cij.salesid <> ''
  and ct.paymmode = 'payolution'
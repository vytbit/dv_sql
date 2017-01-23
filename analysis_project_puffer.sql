SELECT 
	st.salesid, st.deliveryname, st.salesoriginid, lpa.zipcode, lpa.city,/* lpa.street, */st.documentstatus, st.salesstatus, cij.invoiceid, cij.invoiceamount, cij.salesbalance, cij.sumtax, cij.currencycode
FROM
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LOGISTICSPOSTALADDRESS" as lpa
	on lpa.recid = st.DeliveryPostalAddress
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cij
	on st.salesid = cij.salesid	
WHERE
	st.Deliveryname Like '%Albo%'


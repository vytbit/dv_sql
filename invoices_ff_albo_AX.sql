/* Analyse FF Aufträge in AX für Project Puffer */

SELECT
	cij.invoiceid, 
	case left(cij.invoiceid,1)
		when '1' then 'Invoice'
		when 'I' then 'Invoice'
		when 'C' then 'CreditNote'
		when 'V' then 'Invoice'
		else 'na'
	end as "DocType"
	,cij.currencycode
	,cij.taxgroup
	,cast(cij.Invoiceamount as double) as "InvoiceAmount"
	,cast(cij.Sumtax as Double) as "SumTax"
	,cast(cij.SalesBalance as double) as "SumNet"
	,st.salesid
	,st.deliveryname
	,lpa.countryregionid
	,lpa.zipcode
	,lpa.city
	,lpa.street
	,ll.description
	
FROM
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cij
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
	on st.customerref = cij.customerref	
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LOGISTICSPOSTALADDRESS" as lpa
	on lpa.recid = st.DeliveryPostalAddress	
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LOGISTICSLOCATION" as ll
	on ll.recid = lpa.location		
		
WHERE
	st.deliveryname like '%albo%' and lpa.countryregionid = 'DEU'	
	
order by 
	cij.invoiceid desc		
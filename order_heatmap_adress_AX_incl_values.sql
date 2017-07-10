/* Analyse FF Aufträge in AX für Project Puffer */

with data as 
(SELECT
	st.customerref
	,case left(cij.invoiceid,1)
		when '1' then 'Invoice'
		when 'I' then 'Invoice'
		when 'C' then 'CreditNote'
		when 'V' then 'Invoice'
		else 'na'
	end as "DocType"
	,cij.currencycode
	,cij.taxgroup
	,cij.invoicedate
	,cast(cij.Invoiceamount as double) as "InvoiceAmount"
	,cast(cij.Sumtax as Double) as "SumTax"
	,cast(cij.SalesBalance as double) as "SumNet"
	,lpa.countryregionid
	,lpa.zipcode
	,lpa.city
	,lpa.street
	
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

LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINShipCarrierTracking" as wsct
	on wsct.salesid = st.salesid 	

Where st.salestype = 3		
)


SELECT 
	count(distinct data.customerref) as "NumberofOrders"
	,data.street
	,data.zipcode
	,data.city
	,data.countryregionid
	,data.currencycode
	,data.taxgroup
	,year(data.invoicedate) as "PostingYear"
	,sum(data.invoiceamount) as "InvoiceAmount"
	,sum(data.sumtax) as "SumTax"
	,sum(data.sumnet) as "SumNet"
FROM
	data
	
GROUP BY
	data.street
	,data.zipcode
	,data.city
	,data.countryregionid
	,data.currencycode
	,data.taxgroup
	,year(data.invoicedate)

HAVING
	count(distinct data.customerref) > 100

ORDER BY
	count(distinct data.customerref) desc
		

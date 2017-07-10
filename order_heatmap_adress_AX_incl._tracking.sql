/* Analyse FF Aufträge inkl. Trackingnummern in AX für Project Puffer */

SELECT
	distinct st.customerref
	,st.salesid
	,cij.taxgroup
	,year(cij.invoicedate) as "InvoiceDate"
	,lpa.countryregionid
	,lpa.zipcode
	,lpa.city
	,lpa.street
	,wsct.TrackingNumber
	
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

Where 
	st.salestype = 3 and left(st.salesid,3) <> 'COR'	
	and lpa.zipcode = '58135'
	--and lpa.city = 'H%'
	and lpa.street like '%m Li%'	
	and wsct.trackingnumber IS NOT NULL

Order by
	st.customerref, st.salesid	

/* Analyse FF Aufträge in AX für Project Puffer */

SELECT
	 count (distinct st.customerref) as "NumberofOrders"
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

WHERE
	st.salestype = 3
	
GROUP BY 
	lpa.countryregionid
	,lpa.zipcode
	,lpa.city
	,lpa.street	

ORDER BY
	count (distinct st.customerref) desc
	
	
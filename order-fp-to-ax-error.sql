SELECT 
	count("SALESID") as "Auftragsnummer"
	,status 
	--, shippingdate
	,deliverydate
FROM 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING"
Where 
	status = 2
GROUP BY 
	status, deliverydate
order by	
deliverydate desc
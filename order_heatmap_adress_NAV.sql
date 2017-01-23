SELECT 
	count(distinct "External Document No_") as "NumberofOrders"
	,"Ship-to Address"
	,"Ship-to Post Code"
	,"Ship-to Country_Region Code"

FROM 
	"nav.Urban-Brand GmbH$Sales Invoice Header"

GROUP BY
	"Ship-to Address"
	,"Ship-to Post Code"
	,"Ship-to Country_Region Code"	

ORDER BY 	
	count(distinct "External Document No_") desc
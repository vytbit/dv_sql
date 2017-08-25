Select 
	count(min_max.itemid) as "AnzahlItemIds"
FROM
	"AX.PROD_DynamicsAX2012.dbo.REQITEMTABLE" as min_max
	
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on dim.inventdimid = min_max.COVINVENTDIMID
WHERE 
	dim.inventlocationid  in ('CTC_BCN','DIR_ES')
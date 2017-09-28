Select 
	inv.itemid, inv.primaryvendorid,mcr.dropshipment, req.vendid
From 
	"AX.PROD_DynamicsAX2012.dbo.InventTable" as inv
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.MCRInventTable" as mcr
	on mcr.inventtable = inv.recid
LEFT JOIN
	(Select 
		min_max.itemid
		,min_max.MININVENTONHAND
		,dim.inventsiteid 
		,dim.inventlocationid
		,min_max.vendid
	FROM
		"AX.PROD_DynamicsAX2012.dbo.REQITEMTABLE" as min_max
	LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on dim.inventdimid = min_max.COVINVENTDIMID
	WHERE dim.inventlocationid = 'DIR_DE'
	) as req
	on req.itemid = inv.itemid	
WHERE
	mcr.dropshipment = 1 and inv.primaryvendorid <> req.vendid	
 
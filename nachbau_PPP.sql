with multiple as
(
Select 
	sitepurch.itemid 
	,sitepurch.MULTIPLEQTY 
	,sitepurch.WINUNITOFMEASURESYMBOL 
	,dim.inventsiteid 
From "AX.PROD_DynamicsAX2012.dbo.INVENTITEMPURCHSETUP" as sitepurch
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on sitepurch.inventdimid = dim.inventdimid
WHERE 
	sitepurch.inventdimid <> 'AllBlank' --and sitepurch.itemid = '4008976021483'
),
minmax as
(Select 
	min_max.itemid
	,min_max.MININVENTONHAND
	,dim.inventsiteid 
	,dim.inventlocationid
FROM
	"AX.PROD_DynamicsAX2012.dbo.REQITEMTABLE" as min_max
	
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on dim.inventdimid = min_max.COVINVENTDIMID
--WHERE min_max.itemid = '4008976021483'
),
appvend as 
(
Select 
	app_vend.itemid
	,app_vend.pdsapprovedvendor
FROM
	"AX.PROD_DynamicsAX2012.dbo.PDSAPPROVEDVENDORLIST"	as app_vend
WHERE 
	app_vend."VALIDTO" > CURDATE() --and app_vend.itemid = '4008976021483'
),
trade as 
(
SELECT
	price.itemrelation
	,price.accountrelation
	,dim.inventsiteid
	,dim.inventlocationid

FROM
	"AX.PROD_DynamicsAX2012.dbo.PRICEDISCTABLE" as price
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on price.inventdimid = dim.inventdimid
	--	on price.itemrelation = inv.itemid  and price.inventdimid = inv.inventdimid	and 
WHERE 	
	price.unitid = 'PCS' --and price.itemrelation = '0000000000055'
),
class as
(
SELECT
	invset.itemid
	,invset.winproductclass
	,dim.inventsiteid

FROM
	"AX.PROD_DynamicsAX2012.dbo.INVENTITEMINVENTSETUP" as invset
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on invset.inventdimid = dim.inventdimid
	--	on price.itemrelation = inv.itemid  and price.inventdimid = inv.inventdimid	and 
WHERE 	
	invset.inventdimid <> 'AllBlank' --and invset.itemid = '4008976021483' 
)
,
invent as 
(
SELECT 
	invsum.itemid
	,invsum.availphysical "PhysAvailable"
	,invsum.onorder
	,invsum.ordered
	,dim.inventsiteid
	,dim.inventlocationid
FROM
	"AX.PROD_DynamicsAX2012.dbo.INVENTSUM" as invsum
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on invsum.inventdimid = dim.inventdimid
WHERE	
	dim.inventlocationid in ('FIEGE_GB','WDB_AB','FIEGE_AR','USTER')
	--and invsum.itemid = '0000000000055'	
)
	 


SELECT 
	it.itemid "Artikelnummer"
	--,invent.itemid
	,cast(ifnull(invent."PhysAvailable",0) as INTEGER) "PhysAvailable"
	,cast(ifnull(invent.onorder,0) as INTEGER) "InAufträgen"
	,cast(ifnull(invent.ordered,0) as INTEGER) "InBestellungen"
	,invent.inventsiteid "Standort"
	,invent.inventlocationid "Lagerort-Warehouse"
	--,class.itemid
	,class.winproductclass "Klasse"
	--,class.inventsiteid "Standort-Klasse"
	--,minmax.itemid
	,cast(minmax.MININVENTONHAND as INTEGER) "MINMAX"
	--,minmax.inventsiteid "Standort-MINMAX"
	--,minmax.inventlocationid "Lagerort-Warehouse-MINMAX"
	--,multiple.itemid 
	,cast(multiple.MULTIPLEQTY as INTEGER) "Multiple"
	,multiple.WINUNITOFMEASURESYMBOL "Einkaufseinheit Tradeagreement"
	--,multiple.inventsiteid "Standort-Multiple"
	--,trade.itemrelation
	,trade.accountrelation "Trade-Vendor"
	--,trade.inventsiteid "Standort-Trade"
	--,trade.inventlocationid "Lagerort-Warehouse-Trade"
	--,appvend.itemid
	,appvend.pdsapprovedvendor "Approved-Vendor"
	,case
		when ifnull(minmax.MININVENTONHAND,0)-(ifnull(invent."PhysAvailable",0)-ifnull(invent.onorder,0)+ifnull(invent.ordered,0)) <= 0 then 0
		else cast(ifnull(minmax.MININVENTONHAND,0)-(ifnull(invent."PhysAvailable",0)-ifnull(invent.onorder,0)+ifnull(invent.ordered,0)) as INTEGER) 
	end "Bestellmenge"
	
FROM 
	"AX.PROD_DynamicsAX2012.dbo.INVENTTABLE" as it
LEFT JOIN
	minmax
	on minmax.itemid = it.itemid --and  minmax.inventsiteid = invent.inventsiteid and  minmax.inventlocationid = invent.inventlocationid
LEFT JOIN 
	invent
	on invent.itemid = it.itemid and invent.inventsiteid = minmax.inventsiteid
LEFT JOIN 
	class
	on class.itemid = it.itemid and class.inventsiteid = minmax.inventsiteid

LEFT JOIN
	multiple	
	on multiple.itemid = it.itemid and 	multiple.inventsiteid = minmax.inventsiteid 
LEFT JOIN
	trade
	on trade.itemrelation = it.itemid and  trade.inventsiteid = minmax.inventsiteid and  trade.inventlocationid = minmax.inventlocationid
LEFT JOIN
	appvend
	on appvend.itemid = it.itemid and trade.accountrelation = appvend.pdsapprovedvendor
	
	
WHERE 
	it.itemid Like '%27084414998'
	and
	 it.PmfProductType = 0
	and class.winproductclass in ('A','B','C','K','W')
	and ifnull(minmax.MININVENTONHAND,0)-(ifnull(invent."PhysAvailable",0)-ifnull(invent.onorder,0)+ifnull(invent.ordered,0)) > 0
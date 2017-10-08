with 
i as
(
	Select 
		itemid, price
	FROM 
		"AX.PROD_DynamicsAX2012.dbo.INVENTTABLEMODULE"
	WHERE
		Moduletype = 0
),
p as
(
	Select 
		itemid, price 
	FROM 
		"AX.PROD_DynamicsAX2012.dbo.INVENTTABLEMODULE"
	WHERE
		Moduletype = 1
),
t as
(
SELECT
	itemrelation
	,amount
FROM
	"AX.PROD_DynamicsAX2012.dbo.PRICEDISCTABLE" 
WHERE 	
	unitid = 'PCS' --  itemrelation = '04008976220145'	
	
),
s as
(
SELECT 
	inv.itemid, 
	sum(inv.PostedQty + inv.Received - inv.Deducted + inv.Registered - inv.Picked )as "StockValue"
	
FROM
	"AX.PROD_DynamicsAX2012.dbo.INVENTSUM" inv
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on inv.inventdimid = dim.inventdimid
WHERE 	
dim.inventlocationid in ('FIEGE_GB','FIEGE_AR','USTER')	
GROUP BY inv.itemid
),
pim as
(
SELECT distinct ean
from "pim2_0_product_data.productData" 
)


Select 
		distinct it.itemid, i.price, p.price, t.amount, s."StockValue", pim.ean
FROM 
	"AX.PROD_DynamicsAX2012.dbo.inventtable" as it
left join
	i on i.itemid = it.itemid
left join 
	p on p.itemid = i.itemid
left join
	t on t.itemrelation = i.itemid
left join
	s on s.itemid = i.itemid	
left join	
	"AX.PROD_DynamicsAX2012.dbo.inventmodelgroupitem" as imgi
	on imgi.itemid = it.itemid 	
left join
	pim on pim.ean = it.itemid			
Where 
	 imgi.modelgroupid <> 'SERVICE' and  i.price = 0 and s."StockValue" <> 0
	 --and i.itemid = '04008976220145'	

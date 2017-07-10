WITH agg AS (
SELECT 
      ID.INVENTLOCATIONID AS LocationCode
    , IT.ITEMID AS ItemID 
    , CAST(SUM(CASE WHEN (IT.STATUSRECEIPT IN (1,2,3) OR IT.STATUSISSUE IN (1,2,3)) THEN IT.QTY ELSE 0 END)  AS INTEGER) AS StockQuantity
    , CAST(SUM(CASE WHEN IT.STATUSISSUE IN (4,5,6) THEN IT.QTY ELSE 0 END) AS INTEGER) AS InSalesOrderQuantity
    , CAST(SUM(CASE WHEN (IT.STATUSRECEIPT IN (1,2,3) OR IT.STATUSISSUE IN (1,2,3)) THEN IT.QTY ELSE 0 END) AS INTEGER) + CAST(SUM(CASE WHEN IT.STATUSISSUE IN (4,5,6) THEN IT.QTY ELSE 0 END) AS INTEGER) AS AvailableQuantity
    , CAST(SUM(CASE WHEN IT.STATUSRECEIPT IN (4,5) THEN IT.QTY ELSE 0 END) AS INTEGER) AS PurchaseOrderQuantity
    , SUM(CASE WHEN (IT.STATUSRECEIPT IN (1,2,3) OR IT.STATUSISSUE IN (1,2,3)) THEN it.CostAmountPosted + it.CostAmountAdjustment ELSE 0 END) AS InventoryValue
    , SUM(it.Qty) AS QtyOverAll
    , CAST(SUM(it.CostAmountPosted) AS DECIMAL (10,2) ) AS CostAmountPostedOverAll
    , SUM(it.CostAmountAdjustment) AS CostAmountAdjustmentOverAll
    , SUM(it.CostAmountSettled) AS CostAmountSettledOverAll
FROM 
    "AX.PROD_DynamicsAX2012.dbo.InventTrans" AS IT
     
LEFT OUTER JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTTRANSORIGIN" AS ITO
          ON  ITO.RECID = IT.INVENTTRANSORIGIN 
          AND ITO.DATAAREAID = IT.DATAAREAID 
          AND ITO."PARTITION" = IT."PARTITION" 
          
LEFT OUTER JOIN 
     "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" AS ID
          ON it.INVENTDIMID = id.INVENTDIMID
          AND it.DATAAREAID = id.DATAAREAID 
          AND it."PARTITION" = id."PARTITION"
WHERE 
	id.InventLocationID = 'FIEGE_GB'
	
GROUP BY 
	  ID.INVENTLOCATIONID 
	, IT.ITEMID
) , InventSum AS (
SELECT 
	  it.*
	, it.PostedQty + it.Received + it.Registered - it.Deducted - it.Picked - it.OnOrder - it.ReservPhysical AS AvQty
FROM 
    "AX.PROD_DynamicsAX2012.dbo.InventSum" AS it
LEFT OUTER JOIN 
     "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" AS ID
          ON it.INVENTDIMID = id.INVENTDIMID
          AND it.DATAAREAID = id.DATAAREAID 
          AND it."PARTITION" = id."PARTITION"
WHERE 
      id.InventLocationID = 'FIEGE_GB')


select 
      agg.*
    , CAST(it.PhysicalInvent AS INTEGER) PhysicalInvent
    , CAST(it.ReservPhysical + it.OnOrder AS INTEGER) AS InSalesOrderQty
    , CAST(it.AvQty AS INTEGER) AS AvQty
    , CAST(it.Ordered AS INTEGER) AS InPurchaseOrderQty
    , it.PostedValue
    , it.PostedQty
    , it.PhysicalValue
from      agg 

INNER JOIN InventSum AS it ON it.ItemID = agg.ItemID 

WHERE 
    agg.ItemID = '4008976022367'
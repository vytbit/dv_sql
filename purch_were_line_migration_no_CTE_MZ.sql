SELECT ROW_NUMBER()
       OVER (
	       PARTITION BY rec.num_albaran
	       ORDER BY rec.num_albaran ASC )       AS "LineNumber"
	,  'Purch'                                  AS "PurchaseType"
	,  vend.currency                            AS "CurrencyCode"
	,  r2p.purchid                              AS "PurchId"
	,  ifnull(item_map.itemid, 'notapplicable') AS "ItemId"
	,  vend.accountnum                          AS "VendAccount"
	,  vend.taxgroup                            AS "TaxGroup"
	,  tax_item.taxitemgroupid                  AS "TaxItemGroup"
	,  rec.recibido                             AS "PurchQty"
	,  'BCN'                                    AS "InventSiteId"
	,  'CTC_BCN'                                AS "InventLocationId"
	,  ''                                       AS "ConfirmedDlv"
	,  '0'                                      AS "OverDeliveryPct"
	,  '100'                                    AS "UnderDeliveryPct"
	,  '1'                                      AS "PurchUnit"
	,  'PCS'                                    AS "PurchUnit"
	,  avg_price.price                          AS "PurchPrice"
	,  rec.recibido * avg_price.price           AS "LineAmount"
	,  'ES_BEB--100'                            AS "DefaultDimension"

FROM 
(SELECT * FROM "Operations.BEB_Receipts") AS rec 

LEFT JOIN 
	(SELECT logistics_id,itemid FROM "Operations.BEB_ItemID_Mapping") item_map
	ON rec.id_logistico = item_map.logistics_id

LEFT JOIN 
	(SELECT p.id_product || '-' || IFNULL(pa.id_product_attribute, 0) AS bebitus_id ,ifnull(pa.pmp, p.pmp) AS price 
	 FROM "Bebitus_Prestashop.ps_product" AS p 
	 LEFT JOIN "Bebitus_Prestashop.ps_product_attribute" AS pa ON p.id_product = pa.id_product) avg_price
	ON avg_price.bebitus_id = rec.id_logistico

LEFT JOIN (SELECT DISTINCT inv.itemid
	, invm.taxitemgroupid
FROM "AX.PROD_DynamicsAX2012.dbo.Inventtable" AS inv LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.InventtableModule" AS invm
	ON invm.itemid = inv.itemid
ORDER BY inv.itemid ASC) tax_item
	ON tax_item.itemid = item_map.itemid

LEFT JOIN (SELECT DISTINCT vc.accountnum
	, vc.currency
	, vc.vendgroup
	, vc."name"
	, v.paymmode
	, v.cashdisc
	, v.taxgroup
	, v.VATNUM
	, beb.id_supplier
FROM "AX.PROD_DynamicsAX2012.dbo.VendTableCube" AS vc LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.VendTable" AS v
	ON v.accountnum = vc.accountnum
LEFT JOIN "Bebitus_Prestashop.ps_supplier" AS beb
	ON beb.ax_vendor = vc.accountnum
WHERE vc.dataareaid = 'deag' AND vc.Accountnum >= '71001') vend
	ON vend.id_supplier = rec.supplier_id_beb

LEFT JOIN (SELECT ROW_NUMBER()
                  OVER (
	                  ORDER BY vend.accountnum ) AS "PurchId"
	,             rec.num_albaran                AS "VendorRef"
FROM (SELECT DISTINCT supplier_id_beb
	, po_number
	, num_albaran
FROM "Operations.BEB_Receipts") AS rec LEFT JOIN (SELECT "id_supplier"
	, "ax_vendor"
FROM "Bebitus_Prestashop.ps_supplier") beb_vend
	ON beb_vend.id_supplier = rec.supplier_id_beb
LEFT JOIN (SELECT DISTINCT vc.accountnum
	, vc.currency
	, vc.vendgroup
	, vc."name"
	, v.paymmode
	, v.cashdisc
	, v.taxgroup
	, v.VATNUM
FROM "AX.PROD_DynamicsAX2012.dbo.VendTableCube" AS vc LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.VendTable" AS v
	ON v.accountnum = vc.accountnum
WHERE vc.dataareaid = 'deag' AND vc.Accountnum >= '71001') vend
	ON vend.accountnum = beb_vend.ax_vendor) AS r2p
	ON rec.num_albaran = r2p.VendorRef
ORDER BY rec.num_albaran, "LineNumber"
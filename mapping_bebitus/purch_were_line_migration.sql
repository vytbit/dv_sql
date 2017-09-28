with tax_item as
(Select
	distinct inv.itemid, invm.taxitemgroupid
FROM
	"AX.PROD_DynamicsAX2012.dbo.Inventtable"  as inv
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.InventtableModule"  as invm
	on invm.itemid = inv.itemid
order by
	inv.itemid asc),
vend as
(Select
	distinct vc.accountnum, vc.currency, vc.vendgroup, vc."name", v.paymmode, v.cashdisc, v.taxgroup, v.VATNUM, beb.id_supplier
From 
	"AX.PROD_DynamicsAX2012.dbo.VendTableCube" as vc
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.VendTable" as v 
	on v.accountnum = vc.accountnum
left join
 	 "Bebitus_Prestashop.ps_supplier" as beb
 	 on beb.ax_vendor = vc.accountnum
 		
Where 
	vc.dataareaid = 'deag' and vc.Accountnum >= '71001'),
item_map as

(Select
		logistics_id, itemid
From
	"Operations.BEB_ItemID_Mapping" 
),
avg_price as 
(Select
	p.id_product || '-' ||IFNULL(pa.id_product_attribute, 0) AS bebitus_id,
	ifnull(pa.pmp, p.pmp) as price

from "Bebitus_Prestashop.ps_product" as p
Left join
	"Bebitus_Prestashop.ps_product_attribute" as pa
	on p.id_product = pa.id_product	)	
	
	
Select 
	ROW_NUMBER() OVER(PARTITION BY rec.num_albaran ORDER BY rec.num_albaran ASC) AS "LineNumber"
	,'Purch' as "PurchaseType"
	,vend.currency as "CurrencyCode"
	,r2p.purchid as "PurchId"
	,ifnull(item_map.itemid,'notapplicable') as "ItemId"
	,vend.accountnum as "VendAccount"
	,vend.taxgroup as "TaxGroup"
	,tax_item.taxitemgroupid as "TaxItemGroup"
	,rec.recibido as "PurchQty"
	,'BCN' as "InventSiteId"
	,'CTC_BCN' as "InventLocationId"
	,'' as "ConfirmedDlv"
	,'0' as "OverDeliveryPct"
	,'100' as "UnderDeliveryPct"
	,'1' as "PriceUnit"
	,'PCS' as "PurchUnit"
	,avg_price.price as "PurchPrice"
	,rec.recibido * avg_price.price as "LineAmount"
	,'--100' as "DefaultDimension"
	--,rec.num_albaran as "VendorRef"
	--,rec.id_logistico
From
	(Select 
	* 
	From 
	"Operations.BEB_Receipts") as rec
Left Join
	item_map on rec.id_logistico = item_map.logistics_id
left join
	avg_price on avg_price.bebitus_id = rec.id_logistico	
left join
	tax_item on tax_item.itemid = item_map.itemid
left join
	vend on vend.id_supplier = rec.supplier_id_beb	
left join
	"Operations.BEB_Rec2Purchid" as r2p
	on rec.num_albaran = r2p.deliveryno		

order by 
	rec.num_albaran,"LineNumber" 
			
	
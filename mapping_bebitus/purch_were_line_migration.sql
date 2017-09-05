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
	distinct vc.accountnum, vc.currency, vc.vendgroup, vc."name", v.paymmode, v.cashdisc, v.taxgroup, v.VATNUM
From 
	"AX.PROD_DynamicsAX2012.dbo.VendTableCube" as vc
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.VendTable" as v 
	on v.accountnum = vc.accountnum	
Where 
	vc.dataareaid = 'deag' and vc.Accountnum >= '71001')
	
	
Select 
	'' as "LineNumber"
	,'Purch' as "PurchaseType"
	,'' /*vend.currency*/ as "CurrencyCode"
	,'' as "PurchId"
	,'' as "ItemId"
	,'' /*vend.accountnum*/ as "VendAccount"
	,'' /*vend.taxgroup*/as "TaxGroup"
	,tax_item.taxitemgroupid as "TaxItemGroup"
	,'' as "PurchQty"
	,'BCN' as "InventSiteId"
	,'CTC_BCN' as "InventLocationId"
	,'' as "ConfirmedDlv"
	,'0' as "OverDeliveryPct"
	,'100' as "UnderDeliveryPct"
	,'1' as "PriceUnit"
	,'PCS' as "PurchUnit"
	,'' as "PurchPrice"
	,'' as "LineAmount"
	,'--100' as "DefaultDimension"
From
	tax_item

			
	
with vend as
(Select
	distinct vc.accountnum, vc.currency, vc.vendgroup, vc."name", v.paymmode, v.cashdisc, v.taxgroup, v.VATNUM
From 
	"AX.PROD_DynamicsAX2012.dbo.VendTableCube" as vc
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.VendTable" as v 
	on v.accountnum = vc.accountnum	
Where 
	vc.dataareaid = 'deag' and vc.Accountnum >= '71001'),
beb_vend as
(SELECT "id_supplier", "ax_vendor" FROM "Bebitus_Prestashop.ps_supplier")
	

Select 
	vend.currency as "Currency Code"
	,vend.accountnum as "InvoiceAccount"
	,'es' as "LanguageID"
	,vend.accountnum as	"OrderAccount"
	,'BEB-' || ROW_NUMBER() OVER(ORDER BY vend.accountnum)as "PurchId"
	--,rec.po_number as "PurchId"
	,'Bebitus' as "VendGroup"
	,'Purch' as "PurchaseType"
	,'' as "ContactPersonId"
	,vend."Name" as "PurchName"
	,'' as "PurchStatus"
	,vend.vatnum as "VATNum"
	,vend.taxgroup as "TaxGroup"
	,vend.paymmode as "PaymMode"
	,'2017-09-30' as "DeliveryDate"
	,'' as "ConfirmedDay"
	,'BCN' as "InventSiteId"
	,'CTC_BCN' as "InventLocationId"
	,'--100' as "DefaultDimension"
	,rec.num_albaran as "VendorRef"
	,'' as "Requester"
	,vend.cashdisc as "CashDisc"
From
	(Select 
	distinct supplier_id_beb,po_number,num_albaran 
	From 
	"Operations.BEB_Receipts") as rec
Left join
	beb_vend on beb_vend.id_supplier = rec.supplier_id_beb
left join
	vend on vend.accountnum = beb_vend.ax_vendor	

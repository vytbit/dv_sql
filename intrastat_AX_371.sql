with address as
(
Select 
	lpa.recid, lpa.countryregionid
from
	"AX.PROD_DynamicsAX2012.dbo.LOGISTICSPOSTALADDRESS" as lpa	
),

item_data as
(
Select 
	itm.taxitemgroupid,it.namealias,it.OrigCountryRegionId,it.netweight,it.taraweight, (it.netweight + it.taraweight) "GrossWeight",it.itemid,toi.WINCustomsTariffId, toi.WINLogisticsAddressCountryRegionId,grp.Modelgroupid
from
	"AX.PROD_DynamicsAX2012.dbo.Inventtable" as it
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.InventtableModule" as itm
	on it.itemid = itm.itemid
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.Taxonitem" as toi
	on itm.taxitemgroupid = toi.taxitemgroup
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.InventModelGroupItem" as grp
	on grp.itemid = it.itemid	
Where
	toi.WINLogisticsAddressCountryRegionId = 'DEU'
),

st as 
(
Select st.salesid, st.salestype,st.DeliveryPostalAddress,st.inventlocationid
from
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
),

cit as
(
select
	itemid,salesid,invoiceid,invoicedate,numbersequencegroup, qty,qtyphysical,lineamounttax, salesprice, lineamount, "name"
from	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICETRANS" 
),
cij as
(
Select	
	cast(invoicedate as Date) as "InvoiceDate",
	invoiceid
	,invoiceaccount
	,salesid
	,numbersequencegroup
From 
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR"  
WHERE
	invoiceaccount in ('D02401046','D02725448','D02683871','D02912839')
)

Select 
	distinct cast(cij.InvoiceDate as Date) as "InvoiceDate"
	,st.salestype as "Type"
	--,st.salesid 
	,cij.invoiceid as "VoucherId"
	,cij.invoiceaccount as "Debitor"
	,cit.itemid as "Artikelnummer"
	,cit.qty as "Menge"
	--,cit.qtyphysical
	--,cit.lineamounttax
	,cit.lineamount as "Zeilensumme"
	,(cit.lineamount/cit.qty) as "NettoPrice"
	--,cit.salesprice
	,item_data.namealias as "Artikelname"
	--,cit."name"
	,item_data.netweight as "Nettogewicht"
	,(item_data.netweight*cit.qty) as "TotalWeight"
	,item_data.WINCustomsTariffId as "Zolltarifnummer"
	,item_data.OrigCountryRegionId as "Ursprungsland"
	,st.inventlocationid as "Versandlager"
	,address.countryregionid as "Lieferland"
	
	
FROM
	 cij
LEFT JOIN
	cit
	on cit.salesid = cij.salesid and cit.invoiceid = cij.invoiceid and cit.invoicedate = cij.invoicedate and cit.numbersequencegroup = cij.numbersequencegroup
LEFT JOIN
	st
	on st.salesid = cij.salesid	
LEFT JOIN
	address
	on address.recid = st.DeliveryPostalAddress	
LEFT JOIN
	item_data
	on item_data.itemid = cit.itemid			
Where
	cit.itemid <> '' and item_data.Modelgroupid <> 'SERVICE'

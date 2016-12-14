SELECT 
	stgl.linenum "Zeilennummer Retourenmeldung"
	,stgl.itemid "Item Retourenmeldung"
	,stgl.quantityreturned "Menge Retourenmeldung"
	,stgl.locklocation "Sperrlager Retourenmeldung"
	,stg.salesid "Auftrag Retourenmeldung"
	,stg.inventsiteid "Standort Retourenmeldung"
	,stg.inventlocationid "Lager Retourenmeldung"
	,stl.salesid "Auftrag Auftragszeile"
	,stl.itemid "Artikel Auftragszeile"
	,stl.linenum "Zeilennummer Auftragszeile"
	,stl.salesqty "Menge Auftragszeile"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNLINESTAGING" as stgl
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNTABLESTAGING" as stg
	on stgl.returnitemnum = stg.returnitemnum
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.SALESLINE" as stl
	on stl.salesid = stg.salesid and stgl.itemid = stl.itemid
where stgl.status = 2
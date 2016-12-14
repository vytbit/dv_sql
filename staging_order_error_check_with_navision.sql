Select 
	navsl."Document No_" "NAVAuftragsnummer"
	,navsl."No_" "NAVArtikelnummer"
	,navsl."Line No_" "NAVZeilennummer"
	,navsl."Sell-to Customer No_" "NAVDebitor"
	,navsl."Location Code" "NAVLAgerort"
	,cast(navsl.Quantity as INTEGER) "NAVAuftragsmenge"
	,cast(navsl."Outstanding Quantity" as INTEGER) "NAVAusstehendeMenge"
	,max(stg.Shippingdate) "Versanddataum AX Staging"
	,cast(sum(navsil."Quantity") as INTEGER) "InvoiceQtyNAV"
	
FROM 
	"nav.Urban-Brand GmbH$Sales Line" as navsl

LEFt JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Line" as navsil
	on navsil."Order No_" = navsl."Document No_" and navsil."No_"= navsl."No_" and navsl."Line No_" = navsil."Order Line No_" and navsil."Quantity" <> 0
	
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
	on stg.salesid = navsl."Document No_"

WHERE navsl."Document No_" in 
(Select stg.salesid "Auftragsnr Staging"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
INNER JOIN
	"nav.Urban-Brand GmbH$Sales Header" as navsh
	on navsh.No_ = stg.salesid	
Where
	stg.Status = 2)
--and navsl."Document No_" = 'A0004943498'

GROUP BY 	
	navsl."Document No_" 
	,navsl."No_" 
	,navsl."Line No_"
	,navsl."Sell-to Customer No_" 
	,navsl."Location Code" 
	,navsl.Quantity 
	,navsl."Outstanding Quantity" 

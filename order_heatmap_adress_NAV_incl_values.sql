SELECT 
	count(distinct sih."External Document No_") as "NumberofOrders"
	,sih."Ship-to Address"
	,sih."Ship-to Post Code"
	,sih."Ship-to City"
	,sih."Ship-to Country_Region Code"
	,sih."Currency Code"
	--,month(sih."Posting Date") as "PostingMonth"
	,year(sih."Posting Date") as "PostingYear"
	,sum(sil."Amount Including VAT") as "InvoiceAmoint"
	,sum((sil."Amount Including VAT" - sil."Amount")) as "SumTax"
	,sum( sil."Amount") as "SalesNet"

FROM 
	"nav.Urban-Brand GmbH$Sales Invoice Line" as sil
LEFT JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Header" as sih
	on sih."No_" = sil."Document No_"

GROUP BY
	sih."Ship-to Address"
	,sih."Ship-to Post Code"
	,sih."Ship-to City"
	,sih."Ship-to Country_Region Code"
	,sih."Currency Code"
	--,month(sih."Posting Date")
	,year(sih."Posting Date")

having
	count(distinct sih."External Document No_")  > 100
ORDER BY 	
	count(distinct sih."External Document No_") desc	
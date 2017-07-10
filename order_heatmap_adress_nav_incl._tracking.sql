with parcel as 
(SELECT 
	distinct "Order No_","T&T-Id" 
FROM 
	"nav.Urban-Brand GmbH$eBayParcel")
	
SELECT 
	distinct sih."External Document No_"
	,sih."Ship-to Address"
	,sih."Ship-to Post Code"
	,sih."Ship-to City"
	,year(sih."Posting Date") as "PostingYear"
	,parcel."T&T-Id" 

FROM 
	"nav.Urban-Brand GmbH$Sales Invoice Line" as sil
LEFT JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Header" as sih
	on sih."No_" = sil."Document No_"	
LEFT JOIN
	parcel
	on parcel."Order No_" = sih."Order No_"	
WHERE
	sih."Ship-to Address" like '%Dieselst%'
	and sih."Ship-to Post Code" = '76227'
	and sih."Ship-to City"	= 'Karlsruhe'
	--and sih."External Document No_" = '1002922061'
	and parcel."T&T-Id" IS NOT NULL
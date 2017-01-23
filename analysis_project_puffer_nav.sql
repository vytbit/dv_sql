SELECT 
	*
FROM 
	"nav.Urban-Brand GmbH$Sales Invoice Header" as sih
LEFT JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Line" as sil
	on sih."No_" = sil."Document No_"	
WHERE
	"Ship-to Name" like '%Albo%'
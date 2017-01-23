SELECT  
	sil."Document No_",sih."Currency Code", sum(sil."Amount Including VAT") as "InvoiceAmoint",sum((sil."Amount Including VAT" - sil."Amount")) as "SumTax", sum( sil."Amount") as "SalesBalance",cast(sih."Posting Date" as Date) as "InvoiceDate"
FROM 
	"nav.Urban-Brand GmbH$Sales Invoice Line" as sil
LEFT JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Header" as sih
	on sih."No_" = sil."Document No_"
Where
	sih."Posting Date" >= '2016-01-01'
Group by
	sil."Document No_",sih."Currency Code" ,sih."Posting Date"	
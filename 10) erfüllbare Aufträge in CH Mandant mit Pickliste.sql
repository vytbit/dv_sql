with InSales as
(SELECT sl.No_ as Artikel_Sales,  
(sum(sl.Quantity)- sum(sl.[Quantity Shipped])) as inSales --, sum(il.Quantity)
FROM [Urban_NAV600].[dbo].[Urban-Brand GmbH$Sales Line] as sl with (NOLOCK)
Where sl.[Posting Group] = 'HANDEL' and [Location Code] = 'USTER'
group by sl.No_),

InBest as
(Select
il.[Item No_] as Artikel,  isnull(sum(il.Quantity),0) as Bestand
FROM [Urban_NAV600].[dbo].[Urban-Brand GmbH$Item Ledger Entry] as il with (NOLOCK)
Where  [Location Code] = 'USTER'
group by il.[Item No_]
)

Select 
distinct sh.No_, sh.[Payment Method Code], sh.[External Document No_], sh.[Shipping Agent Code], cast(sh.[Order Date] as Date)
FROM [Urban_NAV600].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
Where sh.[Reason Code] = 'WINDELN_CH' and sh.[Document Type] = '1' and
sh.No_ not In(

Select distinct [Document No_] 
FROM [Urban_NAV600].[dbo].[Urban-Brand GmbH$Sales Line] with (NOLOCK)
Where No_ in (
Select InSales.Artikel_Sales
from InSales
	LEFT join InBest on InSales.Artikel_Sales = InBest.Artikel
	Where cast(isnull(InBest.Bestand,0)as INT) - cast(InSales.inSales as INT) < 0)
	)
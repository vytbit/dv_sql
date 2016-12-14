with price_trade as 
(

SELECT
	price.itemrelation
	,price.amount
	,dim.inventsiteid

FROM
	"AX.PROD_DynamicsAX2012.dbo.PRICEDISCTABLE" as price
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on price.inventdimid = dim.inventdimid
	--	on price.itemrelation = inv.itemid  and price.inventdimid = inv.inventdimid	and 
WHERE 	
	price.unitid = 'PCS' --and price.itemrelation = '4005500892243'

),
booked_price
as
(
Select booked.itemid, booked.pricetype,booked.price, dim.inventsiteid
FROM "AX.PROD_DynamicsAX2012.dbo.INVENTITEMPRICE" as booked
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on booked.inventdimid = dim.inventdimid
where pricetype = 1 --booked.itemid in ('000772102711','4005500892243')
)

Select  price_trade.itemrelation "Artikelnummer",price_trade.inventsiteid "Standort",price_trade.amount "Preis_Handelsvereinbarung",booked_price.price "GebuchterPreis",(price_trade.amount/booked_price.price) "Quotient"
from price_trade
Left join booked_price
on price_trade.itemrelation = booked_price.itemid and price_trade.inventsiteid = booked_price.inventsiteid
Where booked_price.itemid IS NOT NULL
order by (price_trade.amount/booked_price.price) asc
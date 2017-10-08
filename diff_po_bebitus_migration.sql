with rec as
(
SELECT 	res.num_albaran, ma.itemid, res.recibido, pmp.pmp
from
"Operations.BEB_Receipts" as res
left join
	"Operations.BEB_ItemID_Mapping" as ma
	on ma.Logistics_Id = res.id_logistico
left join
	"Operations.BEB_PMP" as pmp
	on pmp.id_logistico = res.id_logistico	
)

Select 
	--pl.purchid, ph.vendorref, pl.itemid, pl.purchqty,pl.purchprice, rec.recibido, rec.pmp,
	sum(pl.purchqty - rec.recibido) as "SumQtyDiff", sum((pl.purchqty*pl.purchprice)-(rec.recibido*rec.pmp)) as "SumValueDiff"
From
	"AX.PROD_DynamicsAX2012.dbo.Purchline" as pl
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.PurchTable" as ph
	on pl.purchid = ph.purchid	
Left Join
	rec
	on rec.num_albaran = ph.vendorref and pl.itemid = rec.itemid
WHERE
	left(pl.purchid,3) = 'BEB'	--and pl.itemid = '4058881922320'
	
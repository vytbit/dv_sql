Select
	distinct inv.itemid, invm.taxitemgroupid
FROM
	"AX.PROD_DynamicsAX2012.dbo.Inventtable"  as inv
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.InventtableModule"  as invm
	on invm.itemid = inv.itemid
order by
	inv.itemid asc	
SELECT inv.itemid,
case 
	When (inv.AVAILPHYSICAL-inv.ONORDER)>=0 then 1
	Else 0
end, 
dim.inventlocationid
FROM "AX.PROD_DynamicsAX2012.dbo.INVENTSUM" as inv
Left Join "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" as dim
on inv.inventdimid = dim.inventdimid
Where dim.inventlocationid in ('FIEGE_GB','USTER','WDB_AB')
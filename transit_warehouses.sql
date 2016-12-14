SELECT 
	itt.itemid, sum(itt.qty) , dim.inventlocationid, sum(itt.costamountphysical)
	--, itt.packingslipid, itt.voucherphysical, itt.datephysical
FROM 
	"AX.PROD_DynamicsAX2012.dbo.INVENTTRANS" as itt
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM"  as dim
	on itt.inventdimid = dim.inventdimid
Where 
	itt.datephysical <= '2016-08-31' 
	and left(dim.inventlocationid,5) = 'TRANS'
	--and itt.itemid = '5055770002544'
Group by itt.itemid, dim.inventlocationid
Order by dim.inventlocationid desc
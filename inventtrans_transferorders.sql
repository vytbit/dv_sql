Select 
	count(inv.inventtransorigin) as "Anzahl_Transaktionen"
	/*,inv.itemid
	,inv.qty
	,dim.inventsiteid
	,dim.inventlocationid
	,invo.referenceid,
	inv.statusissue, 
	inv.statusreceipt,
	inv.datephysical*/
from 
	"AX.PROD_DynamicsAX2012.dbo.INVENTTRANS" as inv
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.INVENTDIM" as dim
	on inv.inventdimid = dim.inventdimid
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.INVENTTRANSORIGIN" as invo
	on inv.inventtransorigin = invo.recid
where 
	--inv.itemid = '4250183795095' 
	--and inv.statusissue <> 1
	left(invo.referenceid,2) = 'TF'
	and cast(datephysical as date) = '1900-01-01' 
	
--order by inv.statusissue	

/*
Glossar 

statusissue
	0 = leer
	1 = sold
	2 = deducted
	3 = picked
	4 = reserved physical
	5 = reserved ordered
	6 = on order
		
statusreceipt
	0 = leer
	4 = 
	6 = 
	5 = ordered
	3 = 
	1 = purchased
	2 =
*/	

Select distinct sl.salesid
From "AX.PROD_DynamicsAX2012.dbo.SALESLINE" as sl
Left Join "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" as dim
on sl.inventdimid = dim.inventdimid
Where sl.salesid in (
Select salesid
FROM "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" 
Where salestype = 3 and salesoriginid = 'WINDELBAR' and inventlocationid = '' and documentstatus = 4)
and dim.inventlocationid = 'WDB_AB'

--group by dim.inventlocationid

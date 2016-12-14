Select distinct stg.purchid, status
FROM "AX.PROD_DynamicsAX2012.dbo.WINPURCHORDERRECEIPTTABLESTAGING" as stg
Left Join  "AX.PROD_DynamicsAX2012.dbo.VENDPACKINGSLIPTRANS" as rec
on stg.purchid = rec.origpurchid
Where rec.origpurchid IS NULL
order by stg.purchid

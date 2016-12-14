SELECT count(distinct salesid) "AnzahlRetouren","STATUS"FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNTABLESTAGING"
group by status
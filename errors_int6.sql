Select 
	cast(createddatetime as Date) "Anlagedatum", status, count(salesid)
From
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING"
Where
	status <> 1	
Group by 
	cast(createddatetime as Date), status
order by 
	cast(createddatetime as Date) desc	
	
Select 
	count(purchid),status, cast(createddatetime as Date) "Anlagedatum",
	case left(purchid,2)
		when 'TF' then 'UML'
		else 'BEST'
	end "Type"

FROM 
	"AX.PROD_DynamicsAX2012.dbo.WINPURCHORDERRECEIPTTABLESTAGING"
Where status <> 1	
Group by status, cast(createddatetime as Date),
	case left(purchid,2)
		when 'TF' then 'UML'
		else 'BEST'
	end 
order by case left(purchid,2)
		when 'TF' then 'UML'
		else 'BEST'
	end ,cast(createddatetime as Date) desc
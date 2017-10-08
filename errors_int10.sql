Select 
	count(purchid) as "Anzahl",
	case status
		when 0 then 'created'
		when 1 then 'finished'
		when 2 then 'error'
		else 'na'
	end	as "Status_INT10"
	, cast(createddatetime as Date) "Anlagedatum    ",
	case left(purchid,2)
		when 'TF' then 'UML'
		else 'BEST'
	end "Type of Entry"

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
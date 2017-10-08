Select 
	/*cast(createddatetime as Date) "Anlagedatum", */
	case status
		when 0 then 'created'
		when 1 then 'finished'
		when 2 then 'error'
		else 'na'
	end	as "Status_INT04"
	, count(externaldocumentno) as "# Einträge"
From
	"AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING"
Where
	status <> 1	
Group by 
	/*cast(createddatetime as Date),*/ status
--order by 
--	cast(createddatetime as Date) desc	
	
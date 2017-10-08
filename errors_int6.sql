Select
	case status
		when 0 then 'created'
		when 1 then 'finished'
		when 2 then 'error'
		else 'na'
	end	as "Status_INT06"
	,ProductIdTransportProvider as "Lieferart    "
	,sum( case 
		when statustext = '' then 1
		else 0
		end) as "# ohne Statustext"
	,sum( case 
		when statustext <> '' then 1
		else 0
		end) as "# mit Statustext"	
From
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING"
Where
	status <> 1	--and statustext = ''
Group by 
	status,ProductIdTransportProvider
order by 
	case status
		when 0 then 'created'
		when 1 then 'finished'
		when 2 then 'error'
		else 'na'
	end,ProductIdTransportProvider

	
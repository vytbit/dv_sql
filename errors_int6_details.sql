Select 
	cast(st.createddatetime as Date) "Anlagedatum", st.status, st.salesid, sat.salesid, nav."Order No_"
From
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as st
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as sat
	on st.salesid = sat.salesid	
LEFT JOIN
	"nav.Urban-Brand GmbH$Sales Invoice Header" as nav
	on st.salesid = nav."Order No_"	
Where
	st.status <> 1	
--Group by 
--	cast(createddatetime as Date), status
order by 
	cast(st.createddatetime as Date) desc	
	
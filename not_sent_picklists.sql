Select
	st.salesid as "Auftragsnummer", st.winlastpickingcheck
From
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINAIFOUTBOUNDINTERFACEMESSAGELOG" as wol
	on wol.ENTITYRECID = st.recid
Where
	wol.entityrecid IS NULL	and st.documentstatus = 4 and cast(st.createddatetime as Date) between '2017-02-01' and CURDATE()
order by 
	cast(st.createddatetime as date) asc
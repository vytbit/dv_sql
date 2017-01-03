Select sl.itemid, st.salesid, st.salesoriginid, st.createddatetime, 
case sl.salesstatus
	when 1 then 'offene_Zeile'
	when 4 then 'canceled'
	else sl.salesstatus
end as	"SalesLineStatus", 
case st.salesstatus
	when 1 then 'offen'
	when 3 then 'fakturiert'
	when 4 then 'canceled'
	else st.salesstatus
end as "DocStatus"	 
from 
	"AX.PROD_DynamicsAX2012.dbo.SALESLINE" as sl
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
	on sl.salesid = st.salesid
where sl.itemid like '%-X%' 
	and cast(st.createddatetime as Date) >= '2016-12-01'
Order by st.createddatetime desc	
	
	
-- Positionsstatus Zeile (salesstatus)
-- 4 -> storniert
-- 1 -> offen
-- 3 -> fakturiert
-- 0 -> leer
-- 2 -> geliefert
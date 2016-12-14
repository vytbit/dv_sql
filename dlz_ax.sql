SELECT 
	stg.externaldocumentno,
	stg.wait,
	stg.paymmethod, 
	st.salesid, 
	st.documentstatus,
	st.salesstatus,
	month(stg.createddatetime) as "Monat",
	stg.createddatetime, 
	st.createddatetime, 
	st.winlastpickingcheck,
	pick.activationdatetime,
	TIMESTAMPDIFF (SQL_TSI_MINUTE,stg.createddatetime,st.createddatetime) as "CreateTimeSOinMIN",
	TIMESTAMPDIFF (SQL_TSI_MINUTE,st.createddatetime,st.winlastpickingcheck) as "PickTimeSOinMin",
	TIMESTAMPDIFF (SQL_TSI_MINUTE,st.createddatetime,pick.activationdatetime) as "PickTime2SOinMin"
from 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING" as stg
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
	on stg.externaldocumentno = st.customerref
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WMSPICKINGROUTE" as pick
	on pick.transrefid = st.salesid	
where 
	st.salestype = 3 and cast(stg.createddatetime as Date) >= 	'2016-10-01' and left(st.salesid,5) >= 'A00058'
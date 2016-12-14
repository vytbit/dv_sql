Select st.salesid, st.customerref, stg.shopcode,st.createddatetime, st.winlastordercheck, st.winlastpickingcheck,TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck),
case 
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 0 then 'waiting'
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 10 then '10'
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 60 then '60'
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 120 then '120'
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 300 then '300'
	when TIMESTAMPDIFF(sql_tsi_minute, st.createddatetime, st.winlastpickingcheck) < 720 then '720'
	else '>720'
	
end
from "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING" as stg
on st.customerref = stg.externaldocumentno
Where stg.orderdate = '2016-05-20' --and stg.shopcode = 'WINDELN_DE'
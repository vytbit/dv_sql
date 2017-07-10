SELECT 
	TIMESTAMPDIFF(SQL_TSI_HOUR,createddatetime,now()),	count(recid) as "Anzahl Aufträge"
	--month(createddatetime) as "Monat", dayofmonth(createddatetime) as "Tag", hour(createddatetime) as "Stunde", count(recid) as "Anzahl Aufträge"
FROM
	"AX.PROD_DynamicsAX2012.dbo.WMSPICKINGROUTE" 
WHERE
	TIMESTAMPDIFF(SQL_TSI_DAY,createddatetime,now()) < '30'	
Group by 
	TIMESTAMPDIFF(SQL_TSI_HOUR,createddatetime,now())

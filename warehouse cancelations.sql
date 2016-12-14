SELECT count("SALESID") "Anzahl Einträge", 
case "STATUS" 
	when 1 then 'Bearbeitet'
	when 0 then 'Erstellt'
	when 2 then 'Fehler'
	else 'na'
end "Status Cancelation"
FROM "AX.PROD_DynamicsAX2012.dbo.WININTORDERCANCELLINGSTAGING"
--where salesid = 'A0005812748'
group by status
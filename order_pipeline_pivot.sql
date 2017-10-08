Select  
 		st.salesoriginid "ShopCode            ",
 		sum(case st.documentstatus
			when '0' then 1
			else 0
		end ) as "OnHold",
		sum(case st.documentstatus
			when '3' then 1
			else 0
		end ) as "Confirmed",
		sum(case st.documentstatus
			when '4' then 1
			else 0
		end ) as "PickingList", 
		sum(case st.documentstatus
			when '5' then 1
			else 0
		end ) as "ReturnOrder",
		sum(case st.documentstatus
			when '7' then 1
			else 0
		end ) as "Invoice",
		count(st.salesid) "AnzahlAufträge"
from 
		"AX.PROD_DynamicsAX2012.dbo.SALESTABLE"  as st
Where 
		st.salestype not in ('0','4') 
		and st.salesstatus in('1') 
		and st.documentstatus <> '7'


Group by st.salesoriginid--,st.winsplitordercounter
order by st.salesoriginid


-- Positionsstatus Kopf (salesstatus)
-- 4 -> Storniert
-- 1 -> Offener Auftrag
-- 3 -> Fakturiert

-- Positionsstatus Zeile (salesstatus)
-- 4 -> storniert
-- 1 -> offen
-- 3 -> fakturiert
-- 0 -> leer
-- 2 -> geliefert

-- Document Status Header (documentstatus)
-- 5 -> zurückgegebener Auftrag
-- 7 -> Fakturiert
-- 0 -> Keiner
-- 3 -> Bestätigt
-- 4 -> Kommissionierliste

-- SalesType Header (salestype)
-- 0 -> Journal
-- 4 -> zurückgegebener Auftrag
-- 3 -> Auftrag

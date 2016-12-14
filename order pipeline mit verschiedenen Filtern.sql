with on_hold as (
Select distinct inventrefid
From "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS"
where mcrcleared = 0
),
in_resp as (
Select distinct salesid
from "AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
)


Select  
		case st.salesstatus
			when '1' then 'Offener Auftrag'
			when '3' then 'Fakturiert'
			when '4' then 'Storniert'
			else 'na'
		end	"SalesStatus          ", 
		case st.documentstatus
			when '0' then 'Keiner'
			when '3' then 'Bestätigt'
			when '4' then 'KommListe'
			when '5' then 'Retoure'
			when '7' then 'Fakturiert'
			else 'na'
		end "DocumentStatus", 
		case st.salestype
			when '0' Then 'Journal'
			when '3' then 'Auftrag'
			when '4' then 'Retoure'
			else 'na'
		end "SalesType", 
		st.salesoriginid "ShopCode            ",
		--st.winsplitordercounter,
		count(st.salesid) "AnzahlAufträge"
from 
		"AX.PROD_DynamicsAX2012.dbo.SALESTABLE"  as st
		--left join on_hold on on_hold.inventrefid = st.salesid
		left join in_resp  on in_resp.salesid = st.salesid
Where 
		st.salestype not in ('0','4') 
		--and st.salesoriginid = 'WINDELN_DE' 
		and st.salesstatus in('1') 
		and st.documentstatus <> '7'
		--and st.winsplitordercounter = '0'
		--and on_hold.inventrefid IS NULL
		--and in_resp.salesid IS NULL

Group by st.salesstatus, st.documentstatus, st.salestype,st.salesoriginid--,st.winsplitordercounter
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

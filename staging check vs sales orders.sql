Select  
		cast(st.winlastpickingcheck as Date)
		,st.salesoriginid
		,st.salesid

from 
		"AX.PROD_DynamicsAX2012.dbo.SALESTABLE"  as st
		LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
		on stg.salesid = st.salesid
		--left join "AX.PROD_DynamicsAX2012.dbo.SALESLINE"  as sl
		--on sl.salesid = st.salesid
		
Where 
		st.salestype not in ('0','4') 
		--and st.salesoriginid = 'WINDELN_DE' 
		and st.salesstatus = '1' 
		and st.documentstatus = '4'
		and stg.salesid IS NULL
		--and cast(st.winlastpickingcheck as Date) <> '1900-01-01'
		--and st.winsplitordercounter = '0' 
		--and st.salesid = 'A0005564617'

--Group by cast(st.winlastpickingcheck as Date)
order by st.salesid


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

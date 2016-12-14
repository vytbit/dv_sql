SELECT  st.salesid,  st.salesstatus, st.salesstatus, st.documentstatus, st.salestype, st.salesoriginid, cast(st.winlastordercheck as date) "LastOrderCheck"
FROM "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS" as trans
ON st.salesid = trans.inventrefid
Where st.salestype = '3' and st.documentstatus = '3' and trans.mcrcleared = 0 
--Group by  st.salesstatus, st.salesstatus, st.documentstatus, st.salestype, st.salesoriginid, cast(st.winlastordercheck as date)
order by cast(st.winlastordercheck as date)

-- Positionsstatus Zeile (salesstatus)
-- 4 -> storniert
-- 1 -> offen
-- 3 -> fakturiert
-- 0 -> leer
-- 2 -> geliefert

-- Positionsstatus Kopf (salesstatus)
-- 4 -> Storniert
-- 1 -> Offener Auftrag
-- 3 -> Fakturiert

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
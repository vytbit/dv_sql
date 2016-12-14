with invent as (
SELECT inv.itemid,
case 
	When (inv.AVAILPHYSICAL-inv.ONORDER)>=0 then 1
	Else 0
end, 
dim.inventlocationid
FROM "AX.PROD_DynamicsAX2012.dbo.INVENTSUM" as inv
Left Join "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" as dim
on inv.inventdimid = dim.inventdimid
Where dim.inventlocationid in ('FIEGE_GB','USTER','WDB_AB')
)

SELECT distinct sl.salesid,st.salesoriginid,/* sl.itemid, sl.salesstatus, sl.qtyordered, dim.inventlocationid,*/  (count(sl.linenum)-sum(invent.expr2))
FROM  "AX.PROD_DynamicsAX2012.dbo.SALESLINE" as sl
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
on st.salesid = sl.salesid
Left Join "AX.PROD_DynamicsAX2012.dbo.INVENTDIM" as dim
on sl.inventdimid = dim.inventdimid
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS" as trans
ON st.salesid = trans.inventrefid
LEFT JOIN invent on invent.itemid = sl.itemid and invent.inventlocationid = dim.inventlocationid
Where sl.salesstatus = '1' and st.salestype = '3' and st.documentstatus <> 4
and sl.itemid NOT IN ('ENF_PACK','LOY_FULL','LOY_0','SHIP_CN','SHIP','REB_SPAR_FULL','LOY_RED','NEUT_PACK_FEE','INVOICE_FEE','REF_FULL','REF_0','REF_RED','SAFEBOX_FLYER','VOUCHER','PAMPERS20','INFO_NEUKUNDE','SPARPLAN_PRM_2YR','INFO_GEWINNSPIEL','SPARPLAN_BASIC_2YR','SPARPLAN_BASIC_1YR','SPARPLAN_SPIEL_2YR','SPARPLAN_SPIEL_1YR','SPARPLAN_PRM_1YR','SPARPLAN_MODE_2YR','SPARPLAN_MODE_1YR','SHIP_CH','REF_MID','LOY_MID','GIFTCERT_VAR','COD_FEE')
--and invent.itemid IS NULL
and sl.salesid > 'A0005800000'
and dim.inventlocationid NOT IN ('SAMPLE_MUC')
and st.salesoriginid = 'WINDELBAR'

group by sl.salesid,st.salesoriginid
having (count(sl.linenum)-sum(invent.expr2)) = 0

order by sl.salesid asc
--, sl.itemid, sl.salesstatus, sl.qtyordered, dim.inventlocationid
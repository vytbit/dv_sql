with countlines as
(
Select salesid, count(linenum)
FROM "AX.PROD_DynamicsAX2012.dbo.SALESLINE"
Group by salesid
),
salesamount as
(
Select salesid, sum(lineamount)
FROM "AX.PROD_DynamicsAX2012.dbo.SALESLINE"
Group by salesid
)


Select st.winsplitordercounter, st.salesname,
st.customerref, countlines.expr2 "AnzahlZeilen",salesamount.expr2 "Auftragswert",st.email,count(st.salesid) "Anzahl", max(st.salesid), min(st.salesid)
FROM "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" st
LEFT JOIN countlines on countlines.salesid = st.salesid
LEFT JOIN salesamount on salesamount.salesid = st.salesid
Where st.salestype = 3 and st.salesid > 'A0005800000' --and st.documentstatus in ('0', '3')
and customerref not in ('1006002315','1006402879')
Group by st.winsplitordercounter,  st.salesname, st.customerref, countlines.expr2,salesamount.expr2,st.email
having count(st.salesid) > 1

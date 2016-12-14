with ret as
(
SELECT 
	sum(sl.lineamount) "SummeRetoure", 
	sl.currencycode, 
	st.customerref
	
FROM
    "AX.PROD_DynamicsAX2012.dbo.SALESLINE" as sl
    
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
	on sl.salesid = st.salesid 
	   
WHERE
	st.salestype = 4 --and st.customerref = '1005093549'
	
GROUP BY
	sl.currencycode, 
	st.customerref),
	
paytab as(
SELECT upd.custref, upd.sendqueuestatus, upd.invoice_currencycode, upd.salesoriginid,ct.paymmode, 
sum(
case upd.errorcode
	when 1 then upd.invoice_amount
	else 0
end	) "SummePaymTableError",
sum(
case upd.errorcode
	when 0 then upd.invoice_amount
	else 0
end	) "SummePaymTableSuccess"
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" AS ct
    ON ct.salesid = upd.salesid
   
WHERE 
	upd.winpaymenttype = 2
	AND winpaymentmanualcheck = 0
    --AND upd.custref = '1005093549'

GROUP BY 
	upd.custref, upd.sendqueuestatus, upd.invoice_currencycode, upd.salesoriginid, ct.paymmode)
	
SELECT *

FROM
	paytab
LEFT JOIN ret
	on ret.customerref = paytab.custref	

order by paytab.custref	
	
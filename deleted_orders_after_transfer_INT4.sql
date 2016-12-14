SELECT 
	upd."CUSTREF"
FROM 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd

LEFT JOIN 	
	"AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING" as st
	on st.externaldocumentno = upd.custref

Where
	--upd."CUSTREF" = '1005740659'and 
	upd.TRIGGERSALESORDERSTATUS = 1 and
	st.externaldocumentno IS NULL
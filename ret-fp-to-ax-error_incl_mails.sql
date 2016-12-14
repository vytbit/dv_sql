with salesids as 
(
Select 
	case 
		when Left(salesid,3) = 'NAV' then right(salesid,11)
		else salesid
	end "Auftragsnummer"
	,paymmode
	,customerref
FROM
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE"
)

SELECT 
	rstg.salesid "ReturnOrder"
	,cast(rstg.returndate as Date) "Retourendatum"
	,stg.salesid "StagingOrder"
	,salesids."Auftragsnummer"
	,salesids.paymmode
	,salesids.customerref
	,addr.email
	,case 
		when rstg.statustext Like '%stopped for All%' then 'Customer Blocked'
		else rstg.statustext 
	end "StatusText"
FROM 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNTABLESTAGING" as rstg
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
	on stg.salesid = rstg.salesid
LEFT JOIN
	salesids
	on salesids."Auftragsnummer" = rstg.salesid
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINADDRESSSTAGING" as addr
	on addr.addresstype = 0 and addr.Externaldocumentno = salesids.customerref
--LEFt join
--	"nav.Urban-Brand GmbH$CreateDocumentHeader" as nav
--	on nav.externaldocumentno = salesids.customerref

WHERE
	rstg.status = 2 --and st.salesid IS NOT NULL
	--and rstg.salesid = 'A0005557594'
ORDER BY
	stg.salesid	
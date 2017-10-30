SELECT 
	cast(cij.createddatetime as Date) as  "CreateDate        ",st.salesoriginid,st.createdby, left(cij.invoiceid,2) as "TypeofVoucher",count(cij.invoiceid) as "# of open Vouchers"
FROM
	"AX.PROD_DynamicsAX2012.dbo.CustInvoiceJour" as cij
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINInvoiceDocPrint" as idp
	on cij.recid = idp.SourceDocumentRecId
	--and cij.Tableid = idp.SourceDocumentTableId
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.SalesTable" as st
	on st.salesid = cij.salesid 	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINSalesTableStaging" as stg
	on stg.externaldocumentno = st.customerref 		
WHERE
	cast(cij.createddatetime as Date) >= '2017-09-30' and st.salesoriginid in ('WINDELN_DE','BEBITUS_FR','BEBITUS_PT','BEBITUS_ES')
	and idp.recid IS NULL and left(cij.invoiceid,2)  = 'IN' --and st.customerref = '5600120999'
	and stg.externaldocumentno IS NOT NULL
	and st.createdby = 'Admin'
Group by
	cast(cij.createddatetime as Date) ,st.salesoriginid,st.createdby,left(cij.invoiceid,2)	
Order by 
	cast(cij.createddatetime as Date) desc ,st.salesoriginid,st.createdby
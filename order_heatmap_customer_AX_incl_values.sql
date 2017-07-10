/* Analyse FF Aufträge in AX für Project Puffer */

with data as 
(SELECT
	cij.customerref,
	case left(cij.invoiceid,1)
		when '1' then 'Invoice'
		when 'I' then 'Invoice'
		when 'C' then 'CreditNote'
		when 'V' then 'Invoice'
		else 'na'
	end as "DocType"
	,cij.currencycode
	,cast(cij.invoicedate as Date) as "InvoiceDate"
	,cast(cij.Invoiceamount as double) as "InvoiceAmount"
	,cast(cij.Sumtax as Double) as "SumTax"
	,cast(cij.SalesBalance as double) as "SumNet"
	,cij.orderaccount
	,st.shopcode

FROM
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cij
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING" as st
	on st.externaldocumentno = cij.customerref	
	
WHERE
	cast(cij.invoicedate as Date) >= '2017-02-01'
		
)


SELECT 
	count(distinct data.customerref) as "NumberofOrders"
	,data.currencycode
	,data.orderaccount
	, data.shopcode
	,sum(data.invoiceamount) as "InvoiceAmount"
	,sum(data.sumtax) as "SumTax"
	,sum(data.sumnet) as "SumNet"
FROM
	data
	
GROUP BY

	data.currencycode
	,data.orderaccount
	,data.shopcode

HAVING
	count(distinct data.customerref) > 10

ORDER BY
	count(distinct data.customerref) desc
		

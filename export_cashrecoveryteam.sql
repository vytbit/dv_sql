with tax as
(
Select 
	voucher, sum(taxbaseamount) as "TaxBaseEUR",sum(taxamount) as "TaxEUR",sum(taxbaseamountcur) as "TaxBaseCUR",sum(taxamountcur) as "TaxCUR"
FROM
	"AX.PROD_DynamicsAX2012.dbo.TAXTRANS"
WHERE
	voucher = 'II00027696'
GROUP BY
	voucher
)

SELECT
	vt.voucher
	,cast(vt.transdate as Date) as"TransDate"
	,
	case vt.transtype
		when 0 then 'None'
		when 1 then 'Transfer'
		when 2 then 'SalesOrder'
		when 3 then 'PurchaseOrder'
		when 4 then 'Inventory'
		when 5 then 'Production'
		when 6 then 'Project'
		when 7 then 'Interest'
		when 8 then 'Customer'
		when 9 then 'Exchange adjustment'
		when 10 then 'Totaled'
		when 11 then 'Payroll'
		when 12 then 'Fixed assets'
		when 13 then 'Collection letter'
		when 14 then 'Vendor'
		when 15 then 'Payment'
		when 16 then 'Sales Tax'
		when 17 then 'Bank'
		when 18 then 'Conversion'
		when 19 then 'Bill of exchange'
		when 20 then 'Promissory note'
		when 21 then 'Cost accounting'
		when 22 then 'Labor'
		when 23 then 'Fee'
		when 24 then 'Settlement'
		when 25 then 'Allocation'
		when 26 then 'Elimination'
		when 27 then 'Cash Discount'
		when 28 then 'Overpayment-Underpayment'
		when 29 then 'Penny Difference'
		when 30 then 'Intercompany settlement'
		
	end as "TransType"
	,vt.txt
	,vt.invoice
	,vt.amountcur
	,IFNULL(tax.TaxCUR,0) as "TaxCUR"
	,vt.amountmst
	,IFNULL(tax.TaxEUR,0)as "TaxEUR"
	,vt.accountnum
	,vtc."Name"
	,IFNULL(vij.cashdisc,0) as "CashDisc"
	,vt.currencycode
	
FROM
	"AX.PROD_DynamicsAX2012.dbo.VendTrans" as vt
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.VendInvoiceJour" as vij
	on vij.ledgervoucher = vt.voucher and vt.accountnum = vij.invoiceaccount and vt.transdate = vij.invoicedate
	
LEFT JOIN
	tax on tax.voucher = vt.voucher
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.VendTableCube" as vtc
	on vtc.accountnum = vt.accountnum 		
	
WHERE
	vt.accountnum = '72020'	

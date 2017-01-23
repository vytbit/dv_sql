Select 
	Invoiceid, CurrencyCode, Invoiceamount, Sumtax, SalesBalance, cast(InvoiceDate as Date) as "InvoiceDate" 

From
	"AX.PROD_DynamicsAX2012.dbo.CustInvoiceJour" as cij	
Where
	dataareaid = 'deag'	and invoicedate between '2016-04-01' and '2016-12-31'
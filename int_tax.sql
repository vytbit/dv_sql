SELECT 
	ma.mainaccountid,je.subledgervoucher,cast(je.accountingdate as Date), cij.salesid,sl.itemid, sl.lineamount, sl.currencycode
FROM
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALENTRY" as je
Left JOIN
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALACCOUNTENTRY" as ja
	on ja.generaljournalentry = je.recid
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.MAINACCOUNT" as ma
	on ja.mainaccount = ma.recid
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" as cij
	on je.subledgervoucher = cij.invoiceid
Left Join
	"AX.PROD_DynamicsAX2012.dbo.SALESLINE" as sl
	on cij.salesid = sl.salesid	and sl.itemid = 'INT_TAX'
where
	ma.mainaccountid = '327000'	 
	and cij.salesid = 'A0007663229' 
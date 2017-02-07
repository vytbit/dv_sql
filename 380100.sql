Select 
	gj.accountingdate, gj.subledgervoucher, gj.subledgervoucherdataareaid, gj.documentdate, gj.journalcategory, gja.transactioncurrencyamount,gja.reportingcurrencyamount, gja.transactioncurrencycode, gja.text
FROM
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALENTRY" as gj
LEFT JOIN
	 "AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALACCOUNTENTRY" as gja
	 on gj.recid = gja.generaljournalentry
Where
	left(gja.ledgeraccount,6) = 380100	 
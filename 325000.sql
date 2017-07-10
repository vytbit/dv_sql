Select 
	year(gj.accountingdate) as "Jahr",month(gj.accountingdate) as "Monat", gja.postingtype,
	sum(gja.transactioncurrencyamount) as "SumTransCur" ,sum(gja.reportingcurrencyamount) as "SumRepCur"
	--, gj.subledgervoucher, gj.subledgervoucherdataareaid, gj.documentdate, gj.journalcategory, gja.text
FROM
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALENTRY" as gj
LEFT JOIN
	 "AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALACCOUNTENTRY" as gja
	 on gj.recid = gja.generaljournalentry
Where
	left(gja.ledgeraccount,6) = 325000	 and accountingdate between '2016-09-01' and '2016-10-01'

group by
	year(gj.accountingdate),month(gj.accountingdate), gja.postingtype	
order by 	
	year(gj.accountingdate),month(gj.accountingdate) asc
	
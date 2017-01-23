Select 
	cast(accountingdate as Date),lej.journalnumber, ljt.name,sum(gja.accountingcurrencyamount)
from 
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALENTRY" as gj
LEFT JOIN
	 "AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALACCOUNTENTRY" as gja
	 on gj.recid = gja.generaljournalentry
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.LEDGERENtRYJOURNAL" as lej
	 on lej.recid = gj.ledgerentryjournal
LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.LEDGERJOURNALTABLE" as ljt
	 on lej.journalnumber = ljt.JournalNum	 
		 
where gja.ledgeraccount = 327000

group by 
	cast(accountingdate as Date),lej.journalnumber, ljt.name
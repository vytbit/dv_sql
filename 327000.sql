Select 
	*
from 
	"AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALENTRY" as gj
LEFT JOIN
	 "AX.PROD_DynamicsAX2012.dbo.GENERALJOURNALACCOUNTENTRY" as gja
	 on gj.recid = gja.generaljournalentry

where gja.ledgeraccount = 332000
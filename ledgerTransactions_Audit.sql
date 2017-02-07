Select 
	gje.journalnumber, gjae.text, gjae.accountingcurrencyamount, gje.createdby, gje.subledgervoucher, gje.accountingdate, gje.documentdate, davc.displayvalue
From
	"AX.PROD_DynamicsAX2012.dbo.GeneralJournalAccountEntry" as gjae
Left Join
	"AX.PROD_DynamicsAX2012.dbo.GeneralJournalEntry" as gje
	on gje.recid = gjae.generaljournalentry
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.TransactionLog" as tl
	on tl.createdtransactionid = gjae.createdtransactionid
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.DimensionAttributeValueCombination" as davc
	on davc.Recid = gjae.ledgerdimension	 		 	

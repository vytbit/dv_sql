Select 

	ma.mainaccountid,
	--gjae.text,
	case gje.journalcategory
		when 0 then 'None'
		when 1 then 'Transfer'
		when 2 then 'Sales order'
		when 3 then 'Purchase order'
		when 4 then 'Inventory'
		when 5 then 'Production'
		when 6 then 'Project'
		when 7 then 'Interest'
		when 8 then 'Customer'
		when 9 then 'Foreign currency revaluation'
		when 10 then 'Totaled'
		when 11 then 'Payroll'
		when 12 then 'Fixed assets'
		when 13 then 'Collection letter'
		when 14 then 'Vendor'
		when 15 then 'Payment'
		when 16 then 'Sales tax'
		when 17 then 'Bank'
		when 18 then 'Ledger accounting currency conversion'
		when 19 then 'Bill of exchange'
		when 20 then 'Promissory note'
		when 21 then 'Cost accounting'
		when 22 then 'Labor'
		when 23 then 'Fee'
		when 24 then 'Settlement'
		when 25 then 'Allocation'
		when 26 then 'Elimination'
		when 27 then 'Cash discount'
		when 28 then 'Overpayment/underpayment'
		when 29 then 'Penny difference'
		when 30 then 'Intercompany settlement'
		when 31 then 'Purchase requisition'
		when 32 then 'Inflation adjustment'
		when 33 then 'Prepayment application'
		when 34 then 'Ledger reporting currency conversion'
		when 79 then 'Fixed assets (Russia)'
		when 80 then 'AR amortization'
		when 81 then 'Deferrals'
		when 82 then 'AP amortization'
		when 83 then 'Advance adjustment'
		when 84 then 'Tax agent'
		when 85 then 'Currency conversion gain/loss'
		when 100 then 'Rebate credit note processing'
		when 101 then 'Rebate pass to AP'
		when 35 then 'Write off'
		when 36 then 'General journal'
		when 251 then 'Underpayment write off'
		
		else gje.journalcategory
	end as "JournalCategory"	
	,gje.createdby,
	--gje.journalnumber,  
	sum(gjae.accountingcurrencyamount)
	/*, davc.displayvalue, cast(gje.accountingdate as Date) as "AccountingDate", gje.subledgervoucher,
	
	case fcp."month"
		when 0 Then 'One'
		when 1 Then 'Two'
		when 2 Then 'Three'
		when 3 Then 'Four'
		when 4 Then 'Five'
		when 5 Then 'Six'
		when 6 Then 'Seven'
		when 7 Then 'Eight'
		when 8 Then 'Nine'
		when 9 Then 'Ten'
		when 10 Then 'Eleven'
		when 11 Then 'Twelve'
		else 'na'
	end	as "Period"	
	 */
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
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.mainAccount" as ma
	on ma.Recid = gjae.mainaccount
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.FiscalCalendarPeriod" as fcp
	on fcp.recid = gje."FISCALCALENDARPERIOD" 	 		 	
Where 
	gje.accountingdate between '2016-01-04' and '2016-31-12'
	and ma.mainaccountid in ('484000','484100','688000','688100')
Group by
	ma.mainaccountid,
case 
gje.journalcategory
		when 0 then 'None'
		when 1 then 'Transfer'
		when 2 then 'Sales order'
		when 3 then 'Purchase order'
		when 4 then 'Inventory'
		when 5 then 'Production'
		when 6 then 'Project'
		when 7 then 'Interest'
		when 8 then 'Customer'
		when 9 then 'Foreign currency revaluation'
		when 10 then 'Totaled'
		when 11 then 'Payroll'
		when 12 then 'Fixed assets'
		when 13 then 'Collection letter'
		when 14 then 'Vendor'
		when 15 then 'Payment'
		when 16 then 'Sales tax'
		when 17 then 'Bank'
		when 18 then 'Ledger accounting currency conversion'
		when 19 then 'Bill of exchange'
		when 20 then 'Promissory note'
		when 21 then 'Cost accounting'
		when 22 then 'Labor'
		when 23 then 'Fee'
		when 24 then 'Settlement'
		when 25 then 'Allocation'
		when 26 then 'Elimination'
		when 27 then 'Cash discount'
		when 28 then 'Overpayment/underpayment'
		when 29 then 'Penny difference'
		when 30 then 'Intercompany settlement'
		when 31 then 'Purchase requisition'
		when 32 then 'Inflation adjustment'
		when 33 then 'Prepayment application'
		when 34 then 'Ledger reporting currency conversion'
		when 79 then 'Fixed assets (Russia)'
		when 80 then 'AR amortization'
		when 81 then 'Deferrals'
		when 82 then 'AP amortization'
		when 83 then 'Advance adjustment'
		when 84 then 'Tax agent'
		when 85 then 'Currency conversion gain/loss'
		when 100 then 'Rebate credit note processing'
		when 101 then 'Rebate pass to AP'
		when 35 then 'Write off'
		when 36 then 'General journal'
		when 251 then 'Underpayment write off'
		
		else gje.journalcategory
	end ,gje.createdby
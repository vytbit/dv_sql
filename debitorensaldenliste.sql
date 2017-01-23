Select
	sum(case 
		when lastsettledate > '2016-12-31' then amountcur
		else amountcur-settleamountcur
	end) as "OPENAMOUNT",
	ct.accountnum
	
	 
	/*sum(cto.amountcur)
	, sum(cto.amountmst)
	,cto.reportingcurrencyamount, cto.duedate, cto.transdate, cto.accountnum, ct.voucher, ct.amountcur, ct.settleamountcur, ct.amountmst, ct.settleamountmst, ct.currencycode, ct.reportingcurrencyamount, ct.settleamountreporting
	,gjae.transactioncurrencyamount
	,gjae.accountingcurrencyamount
	,gjae.reportingcurrencyamount
	,cto.accountnum,gjae.ledgeraccount*/
FROM
	 "AX.PROD_DynamicsAX2012.dbo.CustTrans" as ct
Left Join
	"AX.PROD_DynamicsAX2012.dbo.GeneralJournalEntry" as gje
	 on ct.voucher = gje.subledgervoucher
Left Join
	"AX.PROD_DynamicsAX2012.dbo.GeneralJournalAccountEntry" as gjae
	 on	gjae.generaljournalentry = gje.recid
Where
	--ct.accountnum = 'D01038330'  and 
	gjae.ledgeraccount in (/*'120000',*/'325000')
	and ct.transdate <= '2016-12-31'	
group by 
	ct.accountnum
having 	sum(case 
		when lastsettledate > '2016-12-31' then amountcur
		else amountcur-settleamountcur
	end) <> 0
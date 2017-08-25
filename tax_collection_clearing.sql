Select
	ljt.journalnum, lg.difforiginaltransactionvoucher, ljt.voucher
FROM
	"AX.PROD_DynamicsAX2012.dbo.WINLedgerJournalTrans_AccountClearing" as lg
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LedgerJournalTrans" as ljt
	on ljt.recid =  lg.refrecid
WHERE
	ljt.voucher in
	('GJ03899107','GJ03898227','GJ03798607')
order by 	
	lg.difforiginaltransactionvoucher asc
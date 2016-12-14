SELECT le.JOURNALNUM, le.custvendbankaccountid, le.voucher,le."MARKEDINVOICE", cus.accountnum,
bank."SWIFTNO",bank."BANKIBAN", left(bank."BANKIBAN",2)

FROM "AX.PROD_DynamicsAX2012.dbo.LEDGERJOURNALTRANS" as le
Left Join "AX.PROD_DynamicsAX2012.dbo.CUSTTRANS" as cus
on cus.invoice = le.markedinvoice
Left Join  "AX.PROD_DynamicsAX2012.dbo.CUSTBANKACCOUNT" as bank
on bank.CUSTACCOUNT = cus.accountnum and le.custvendbankaccountid = bank.accountid


Where Journalnum = 'BN00001181' 
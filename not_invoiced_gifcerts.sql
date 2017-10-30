Select 
	salesid
FROM
	"AX.PROD_DynamicsAX2012.dbo.SalesLine"
where
	itemid = 'GIFTCERT_VAR' and cast(createddatetime as Date) > '2017-01-30' and salesstatus = 1
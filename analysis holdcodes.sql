Select mcrholdcode,count(inventrefid) "AnzahlEinträge", mcrcomment
FROM "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS"
Where mcrcleared = 0 --and mcrholdcode = '04' --and mcrcomment = 'DlvMode on line not found'  -- --
group by mcrholdcode,mcrcomment
order by count(inventrefid) desc

Select distinct inventrefid
FROM "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS"
Where mcrcleared = 0 and
mcrholdcode = '02'
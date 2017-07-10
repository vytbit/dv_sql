SELECT 
	
	sum(case when 
		Markingrefinventtransorigin = 0 then 1
		else 0
	end )as "NotMarked",
	sum(case when 
		Markingrefinventtransorigin <> 0 then 1
		else 0
	end )as "Marked"
		
FROM 
	"AX.PROD_DynamicsAX2012.dbo.INVENTTRANS"

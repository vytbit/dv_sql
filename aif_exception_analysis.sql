SELECT 
	*
FROM 
	"AX.PROD_DynamicsAX2012.dbo.SYSEXCEPTIONTABLE" as syet
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.AIFEXCEPTIONMAP" as aem
	on aem.exceptionid = syet.recid	
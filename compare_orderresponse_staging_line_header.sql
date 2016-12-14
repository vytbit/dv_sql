SELECT 
	stgh.status "StatusHeader"
	,stgl.status "StatusZeile"
	,stgh.salesid "SalesIdHeader"
	,stgl.salesid "SalesIdZeile"
FROM 
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTLINESTAGING" as stgl
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stgh
	on stgl.salesid =stgh.salesid
WHERE
	stgl.status <> stgh.status
	--and 
	--stgh.salesid = 'A0005668750'
SELECT 
	count(st.recid), st.salesoriginid
FROM "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
WHERE
	st.SalesStatus = 1
	AND st.WINReadyForPicking = 0
	AND st.WINIsOrderAutomatic = 1
	AND st.DocumentStatus = 3
	AND st.SalesType = 3
	AND st.WINLastOrderCheck = '1900-01-01 00:00:00.0'
	AND st.WINOrderManagementBatchCounter = 0
	AND st.MCROrderStopped = 0
	--AND st.SalesOriginId = 'WINDELN_DE'
GROUP BY
	st.salesoriginid	

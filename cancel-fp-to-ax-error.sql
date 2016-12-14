SELECT 
	count(stg."SALESID") "AnzahlEintröge"
	--,st.customerref
	,case stg."STATUS"
		when 0 then 'Created'
		when 1 then 'Finished'
		when 2 then 'Error'
	end "StatusStaging"
	,case st.documentstatus
		when 0 then 'none'
		when 3 then 'confirmed'
		when 4 then 'picking list'
		when 5 then 'return order'
		when 7 then 'invoice'
	end "DocStatusSalesTable"
	, case st.salesstatus
		when 1 then 'open order'
		when 3 then 'invoiced'
		when 4 then 'canceled'
	end	"SalesStatusSalesTable"
FROM "AX.PROD_DynamicsAX2012.dbo.WININTORDERCANCELLINGSTAGING" as stg
LEFT JOIN 
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st
	on stg.salesid = st.salesid
LEFT JOIN
	 "AX.PROD_DynamicsAX2012.dbo.WINADDRESSSTAGING" as stgs	
	 on st.customerref = stgs.externaldocumentno and stgs.addresstype = 1
--Where stg.status = 0 and st.documentstatus = 4 and st.salesstatus = 1
GROUP BY
	case stg."STATUS"
		when 0 then 'Created'
		when 1 then 'Finished'
		when 2 then 'Error'
	end
	, 
	case st.documentstatus
		when 0 then 'none'
		when 3 then 'confirmed'
		when 4 then 'picking list'
		when 5 then 'return order'
		when 7 then 'invoice'
	end
	, 
	case st.salesstatus
		when 1 then 'open order'
		when 3 then 'invoiced'
		when 4 then 'canceled'
	end
order by case stg."STATUS"
		when 0 then 'Created'
		when 1 then 'Finished'
		when 2 then 'Error'
	end
	, 
	case st.documentstatus
		when 0 then 'none'
		when 3 then 'confirmed'
		when 4 then 'picking list'
		when 5 then 'return order'
		when 7 then 'invoice'
	end
	, 
	case st.salesstatus
		when 1 then 'open order'
		when 3 then 'invoiced'
		when 4 then 'canceled'
	end



-- Positionsstatus Kopf (salesstatus)
-- 4 -> Storniert
-- 1 -> Offener Auftrag
-- 3 -> Fakturiert

-- Document Status Header (documentstatus)
-- 5 -> zurückgegebener Auftrag
-- 7 -> Fakturiert
-- 0 -> Keiner
-- 3 -> Bestätigt
-- 4 -> Kommissionierliste
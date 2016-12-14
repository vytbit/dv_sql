SELECT 
st.salesoriginid as Shop
,SUM(CASE
		WHEN st.salesoriginid = 'WINDELBAR' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())<15 THEN 1
		WHEN st.salesoriginid = 'WINDELN_DE' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())<15 THEN 1
		WHEN st.salesoriginid = 'WINDELN_IT' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())<15 THEN 1
		WHEN st.salesoriginid = 'WINDELN_CH' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())<15 THEN 1 ELSE 0
		END) as "within 15 days"		
,SUM(CASE
		WHEN st.salesoriginid = 'WINDELBAR' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW()) between 15 and 21 THEN 1
		WHEN st.salesoriginid = 'WINDELN_DE' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 15 and 21 THEN 1
		WHEN st.salesoriginid = 'WINDELN_IT' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 15 and 21 THEN 1
		WHEN st.salesoriginid = 'WINDELN_CH' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 15 and 21 THEN 1
		END) as "15-21 days"	
,SUM(CASE
		WHEN st.salesoriginid = 'WINDELBAR' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 21 and 29 THEN 1
		WHEN st.salesoriginid = 'WINDELN_DE' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 22 and 28 THEN 1
		WHEN st.salesoriginid = 'WINDELN_IT' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 22 and 28 THEN 1
		WHEN st.salesoriginid = 'WINDELN_CH' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 22 and 28 THEN 1
		END) as "22-28 days"
		
,SUM(CASE
		WHEN st.salesoriginid = 'WINDELBAR' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 29 and 35 THEN 1
		WHEN st.salesoriginid = 'WINDELN_DE' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 29 and 35 THEN 1
		WHEN st.salesoriginid = 'WINDELN_IT' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 29 and 35 THEN 1
		WHEN st.salesoriginid = 'WINDELN_CH' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())between 29 and 35 THEN 1
		END) as "29-35 days"
,SUM(CASE
		WHEN st.salesoriginid = 'WINDELBAR' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())> 35 THEN 1
		WHEN st.salesoriginid = 'WINDELN_DE' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())> 35 THEN 1
		WHEN st.salesoriginid = 'WINDELN_IT' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())> 35  THEN 1
		WHEN st.salesoriginid = 'WINDELN_CH' and st.documentstatus = 3 and st.salesstatus = 1 and timestampdiff (sql_tsi_day,so.order_date,NOW())> 35THEN 1
		END) as "more than 35"
		
FROM "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st

LEFT JOIN "shop_orders.orders"as so
ON so.order_id = st.customerref

LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING" as stg 
ON st.salesid= stg.salesid

group by st.salesoriginid


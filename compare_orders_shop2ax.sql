Select distinct (sh.order_id, st.customerref)
FROM "shop_orders.orders" as sh
  Left JOIN "AX"."PROD_DynamicsAX2012.dbo.SALESTABLE" as st
    on sh.order_id = st.customerref
 WHERE sh.order_date > '2016-05-30'
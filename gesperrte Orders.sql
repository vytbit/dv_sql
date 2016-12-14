SELECT
        distinct st.inventlocationid as Warehouse
        ,CASE
            WHEN st.documentstatus = 3 and st.salesstatus = 1 THEN 'Offen' 
            WHEN st.documentstatus = 4 THEN 'Fulfillment'
            WHEN st.documentstatus = 0 and st.salesstatus = 1 THEN 'Warten'
        END as Status
        ,count (st.salesid) as No_Orders
        ,sum(CASE WHEN trans.mcrholdcode = '01' and trans.mcrcleared = 0 THEN 1 else 0 end) as Prepayment
        ,sum(CASE WHEN trans.mcrholdcode = '02' and trans.mcrcleared = 0 THEN 1 else 0 end) as Fraud 
        ,sum(CASE WHEN trans.mcrholdcode = '03' and trans.mcrcleared = 0 THEN 1 else 0 end) as "Price Error"
        ,sum(CASE WHEN trans.mcrholdcode = '04' and trans.mcrcleared = 0 THEN 1 else 0 end) as "Order Error" 
        ,sum(CASE WHEN trans.mcrholdcode = '05' and trans.mcrcleared = 0 then 1 else 0 end) as "Process Error"
        ,sum(CASE WHEN trans.mcrholdcode = '06' and trans.mcrcleared = 0 then 1 else 0 end) as "Chargeback"
        ,sum(CASE WHEN trans.mcrholdcode = '07' and trans.mcrcleared = 0 then 1 else 0 end) as "Lagerstornos"
        ,sum(CASE WHEN trans.mcrholdcode = '07' and trans.mcrcleared = 0 then 1 else 0 end) as "Key Account Sales Order"
        ,sum(CASE WHEN trans.mcrholdcode = '94' and trans.mcrcleared = 0 then 1 else 0 end) as "Warehouse Cancelation"
        ,sum(CASE WHEN trans.mcrholdcode = '95' and trans.mcrcleared = 0 then 1 else 0 end) as "Doppellieferung Retouren"
        ,sum(CASE WHEN trans.mcrholdcode = '96' and trans.mcrcleared = 0 then 1 else 0 end) as "Telefonnummer China"
        ,sum(CASE WHEN trans.mcrholdcode = '97' and trans.mcrcleared = 0 then 1 else 0 end) as "Doppelter Auftragsversand"
        ,sum(CASE WHEN trans.mcrholdcode = '98' and trans.mcrcleared = 0 then 1 else 0 end) as "China-GK"
        ,sum(CASE WHEN trans.mcrholdcode = '99' and trans.mcrcleared = 0 then 1 else 0 end) as "Migration Error"
        ,sum(CASE WHEN trans.mcrholdcode = '100' and trans.mcrcleared = 0 then 1 else 0 end) as "BACKLOG CLEANING"
        
       
    FROM
        "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st 
        LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS" as trans
        ON st.salesid = trans.inventrefid

    WHERE
        st.inventlocationid NOT LIKE ''
        and inventlocationid NOT LIKE 'S_FIEGE_GB'
        and documentstatus <> 5
        and documentstatus <> 7
        and salesstatus <> 3
        and salesstatus <> 4
        
   GROUP BY st.documentstatus
        ,st.inventlocationid
        ,st.salesstatus
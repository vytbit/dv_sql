SELECT
        distinct st.salesoriginid
        ,CASE
            WHEN st.documentstatus = 3 and st.salesstatus = 1 THEN 'Warten auf Ware' 
            WHEN st.documentstatus = 4 THEN 'Fulfillment'
            WHEN st.documentstatus = 0 and st.salesstatus = 1 THEN 'Warten auf Zahlung-Fraud-Error'
        END as Status
        ,count (st.salesid) as No_Orders
        ,sum(CASE WHEN trans.mcrholdcode = '01' and trans.mcrcleared = 0 THEN 1 else 0 end) as Prepayment
        ,sum(CASE WHEN trans.mcrholdcode = '02' and trans.mcrcleared = 0 THEN 1 else 0 end) as Fraud 
        ,sum(CASE WHEN trans.mcrholdcode = '03' and trans.mcrcleared = 0 THEN 1 else 0 end) as "Price Error"
        ,sum(CASE WHEN trans.mcrholdcode = '04' and trans.mcrcleared = 0 THEN 1 else 0 end) as "Order Error" 
        ,sum(CASE WHEN trans.mcrholdcode = '05' and trans.mcrcleared = 0 then 1 else 0 end) as "Process Error"
        ,sum(CASE WHEN trans.mcrholdcode = '06' and trans.mcrcleared = 0 then 1 else 0 end) as "Chargeback"
        ,sum(CASE WHEN trans.mcrholdcode = '98' and trans.mcrcleared = 0 then 1 else 0 end) as "China-GK"
        ,sum(CASE WHEN trans.mcrholdcode = '99' and trans.mcrcleared = 0 then 1 else 0 end) as "Migration Error"
       
    FROM
        "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st 
        LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS" as trans
        ON st.salesid = trans.inventrefid
        LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING"  as stg
        on st.salesid = stg.salesid 

    WHERE
        --st.inventlocationid NOT LIKE ''
        --and inventlocationid NOT LIKE 'S_FIEGE_GB'
         documentstatus <> 5
        and documentstatus <> 7
        and salesstatus <> 3
        and salesstatus <> 4
        and stg.salesid IS NULL
        
   GROUP BY st.documentstatus
        ,st.salesoriginid
        ,st.salesstatus
with in_resp as (
Select distinct salesid
from "AX.PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTTABLESTAGING" as stg
)

SELECT
        st.salesoriginid as Shop
        ,CASE 
        	WHEN trans.mcrholdcode = '01' THEN 'Prepayment'
        	WHEN trans.mcrholdcode = '02' THEN 'Fraud'
        	WHEN trans.mcrholdcode = '03' THEN 'Price Error'
        	WHEN trans.mcrholdcode = '04' THEN 'Order Error'
        	WHEN trans.mcrholdcode = '05' THEN 'Process Error'
        	WHEN trans.mcrholdcode = '06' THEN 'Charge Back'
        	WHEN trans.mcrholdcode = '98' THEN 'China GK'
        	WHEN trans.mcrholdcode = '99' THEN 'Migration Error'
        	ELSE 'na'
    	END as Typ
    	,count(st.salesid) as No_SalesID
       
    FROM
        "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" as st 
        LEFT JOIN "AX.PROD_DynamicsAX2012.dbo.MCRHOLDCODETRANS" as trans
        ON st.salesid = trans.inventrefid
        left join in_resp  on in_resp.salesid = st.salesid

    WHERE
    	trans.mcrcleared = 0 and in_resp.salesid IS NULL
        
	GROUP BY
		st.salesoriginid, CASE 
        	WHEN trans.mcrholdcode = '01' THEN 'Prepayment'
        	WHEN trans.mcrholdcode = '02' THEN 'Fraud'
        	WHEN trans.mcrholdcode = '03' THEN 'Price Error'
        	WHEN trans.mcrholdcode = '04' THEN 'Order Error'
        	WHEN trans.mcrholdcode = '05' THEN 'Process Error'
        	WHEN trans.mcrholdcode = '06' THEN 'Charge Back'
        	WHEN trans.mcrholdcode = '98' THEN 'China GK'
        	WHEN trans.mcrholdcode = '99' THEN 'Migration Error'
        	ELSE 'na'
    	END 
		
	ORDER BY 
	st.salesoriginid,
		 CASE 
        	WHEN trans.mcrholdcode = '01' THEN 'Prepayment'
        	WHEN trans.mcrholdcode = '02' THEN 'Fraud'
        	WHEN trans.mcrholdcode = '03' THEN 'Price Error'
        	WHEN trans.mcrholdcode = '04' THEN 'Order Error'
        	WHEN trans.mcrholdcode = '05' THEN 'Process Error'
        	WHEN trans.mcrholdcode = '06' THEN 'Charge Back'
        	WHEN trans.mcrholdcode = '98' THEN 'China GK'
        	WHEN trans.mcrholdcode = '99' THEN 'Migration Error'
        	ELSE 'na'
    	END 

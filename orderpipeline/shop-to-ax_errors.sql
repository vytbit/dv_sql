SELECT count("ENTRYNO"), "SHOPCODE", "STATUS" FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESTABLESTAGING"
where status = '2'
group by status, shopcode

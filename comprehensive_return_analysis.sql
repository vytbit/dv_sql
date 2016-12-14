with lines as
(
  Select
    CASE left(salesid,3)
      when 'NAV' then right(salesid,11)
      else salesid
    end
    as CuttedNo
    ,salesid as OriginialNo
    ,itemid
    ,linenum

  from "PROD_DynamicsAX2012.dbo.SALESLINE"
)

Select
    stgl.linenum as ZeilennummerRetoure
    ,stgl.itemid as ArtikelnummerRetoure
    ,stgl.quantityreturned as AnzahlRetoure
    ,stg.salesid as AuftragsnummerRetoure2
    ,stg.returnitemnum
    ,stg.inventlocationid as LagerRetoure
    ,case st.status
      when 0 then 'created'
      when 1 then 'finished'
      when 2 then 'error'
      else 'na'
     end as StatusOrderRespStaging
    ,lines.itemid
    ,ssl."Order No_" as inNav
FROM
    "PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNLINESTAGING" as stgl
LEFT JOIN
    "PROD_DynamicsAX2012.dbo.WINSALESORDERRETURNTABLESTAGING" as stg
    on stgl.returnitemnum = stg.returnitemnum
LEFT JOIN
    "PROD_DynamicsAX2012.dbo.WINSALESORDEROUTPUTLINESTAGING" as st
    on st.salesid = stg."salesid" and st.itemid = stgl.itemid
LEFT JOIN lines
   on lines.cuttedno = stg.salesid and lines.itemid = stgl.itemid and lines.linenum = (stgl.linenum/1000)
LEFT JOIN
    "Urban-Brand GmbH$Sales Shipment Line" as ssl
    on ssl."Order No_" = stg.salesid and ssl."Order Line No_" = stgl.linenum and stgl.itemid = ssl."No_" and ssl.Quantity <> 0
Where stg.status = 2
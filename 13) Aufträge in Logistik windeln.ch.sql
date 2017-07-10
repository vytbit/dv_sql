SELECT sh.[No_] , sh.[External Document No_],CAST( sh.[DHL Reporting Date] as Date),  left(eb.[File No_],2)
  FROM [urban_NAV600].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
  join [urban_NAV600].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] as eb with (NOLOCK)
  on sh.No_ = eb.No_
  WHERE sh.[Document Type] in ('11')
	AND sh.[No_] not like '9%'
	and sh.[Reason Code] in ('WINDELN_CH')
	and eb.[Processing Status] = 0
	Order by CAST( sh.[DHL Reporting Date] as Date) asc
 
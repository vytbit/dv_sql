SELECT 
	case st.InclTax
		when 0 then 'ohneMwSt'
		when 1 then 'inklMwSt'
		else 'na'
	end "InclTax",
	case  st.salestype
		when 3 then 'Rechnung'
		when 4 then 'Gutschrift'
		else 'na'
	end	"SalesType",
	tax."TAXCODE", 
	taxh.WINitemid,
	tax."TAXBASEAMOUNT", 
	tax."TAXAMOUNT", 
	tax."CURRENCYCODE",  
	tax."TAXITEMGROUP", 
	cij."CURRENCYCODE",
	cij."INVOICEACCOUNT",
	st.Paymmode,
	tax."TAXGROUP",
	cij."CUSTOMERREF",
	cij."SALESORIGINID",
	tax."VOUCHER", 
	tax."TRANSDATE", 
	cij."CUSTGROUP",
	cij."INVOICEACCOUNT",
	st."LANGUAGEID",
	st.payment,	
	cij."DLVMODE",	
	cij."DLVTERM",
	st."SALESID",
	st."DELIVERYNAME",
	st.email,
	--adr.CountryRegionId,
	--adr.Address,
	--adr.Street,
	--adr.City,
	--adr.ZipCode,
	--loc.description,
	cij."CUSTOMERREF"
	
	
FROM 
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" st

LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" cij
	on 	cij.SalesId = st.SalesId
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.TAXTRANS" tax	
	on tax.voucher = cij.LedgerVoucher and tax.transdate = cij.InvoiceDate
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.TAXITEMGROUPHEADING" as taxh
	on tax."TAXITEMGROUP" = taxh.taxitemgroup
	 
where 
 cij."CUSTOMERREF" in --('1006289958')
	(Select distinct customerref from "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" where TaxGroup = 'SK_NAT') 

and 
st.salestype <> 0 --and st.InclTax = 0 

order by cij."CUSTOMERREF" desc


/*Group by 
	st.InclTax,
	st.salestype,
	tax."TAXCODE", 
	taxh.WINitemid,	
	tax."CURRENCYCODE",  
	tax."TAXITEMGROUP", 
	cij."CURRENCYCODE",
	cij."INVOICEACCOUNT",
	st.Paymmode,
	tax."TAXGROUP",
	cij."CUSTOMERREF"


	--cij."SALESORIGINID",
	--tax."VOUCHER", 
	--tax."TRANSDATE", 
	--cij."CUSTGROUP",
	--cij."INVOICEACCOUNT",
	--st."LANGUAGEID",
	--st.payment,	
	--cij."DLVMODE",	
	--cij."DLVTERM",
	--st."SALESID",
	--st."DELIVERYNAME",
	--st.email,
	--adr.CountryRegionId,
	--adr.Address,
	--adr.Street,
	--adr.City,
	--adr.ZipCode,
	--loc.description
	--cij."CUSTOMERREF"*/



SELECT 
	distinct 
	cij."SALESORIGINID",
	cij."CURRENCYCODE",
	cij."INVOICEACCOUNT",
	cij."CUSTGROUP",
	cij."INVOICEACCOUNT",
	st."LANGUAGEID",
	st."DELIVERYNAME",
	--st.email,
	st.Paymmode,
	--st.payment,		
	cij."DLVTERM",
	tax."TAXGROUP",
	cij."CUSTOMERREF",
	cij."CUSTOMERREF",
	adr.CountryRegionId,
	--adr.Address,
	adr.Street,
	adr.City,
	adr.ZipCode,
	loc.description
	
FROM 
	"AX.PROD_DynamicsAX2012.dbo.TAXTRANS" tax
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.CUSTINVOICEJOUR" cij
	on 	cij.invoiceid = tax.voucher
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.SALESTABLE" st
	on st.salesid = cij.salesid
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LogisticsPostalAddress" adr
	on adr.Recid = st.deliverypostaladdress
	
LEFT JOIN
	"AX.PROD_DynamicsAX2012.dbo.LogisticsLocation" loc
	on loc.Recid = adr.Location
	 	
where cij."CUSTOMERREF" in 
	(Select distinct customerref from "AX.PROD_DynamicsAX2012.dbo.SALESTABLE" where TaxGroup = 'SE_NAT') 
	and st."DELIVERYNAME" <> 'windeln.de AG'
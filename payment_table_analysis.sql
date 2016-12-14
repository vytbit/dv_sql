SELECT resp.iserror, resp.recid,resp."WINSTATUSMESSAGEID", resp.statuscode,upd.custref, upd.documentstatus, upd.salesid, upd.salesstatus, upd.salesline_qty, upd.sendqueuestatus, upd.invoice_amount, upd.invoice_currencycode, upd.invoice_custpaymmode, upd.invoice_invoiceid, upd.errorcode, upd.salesoriginid, upd.winpaymenttype, upd.wincancelcode, upd.winpaymentmanualcheck
FROM "AX.PROD_DynamicsAX2012.dbo.WINSALESSTATUSUPD" as upd
Left Join "AX.PROD_DynamicsAX2012.dbo.WINSALESPAYMENTRESPONSE" as resp
on upd."WINSTATUSMESSAGEID" = resp."WINSTATUSMESSAGEID"
where  WINPAYMENTTYPE = '2' --and custref = '312093304'

order by resp."WINSTATUSMESSAGEID",resp.recid

-- SendQueueStatus (Warteschlangenstatus)
-- 1 -> versendet
-- 0 -> noch nicht versendet

-- WINPAYMENTTYPE
-- 0 -> keine payment-message
-- 1 -> Capture
-- 2 -> Refund
-- 3 -> Announcement
-- 4 -> Cancel
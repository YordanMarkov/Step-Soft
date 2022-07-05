--:c_src_CompanyName_op
--:c_dest_CompanyName_op
--:d_StartDate
--:d_EndDate
--:i_t_DocType

--CREATE INDEX person_index ON sServ.Person(ID);
--CREATE INDEX title_index ON sServ.sTitle(Origin, DateCreated, DocType, DocNum);
--CREATE INDEX nomencl_index ON sServ.Nomencl(NomID, ItemID);
--CREATE INDEX doctype_index ON sServ.sDocType(NomID, ItemID);
--CREATE INDEX row_index ON sServ.sRow(Origin, DateCreated, DocType, DocNum, DocRowID);
--CREATE INDEX company_index ON sServ.Company(ID);


select
  ps4.FullName as t_Author ,
  t.Origin as t_OriginID,
  t.DocNum as t_DocNumID,
  t.DateCreated as t_DateCreated ,
  t.DocType as t_DocTypeID,
  NomField0.ItemText as t_PayKind ,
  d.DocText as t_DocType ,
  t.InvoiceNum as t_InvoiceNum ,
  sum(r.TotalLV) as r_TotalLV_sum ,
  sum(r.taxbasetotal) as TaxBaseTotal,
  dest.Bulstat as dest_Bulstat,
  src.Bulstat as src_Bulstat,
  dest.CompanyName as dest_CompanyName,
  src.CompanyName as src_CompanyName,
  CASE WHEN t.DocSubType < 1073741824 THEN null ELSE '?' END as SubType,
  t.comment as t_comment
from
  sServ.sTitle t 
  left outer join sServ.Person ps4 on  
    t.Author=ps4.ID 
  left outer join sServ.Nomencl nomfield0 on  
    t.PayKind=NomField0.ItemID and NomField0.NomID=35 
  left outer join sServ.sDocType d on  
    t.DocType=d.ItemID 
  left outer join sServ.sRow r on  
    t.Origin=r.Origin and t.DateCreated=r.DateCreated and t.DocType=r.Doctype and t.DocNum=r.DocNum 
  left outer join sServ.Company dest on  
    t.Destination=dest.ID
  left outer join sServ.Company src on
    t.Source=src.ID
where
  --t.DateCreated >=:d_StartDate  and
  --t.DateCreated <=:d_EndDate  and
  --src.ID=:c_src_CompanyName_op and
  --dest.ID=:c_dest_CompanyName_op and
  --t.DocType =:i_t_DocType  and
  1=1
group by
  ps4.FullName ,
  t.Origin,
  t.DocNum,
  t.DateCreated,
  t.DocType,
  NomField0.ItemText ,
  d.DocText ,
  t.InvoiceNum ,
  dest.CompanyName,
  src.CompanyName,
  dest.Bulstat,
  src.Bulstat,
  t.DocSubType,
  t.comment
order by
  t.DateCreated ,
  d.DocText ,
  t.InvoiceNum
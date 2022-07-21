@AbapCatalog.sqlViewName: 'ZMEHMET_CDS013'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '13.CDS'
define view ZMEHMET_ddl013
  as select from acdoca as acd
  association to ZMEHMET_ddl012 as _company on acd.rbukrs = _company.bukrs
{

  acd.rldnr,
  acd.rbukrs,
  acd.gjahr,
  acd.belnr,

  _company.zland,
  _company.butxt,
  _company._t5.natio50 as znatio
} 
 
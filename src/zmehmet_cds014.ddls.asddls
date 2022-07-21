@AbapCatalog.sqlViewName: 'ZMEHMET_CDS014'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '14.CDS'
define view ZMEHMET_ddl014
  as select from zug_t_depo as depo
  association [1..1] to zug_t_matnr as _matnr on depo.depo_id = _matnr.depo_id
{
  depo.depo_id,
  depo.stok as kapasite,

  _matnr.matnr
} 
 
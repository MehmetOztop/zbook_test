@AbapCatalog.sqlViewName: 'ZMEHMET_CDS009'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '9.CDS'
define view ZMEHMET_ddl009
  with parameters
    p_lgort : abap.char( 4 )
  as select from ZMEHMET_ddl008 ( p_lgort: $parameters.p_lgort) as z
    inner join   makt                                           as m on  z.matnr = m.matnr
                                                                     and m.spras = 'T'
{
  z.matnr,
  maktx,
  zfark

} 
 
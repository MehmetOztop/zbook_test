@AbapCatalog.sqlViewName: 'ZMEHMET_CDS008'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '8.CDS'
define view ZMEHMET_ddl008
  with parameters
    p_lgort : abap.char( 4 )
  as select from ZMEHMET_ddl007
{
  matnr,
  sum(zfark) as zfark
}
where
  lgort = $parameters.p_lgort
group by
  matnr 
 
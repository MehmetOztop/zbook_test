@AbapCatalog.sqlViewName: 'ZMEHMET_CDS007'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '7.CDS'
define view ZMEHMET_ddl007
  as select from nsdm_v_mseg
{
  mblnr,
  mjahr,
  zeile,
  lgort,
  matnr,
  meins,
  case
  when
   bwart = '101' then menge
   when
   bwart = '102' then menge * -1
  end as zfark

}
where
     bwart = '101'
  or bwart = '102' 
 
@AbapCatalog.sqlViewName: 'ZMEHMET_CDS015'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Association'
define view ZMEHMET_ddl015
  as select from vbak
  association [1..*] to vbap          as _vbap on  vbak.vbeln = _vbap.vbeln
  association [1..*] to prcd_elements as _prcd on  vbak.knumv        = _prcd.knumv
                                               and $projection.posnr = _prcd.kposn
{
  vbeln,
  knumv,
  _vbap.posnr,
  _vbap.kwmeng,

  //  _prcd.kposn,
  //  _prcd.kschl,
  //  _prcd.kbetr,
  //public
  _prcd

}
where
  vbeln = '0000000035' 
 
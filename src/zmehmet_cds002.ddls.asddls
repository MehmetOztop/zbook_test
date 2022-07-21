@AbapCatalog.sqlViewName: 'zmehmet_cds002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS 2 Eğitim'
define view zmehmet_ddl002
  as select from eket
    inner join   ekpo on  eket.ebeln = ekpo.ebeln
                      and eket.ebeln = ekpo.ebeln
    inner join   ekko on ekko.ebeln = ekpo.ebeln
{
  key ekko.ebeln,
  key ekpo.ebelp,
      eket.menge,
      eket.wemng,
      eket.menge - eket.wemng as zacikmiktar
      //    case
      //    when eket.menge = eket.wemng
      //    then 'X'
      //    when eket.menge <> eket.wemng
      //    then ''
      //    end as gosterge
}
//where eket.menge <> eket.wemng 
 
@AbapCatalog.sqlViewName: 'ZMEHMET_CDS005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '18.04 Ödev'
@OData.publish: true
define view ZMEHMET_DDL005 as select from acdoca
   { key rbukrs,
     key gjahr,
     key belnr,
     key docln,
     hsl,
     case
     when hsl < 0
     then '-'
     when hsl > 0
     then '+'
     when hsl = 0
     then '0'
     end as durum
    
} where rldnr = '0L' 
 
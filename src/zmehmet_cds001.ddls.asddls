@AbapCatalog.sqlViewName: 'zmehmet_cds001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '1.CDS örnek'
define view zmehmet_DDL001 as select from vbap {
    vbeln,
    cast('A' as abap.char( 2 )) as ztext,
    @Semantics.quantity.unitOfMeasure: 'MEINS'
    sum( kwmeng ) as sum_menge,
    cast (min (kwmeng ) as zmin_ga) as min_menge,
    max( kwmeng ) as max_meng,
    avg( netpr as abap.curr( 11, 2)) as avg_netpr,
    @Semantics.unitOfMeasure: 'MEINS'
    meins
}
group by vbeln , meins
 
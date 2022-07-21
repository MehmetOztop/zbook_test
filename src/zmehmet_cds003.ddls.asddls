@AbapCatalog.sqlViewName: 'zmehmet_cds003'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3.CDS Join'
define view zmehmet_ddl003 as select from vbak
left outer join vbap
    on vbak.vbeln = vbap.vbeln{
    key vbak.vbeln,
    key posnr,
    kwmeng,
    div(vbap.kwmeng, 3) as zdiv,
    division(vbap.kwmeng, 3, 3) as zdivision,
    ceil(division(vbap.kwmeng, 3, 3)) as zceil,
    floor(division(vbap.kwmeng, 3, 3)) as zfloor,
    round(division(vbap.kwmeng, 3, 3), 0) as zr0,
    round(division(vbap.kwmeng, 3, 3), 1) as zr1,
    round(division(vbap.kwmeng, 3, 3), 2) as zr2,
    round(division(vbap.kwmeng, 3, 3), 3) as zr3,
    
    concat(ltrim(vbak.vbeln, '0'), vbap.posnr) as zcontact,
    
    $session.user as zuser
    
} 

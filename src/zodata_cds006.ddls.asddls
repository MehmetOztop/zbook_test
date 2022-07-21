@AbapCatalog.sqlViewName: 'zodata_cds006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'deneme'
@OData.publish: true
define view zodata_ddl006 
as select from zodata_t_header as z1
inner join zodata_t_item as z2 on z1.ebeln = z2.ebeln
left outer join kna1 as z3 on z1.kunnr = z3.kunnr
left outer join lfa1 as z4 on z1.lifnr = z4.lifnr
left outer join makt as z5 on z2.matnr = z5.matnr 
                          and z5.spras = $session.system_language       

{
key z1.ebeln,
key z2.ebelp,
    z1.bukrs,
    z1.bsart,
    z2.txz01,
    z2.matnr,
    z5.maktx,
    z2.lgort,
    z2.menge,
    case
    when z1.lifnr is not null then z1.lifnr
    else z1.kunnr
    end as musteri_no,
    case 
    when z1.lifnr is not null then z4.name1
    else z3.name1
    end as musteri
    
    
    
}   
 
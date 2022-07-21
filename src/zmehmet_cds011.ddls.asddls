@AbapCatalog.sqlViewName: 'ZMEHMET_CDS011'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Union Örnek'
define view ZMEHMET_ddl011
  as select from    a078
    left outer join konp on konp.knumh = a078.knumh
{
  'A078_1'           as tabname,
  a078.kappl,
  a078.kschl,
  a078.aland,
  cast('' as taxk1 ) as TAXK1,
  cast('' as taxm1 ) as TAXM1,
  a078.lland,
  a078.datbi,
  a078.datab,
  a078.knumh,
  konp.krech,
  konp.kbetr,
  konp.konwa,
  konp.kpein,
  konp.kmein

}

union all select from a002
  left outer join     konp on konp.knumh = a002.knumh
{
  'A002'             as tabname,
  a002.kappl,
  a002.kschl,
  a002.aland,
  a002.taxk1,
  a002.taxm1,
  cast('' as lland ) as lland,
  a002.datbi,
  a002.datab,
  a002.knumh,
  konp.krech,
  konp.kbetr,
  konp.konwa,
  konp.kpein,
  konp.kmein
} 
 
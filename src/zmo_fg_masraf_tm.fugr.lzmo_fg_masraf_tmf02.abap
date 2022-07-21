*----------------------------------------------------------------------*
***INCLUDE LZMO_FG_MASRAF_TMF02.
*----------------------------------------------------------------------*
FORM hesapla.
  DATA gv_total TYPE int4.
  gv_total = zvkt_mo_t0017-zmasraf_1 + zvkt_mo_t0017-zmasraf_2 + zvkt_mo_t0017-zmasraf_3.
  zvkt_mo_t0017-ztoplam = gv_total.
ENDFORM.

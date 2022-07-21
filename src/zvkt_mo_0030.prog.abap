*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0030.
FREE MEMORY ID 'LV_VBELN'.
FREE MEMORY ID 'LT_VBELN'.
SUBMIT zvkt_mo_0029 AND RETURN.

DATA:  lv_vbeln TYPE vbap-vbeln.
IMPORT lv_vbeln FROM  MEMORY ID 'LV_VBELN'.
IF lv_vbeln IS NOT INITIAL.
  DATA(rdata_vbeln) = lv_vbeln.
  FREE MEMORY ID 'LV_VBELN'.
ENDIF.

DATA:  lt_vbeln TYPE TABLE OF vbap.
IMPORT lt_vbeln FROM  MEMORY ID 'LT_VBELN'.
IF lt_vbeln IS NOT INITIAL.
  DATA(rtable_vbeln) = lt_vbeln.
  FREE MEMORY ID 'LT_VBELN'.
ENDIF.

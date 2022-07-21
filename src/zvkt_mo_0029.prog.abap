*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0029
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0029.
FREE MEMORY ID 'LV_VBELN'.
FREE MEMORY ID 'LT_VBELN'.

SELECT SINGLE vbeln FROM vbap INTO @DATA(lv_vbeln).
IF lv_vbeln IS NOT INITIAL.
  EXPORT lv_vbeln TO MEMORY ID 'LV_VBELN'.
ENDIF.


SELECT vbeln FROM vbap INTO TABLE @DATA(lt_vbeln).
IF lt_vbeln IS NOT INITIAL.
  EXPORT lt_vbeln TO MEMORY ID 'LT_VBELN'.
ENDIF.

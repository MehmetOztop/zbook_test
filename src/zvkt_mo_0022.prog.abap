*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0022.

DATA : lr_proxy TYPE REF TO zco_zmehmeto_prov_ws,
       input    TYPE zzmehmeto_f0001,
       output   TYPE zpre_add_soap_out.



CREATE OBJECT lr_proxy
  EXPORTING
    logical_port_name = 'ZMEHMETWS2'.

input-iv_vbeln = '111'.
lr_proxy->zmehmeto_f0001(
  EXPORTING
    input              = input
  IMPORTING
    output             = DATA(ls_out)
).
*  CATCH cx_ai_system_fault.    "

DATA(ls_res) = ls_out-es_detail.
DATA ls_fin TYPE vbak.
DATA lt_fin TYPE TABLE OF vbak.
MOVE-CORRESPONDING ls_res TO ls_fin.
APPEND ls_fin TO lt_fin.

*cl_salv_table=>factory(
**  EXPORTING
**    list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
**    r_container    =     " Abstract Container for GUI Controls
**    container_name =
*  IMPORTING
*    r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
*  CHANGING
*    t_table        = lt_fin
*).
*
*lo_alv->display( ).

cl_demo_output=>display_data(
  EXPORTING
    value = lt_fin
*    name  =     " Name
).

WRITE: sy-uname.

*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0021
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0021.

INCLUDE zvkt_mo_0021_cls.

START-OF-SELECTION.
  DATA(gv_text) = 'X O X O'.
  DATA(gv_num) = 777.
  DATA go_test TYPE REF TO lcl_test.

  go_test = NEW lcl_test( ).
  go_test->calc(
    EXPORTING
      iv_num1 = 5
      iv_num2 = 10
    IMPORTING
      ev_sum  = DATA(sum)
  ).

  SELECT vbeln, posnr FROM vbap INTO TABLE @DATA(lt_vbap).
  LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
    <lfs_vbap>-vbeln = 77.
  ENDLOOP.
  READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap2>) WITH KEY vbeln = 77.
  <lfs_vbap2>-vbeln = 33.

  DATA(wa) = lt_vbap[ 3 ].
  BREAK egt_mehmeto.

  WRITE gv_text.
  WRITE gv_num.
  WRITE sum.

  DATA(temp) = 3.
  DATA(new) = CONV string( temp ) .

  cl_salv_table=>factory(
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*    r_container    =     " Abstract Container for GUI Controls
*    container_name =
    IMPORTING
      r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
    CHANGING
      t_table        = lt_vbap
  ).

  lo_alv->display( ).

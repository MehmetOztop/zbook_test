*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0026
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0026.
INCLUDE: zvkt_mo_0026_top,
         zvkt_mo_0026_cls,
         zvkt_mo_0026_mdl.

START-OF-SELECTION.

  IF p_month IS NOT INITIAL.

    go_tarih = NEW lcl_tarih( ).
    go_tarih->find_month( ).
    go_tarih->get_day( ).
    go_tarih->build_alv( ).
    go_tarih->display( ).
    WRITE: p_month.

  ELSE.
    MESSAGE s004(zzy_0001) DISPLAY LIKE 'E'.
  ENDIF.

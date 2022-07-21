*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0027
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0027.

INCLUDE: zvkt_mo_0027_top,
         zvkt_mo_0027_cls,
         zvkt_mo_0027_mdl.
go_six = NEW lcl_six( ).


START-OF-SELECTION.
  IF rb_loto EQ 'X'.
    CALL SCREEN 0100.
  ELSEIF rb_satin EQ 'X'.
    go_six->buy_ticket( ).

  ELSEIF rb_bilet EQ 'X'.
    go_six->display_ticket( ).
  ELSEIF rb_cek EQ 'X'.
    go_six->generate_lottery( ).
  ENDIF.

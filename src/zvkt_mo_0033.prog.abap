*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0033
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0033.

INCLUDE: zvkt_mo_0033_top,
         zvkt_mo_0033_cls.

START-OF-SELECTION.

  go_urun = NEW lcl_urun( ).
  go_urun->get_data( ).
  go_urun->set_fcat( ).
  go_urun->set_layout( ).
  go_urun->build_alv( ).
  go_urun->display( ).

  IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
    CALL SCREEN 0001.
  ENDIF.

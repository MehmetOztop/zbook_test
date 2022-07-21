*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0006.


INCLUDE: zvkt_mo_0006_top,
         zvkt_mo_0006_cls,
         zvkt_mo_0006_pbo,
         zvkt_mo_0006_pai.


START-OF-SELECTION.
  CREATE OBJECT go_oo_alv.
  go_oo_alv = NEW lcl_ooalv( ).

  go_oo_alv->get_data( ).
  go_oo_alv->set_layout( ).
  go_oo_alv->set_fcat( ).

  CASE 'X'.
    WHEN p_full.
      go_oo_alv->display_alv_full( ).
    WHEN p_cont.
      go_oo_alv->display_alv_cont( ).
    WHEN OTHERS.
  ENDCASE.

  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0004.

INCLUDE: zvkt_mo_0004_top,
         zvkt_mo_0004_cls,
         zvkt_mo_0004_pbo,
         zvkt_mo_0004_pai.



START-OF-SELECTION.
  CREATE OBJECT go_oo_alv.
  go_oo_alv = NEW lcl_alv( ).

  go_oo_alv->get_data( ).
  go_oo_alv->set_layout( ).
  go_oo_alv->set_fcat( ).

  CASE 'X'.
    WHEN p_full.
      go_oo_alv->display_alv_full( ).
    WHEN p_cont.
      go_oo_alv->display_alv_cont( ).
        WHEN p_evnt.
      go_oo_alv->display_alv_event( ).
    WHEN OTHERS.
  ENDCASE.

  CALL SCREEN 0100.

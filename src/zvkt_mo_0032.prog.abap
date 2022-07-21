*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0032
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0032.
INCLUDE: zvkt_mo_0032_top,
         zvkt_mo_0032_mdl,
         zvkt_mo_0032_cls.

START-OF-SELECTION.

  go_demir = NEW lcl_demir( ).
  go_demir->get_data( ).
  go_demir->display_alv( ).

  CALL SCREEN 0100.

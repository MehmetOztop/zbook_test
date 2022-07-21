*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0031
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0031.

INCLUDE: zvkt_mo_0031_top,
         zvkt_mo_0031_mdl,
         zvkt_mo_0031_cls.

START-OF-SELECTION.


  go_il = NEW lcl_il( ).
  go_il->get_data( ).
  go_il->set_fcat( ).
  go_il->build_alv( ).
  go_il->display( ).
  IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
    CALL SCREEN 0001.
  ENDIF.

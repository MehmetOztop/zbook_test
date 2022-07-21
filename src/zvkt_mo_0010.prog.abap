*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0010.

INCLUDE: zvkt_mo_0010_top,
         zvkt_mo_0010_frm,
         zvkt_mo_0010_pbo,
         zvkt_mo_0010_pai.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

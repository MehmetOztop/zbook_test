*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0009.

INCLUDE: zvkt_mo_0009_top,
        zvkt_mo_0009_cls,
        zvkt_mo_0009_pbo,
        zvkt_mo_0009_pai,
        zvkt_mo_0009_frm.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_fcat.
  PERFORM set_layout.

  CALL SCREEN 0100.

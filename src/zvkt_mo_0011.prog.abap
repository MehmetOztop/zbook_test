*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0011.

INCLUDE zvkt_mo_0011_top.
INCLUDE zvkt_mo_0011_frm.

INITIALIZATION.
  PERFORM add_button.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_fieldcat.
  PERFORM set_layout.

  PERFORM display_alv.

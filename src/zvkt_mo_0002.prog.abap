*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0002.

INCLUDE: zvkt_mo_0002_top,
         zvkt_mo_0002_frm.


START-OF-SELECTION.

PERFORM get_data.
PERFORM set_fcat.
"PERFORM set_layout.
PERFORM display_alv.

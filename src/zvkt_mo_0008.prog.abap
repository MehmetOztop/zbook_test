*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0008.

INCLUDE: zvkt_mo_0008_top,
         zvkt_mo_0008_cls,
         zvkt_mo_0008_pbo,
         zvkt_mo_0008_pai,
         zvkt_mo_0008_frm.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM display_alv.

  CALL SCREEN '0100'.

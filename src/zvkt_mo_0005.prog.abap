*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0005.

INCLUDE: zvkt_mo_0005_top,
         zvkt_mo_0005_cls.

START-OF-SELECTION.

  DATA: go_alv TYPE REF TO lcl_salv.
  CREATE OBJECT go_alv.

  CALL METHOD go_alv->get_data( ).
  CALL METHOD go_alv->display_salv( ).

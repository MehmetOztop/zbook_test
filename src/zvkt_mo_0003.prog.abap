*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0003.

INCLUDE : zvkt_mo_0003_top,
          zvkt_mo_0003_cls.

START-OF-SELECTION.

  DATA: go_alv TYPE REF TO lcl_salv.
  CREATE OBJECT go_alv.

  CALL METHOD go_alv->get_data( ).
  CALL METHOD go_alv->display_salv( ).

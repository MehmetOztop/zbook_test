*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0014.

INCLUDE: zvkt_mo_0014_top,
         zvkt_mo_0014_cls,
         zvkt_mo_0014_frm,
         zvkt_mo_0014_pbo,
         zvkt_mo_0014_pai.

INITIALIZATION.
  go_oo_alv =  NEW lcl_alv( ).
  go_oo_alv->add_button( ).

START-OF-SELECTION.



  go_oo_alv->start_of_selection( ).

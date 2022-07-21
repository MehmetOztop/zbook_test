*&---------------------------------------------------------------------*
*& Report zvkt_mo_0020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0020.

START-OF-SELECTION.

  SELECT *
  FROM zem_cds23( p_islem = '+',
                  p_sayi = 10 )
  INTO TABLE @DATA(lt_cds6).

  cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
                          CHANGING t_table       = lt_cds6 ).

  lo_alv->display( ).

*&---------------------------------------------------------------------*
*& Report zvkt_mo_0019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0019.
START-OF-selection.

select *
from zmehmet_cds001
into table @data(lt_cds20).

cl_salv_table=>factory(  importing r_salv_table = data(lo_alv)
                         changing  t_table = lt_cds20 ).

lo_alv->display(  ).

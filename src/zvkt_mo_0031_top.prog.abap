*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0031_TOP
*&---------------------------------------------------------------------*
CLASS lcl_il DEFINITION DEFERRED.
DATA: go_il TYPE REF TO lcl_il.
DATA: gt_il   TYPE TABLE OF zvkt_mo_t0013,
      gt_ilce TYPE TABLE OF zvkt_mo_t0014,
      gt_pair TYPE TABLE OF zvkt_mo_t0015,
      gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

DATA: go_table TYPE REF TO data,
      gs_table TYPE REF TO data.

DATA: go_grid   TYPE REF TO cl_gui_alv_grid,
      gs_layout TYPE lvc_s_layo.


FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>.
SELECTION-SCREEN BEGIN OF SCREEN 1.
SELECTION-SCREEN END OF SCREEN 1.

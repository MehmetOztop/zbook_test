*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0026_TOP
*&---------------------------------------------------------------------*
CLASS lcl_tarih DEFINITION DEFERRED.
DATA: go_tarih TYPE REF TO lcl_tarih.
DATA: gt_table TYPE REF TO data,
      gs_table TYPE REF TO data,
      gt_fcat  TYPE lvc_t_fcat,
      gs_fcat  TYPE lvc_s_fcat.
DATA: go_grid   TYPE REF TO cl_gui_alv_grid,
      gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS    :  p_month  TYPE  /bi0/oicalmonth.
SELECTION-SCREEN END OF BLOCK b1.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0033_TOP
*&---------------------------------------------------------------------*
CLASS lcl_urun DEFINITION DEFERRED.
TYPES: BEGIN OF gty_adet,
         malz_no TYPE matnr,
         adet    TYPE int4,
       END OF gty_adet.

DATA: go_urun   TYPE REF TO lcl_urun,
      go_grid   TYPE REF TO cl_gui_alv_grid,
      gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   TYPE lvc_s_fcat,
      gs_layout TYPE lvc_s_layo.
DATA: go_table TYPE REF TO data,
      gs_table TYPE REF TO data.
FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>.

SELECTION-SCREEN BEGIN OF SCREEN 1.
SELECTION-SCREEN END OF SCREEN 1.

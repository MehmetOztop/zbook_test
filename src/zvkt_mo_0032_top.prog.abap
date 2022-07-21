*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0032_TOP
*&---------------------------------------------------------------------*
CLASS lcl_demir DEFINITION DEFERRED.
DATA: go_demir TYPE REF TO lcl_demir.
DATA: gt_demir TYPE TABLE OF zvkt_mo_t0016.
DATA: gt_stok TYPE TABLE OF zvkt_mo_t0016.

DATA: go_alv          TYPE REF TO cl_gui_alv_grid,
      go_alv2         TYPE REF TO cl_gui_alv_grid,
      go_cont         TYPE REF TO cl_gui_custom_container,
      go_split        TYPE REF TO cl_gui_splitter_container,
      go_sub1         TYPE REF TO cl_gui_container,
      go_sub2         TYPE REF TO cl_gui_container,
      gs_fieldcatalog TYPE lvc_s_fcat,
      gt_fieldcatalog TYPE lvc_t_fcat,
      gv_flag         TYPE char1,
      gs_layout       TYPE lvc_s_layo.

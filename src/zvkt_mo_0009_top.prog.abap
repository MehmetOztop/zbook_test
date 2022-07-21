*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0009_TOP
*&---------------------------------------------------------------------*

DATA: gt_table TYPE TABLE OF scarr.

DATA: go_grid TYPE REF TO cl_gui_alv_grid,
      go_cust TYPE REF TO cl_gui_custom_container.

DATA:gt_fcat   TYPE lvc_t_fcat,
     gs_fcat   TYPE lvc_s_fcat,
     gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS: <gfs_fcat> TYPE lvc_s_fcat.

CLASS cl_event_receiver DEFINITION DEFERRED.

DATA: go_event_receiver TYPE REF TO cl_event_receiver.

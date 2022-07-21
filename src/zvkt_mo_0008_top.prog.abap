*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0008_TOP
*&---------------------------------------------------------------------*
DATA: gt_table TYPE TABLE OF sbook,
      go_alv   TYPE REF TO cl_gui_alv_grid,
      go_cont  TYPE REF TO cl_gui_custom_container.

DATA: go_split TYPE REF TO cl_gui_splitter_container,
      go_sub1  TYPE REF TO cl_gui_container,
      go_sub2  TYPE REF TO cl_gui_container.

DATA: go_docu TYPE REF TO cl_dd_document.

CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: go_event_receiver TYPE REF TO lcl_event_receiver.

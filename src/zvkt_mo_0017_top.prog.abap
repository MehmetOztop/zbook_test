*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0017_TOP
*&---------------------------------------------------------------------*
CLASS lcl_report DEFINITION DEFERRED.
TABLES: vbak.

DATA: go_report   TYPE REF TO lcl_report,
      gv_tabname  TYPE tabname,
      gt_output   TYPE TABLE OF zvkt_mo_s0002,
      gs_output   LIKE LINE  OF gt_output,
      gt_pop_data TYPE TABLE OF zvkt_mo_s0003,
      gt_return   TYPE bapirettab,
      gs_return   TYPE bapiret2,
      gv_error    TYPE char1,
      gt_not      TYPE TABLE OF zvkt_mo_t0002,
      gs_not      TYPE zvkt_mo_t0002,
      gs_header   TYPE zvkt_mo_s0002,
      gt_items    TYPE TABLE OF zvkt_mo_s0003.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.


CONSTANTS: gc_output TYPE tabname VALUE 'VBAK'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.

SELECTION-SCREEN END OF BLOCK b1.

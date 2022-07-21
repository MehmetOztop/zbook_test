*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_ooalv DEFINITION DEFERRED.

DATA:
      gv_tabname    TYPE tabname.

gv_tabname = 'SBOOK'.

TABLES: sbook.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_date TYPE sbook-fldate.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_full RADIOBUTTON GROUP rb1 DEFAULT 'X'.
PARAMETERS: p_cont RADIOBUTTON GROUP rb1 .
SELECTION-SCREEN: END OF BLOCK b2.

DATA: go_oo_alv TYPE REF TO lcl_ooalv.

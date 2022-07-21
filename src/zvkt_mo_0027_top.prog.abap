*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0027_TOP
*&---------------------------------------------------------------------*
TABLES: zvkt_mo_t0011, zvkt_mo_t0009..
CLASS lcl_six DEFINITION DEFERRED.
DATA: go_six       TYPE REF TO lcl_six,
      gv_bilet_mod TYPE char5.

DATA: gv_account TYPE int4,
      gv_add     TYPE int4.
gv_account = 500.
DATA: gt_number TYPE TABLE OF zvkt_mo_t0009,
      gs_number TYPE zvkt_mo_t0009.
DATA: gt_number2 TYPE TABLE OF zvkt_mo_t0009,
      gs_number2 TYPE zvkt_mo_t0009.
DATA: gv_cnum TYPE numeric16,
      gv_ccv  TYPE numeric3.


TYPES BEGIN OF gty_input.

TYPES num1 TYPE int4.
TYPES num2 TYPE int4.
TYPES num3 TYPE int4.
TYPES num4 TYPE int4.
TYPES num5 TYPE int4.
TYPES num6 TYPE int4.

TYPES END OF gty_input.

DATA: gs_input  TYPE gty_input,
      gs_output TYPE gty_input,
      gt_input  TYPE TABLE OF gty_input.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: rb_loto  RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND u1,
            rb_satin RADIOBUTTON GROUP rg1,
            rb_cek   RADIOBUTTON GROUP rg1,
            rb_bilet RADIOBUTTON GROUP rg1.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_amount TYPE int4 MODIF ID sid,
            p_date   TYPE datum MODIF ID hid,
            p_type   AS LISTBOX VISIBLE LENGTH 10 TYPE zvkt_mo_t0011-tur MODIF ID sid.


SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.

SELECT-OPTIONS: s_date FOR zvkt_mo_t0011-tarih MODIF ID bid.
SELECTION-SCREEN END OF BLOCK b3.

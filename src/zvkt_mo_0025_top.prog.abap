*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0025_TOP
*&---------------------------------------------------------------------*
CLASS lcl_personel DEFINITION DEFERRED.
TABLES: zvkt_mo_t0006, zvkt_mo_t0007, zvkt_mo_t0008 ,sscrfields.
DATA go_personel   TYPE REF TO lcl_personel.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS: rb_yeni  RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND u1,
            rb_liste RADIOBUTTON GROUP rg1.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

SELECT-OPTIONS: s_ad FOR zvkt_mo_t0006-ad MODIF ID lid,
                s_soyad FOR zvkt_mo_t0006-soyad MODIF ID lid,
                s_dept FOR zvkt_mo_t0007-ad MODIF ID lid,
                s_title FOR zvkt_mo_t0008-ad MODIF ID lid.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN:
  PUSHBUTTON /2(20) button1 USER-COMMAND but1.

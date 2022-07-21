*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0016_TOP
*&---------------------------------------------------------------------*

CONSTANTS:
  gc_subject TYPE so_obj_des VALUE 'ABAP Email with CL_BCS',
  gc_raw     TYPE char03 VALUE 'RAW'.

DATA:
  gv_mlrec         TYPE so_obj_nam,
  gv_sent_to_all   TYPE os_boolean,
  gv_email         TYPE adr6-smtp_addr,
  gv_subject       TYPE so_obj_des,
  gv_text          TYPE bcsy_text,
  gr_send_request  TYPE REF TO cl_bcs,
  gr_bcs_exception TYPE REF TO cx_bcs,
  gr_recipient     TYPE REF TO if_recipient_bcs,
  gr_sender        TYPE REF TO adr6-smtp_addr,
  gr_document      TYPE REF TO cl_document_bcs,
  sender        TYPE REF TO if_sender_bcs.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Seçim Ekranı
PARAMETERS: p_sub       TYPE so_obj_des,
            p_body(255) TYPE c,
            p_send      TYPE ad_smtpadr,
            p_rec       TYPE ad_smtpadr.
SELECTION-SCREEN END OF BLOCK b1.

*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0012.

DATA: lt_table TYPE TABLE OF zem_tbl01,
      ls_table TYPE zem_tbl01.

START-OF-SELECTION.
  SELECT * FROM zem_tbl01
    INTO TABLE @lt_table.

  CALL FUNCTION 'ZEM_OLE_EXCEL_DOWNLOAD'
    EXPORTING
      iv_subject = 'Sayfa'
      it_data    = lt_table.
*     IT_TITLE   =
*     IT_COMPONENTS       =
  .

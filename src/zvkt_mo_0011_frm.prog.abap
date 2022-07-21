*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0011_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
*  gs_list-ogrenci_no = '1234567'.
*  gs_list-ogrenci_adi = 'Ahmet'.
*  gs_list-ogrenci_no = 'Yıldırım'.
*  APPEND gs_list TO gt_list.

  DATA: lt_raw TYPE truxs_t_text_data.


  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = abap_true
      i_tab_raw_data       = lt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_list
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
*  IF sy-subrc <> 0.
* MESSAGE text-0001 type 'I'.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fieldcat .
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZEM_STR02'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = gt_list
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_BUTTON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_button .
  gs_sel_button-icon_id = icon_xls.
  gs_sel_button-icon_text = 'Şablon'.
  gs_sel_button-quickinfo = 'Şablonu İndir'.
  sscrfields-functxt_01 = gs_sel_button.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_TEMP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*&---------------------------------------------------------------------*
FORM download_temp  USING  pv_object TYPE w3objid.
  DATA: ls_return TYPE bapiret2.
  CALL FUNCTION 'Z_EXPORT_TEMPLATE'
    EXPORTING
      iv_object_name = pv_object
    IMPORTING
      es_return      = ls_return.

  IF ls_return-type = 'E'.
    MESSAGE ID ls_return-id TYPE 'I' NUMBER ls_return-number.
  ENDIF.
ENDFORM.

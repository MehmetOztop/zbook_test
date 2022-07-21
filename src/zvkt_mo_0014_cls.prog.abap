*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0014_CLS
*&---------------------------------------------------------------------*
CLASS lcl_alv DEFINITION.

  PUBLIC SECTION.

    DATA: lt_exclude TYPE ui_functions,
          ls_stable  TYPE lvc_s_stbl.

    DATA : gv_kontab  TYPE tabname.

    DATA: gt_dyn   TYPE REF TO data,
          gt_dntab TYPE TABLE OF dntab.


    METHODS: get_data,
      set_fcat,
      set_layout,
      display_alv,
      add_button,
      download_excel_template,
      get_report,
      start_of_selection,
      refresh_alv CHANGING cs_alv TYPE REF TO cl_gui_alv_grid,
      clear_all,
      exclude  IMPORTING iv_statu   TYPE char1
               EXPORTING et_exclude TYPE ui_functions.

ENDCLASS.

CLASS lcl_alv IMPLEMENTATION.

  METHOD get_data.
*    SELECT * FROM zvkt_mo_t0001
*      INTO TABLE @gt_table.

    DATA: lt_raw TYPE truxs_t_text_data.


    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_table
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    " BREAK egt_mehmeto.

  ENDMETHOD.

  METHOD set_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZVKT_MO_T0001'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.

  METHOD set_layout.

    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.

  ENDMETHOD.

  METHOD display_alv.

    IF go_alv IS INITIAL.

      me->set_fcat( ).
      me->set_layout( ).
      me->exclude(      EXPORTING iv_statu       = abap_false
                        IMPORTING et_exclude     = lt_exclude ).
      CREATE OBJECT go_cont
        EXPORTING
          container_name = 'CC_CONT'.

      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_cont.   " Parent Container

      CALL METHOD go_alv->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout  " Layout
        CHANGING
          it_outtab       = gt_table  " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog
    ELSE.
      me->refresh_alv( CHANGING  cs_alv = go_alv ).
    ENDIF.


  ENDMETHOD.

  METHOD get_report.
    me->get_data( ).
    IF gt_table IS NOT INITIAL.
      CALL SCREEN 0100.
    ELSE.
      MESSAGE s001(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDMETHOD.

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD.

  METHOD clear_all.
    CLEAR:  gs_table.

    REFRESH:  gt_table.
  ENDMETHOD."clear_all

  METHOD exclude.
    REFRESH: et_exclude.

    IF iv_statu IS INITIAL.
      APPEND: cl_gui_alv_grid=>mc_fc_loc_insert_row         TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_delete_row         TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_move_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_move_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_cut                TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_copy_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_copy               TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_paste              TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_paste_new_row      TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_undo               TO et_exclude.
    ENDIF.
    APPEND: cl_gui_alv_grid=>mc_fc_loc_append_row           TO et_exclude,
            cl_gui_alv_grid=>mc_fc_views                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_crystal             TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_excel               TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_grid                TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_lotus               TO et_exclude,
            cl_gui_alv_grid=>mc_fc_col_invisible            TO et_exclude,
            cl_gui_alv_grid=>mc_fc_print                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_graph                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_info                     TO et_exclude.
  ENDMETHOD. "exclude

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alv->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD.

  METHOD add_button.
    gs_sel_button-icon_id = icon_xls.
    gs_sel_button-icon_text = 'Şablon'.
    gs_sel_button-quickinfo = 'Şablonu İndir'.
    sscrfields-functxt_01 = gs_sel_button.
  ENDMETHOD.

  METHOD download_excel_template.
    gv_kontab = 'ZVKT_MO_T0001'.
    DATA: lo_application TYPE ole2_object,
          lo_workbook    TYPE ole2_object,
          lo_workbooks   TYPE ole2_object,
          lo_range       TYPE ole2_object,
          lo_worksheet   TYPE ole2_object,
          lo_worksheets  TYPE ole2_object,
          lo_column      TYPE ole2_object,
          lo_row         TYPE ole2_object,
          lo_cell        TYPE ole2_object,
          lo_font        TYPE ole2_object,
          lo_cellstart   TYPE ole2_object,
          lo_cellend     TYPE ole2_object,
          lo_selection   TYPE ole2_object,
          lo_validation  TYPE ole2_object.

    DATA: lv_selected_folder TYPE string,
          lv_complete_path   TYPE char256,
          lv_titulo          TYPE string.

    TYPES: BEGIN OF lty_exc_title,
             string(100) TYPE c,
           END OF lty_exc_title.

    DATA: ls_exc_title TYPE lty_exc_title,
          lt_exc_title TYPE TABLE OF lty_exc_title.

    TYPES: BEGIN OF lty_column,
             column TYPE char2,
           END OF lty_column,
           ltt_column TYPE TABLE OF lty_column.

    DATA: lt_column TYPE ltt_column,
          ls_column TYPE lty_column.

    lt_column = VALUE #(  ( column = 'A' )
                          ( column = 'B' )
                          ( column = 'C' )
                          ( column = 'D' )
                          ( column = 'E' )
                          ( column = 'F' )
                          ( column = 'G' )
                          ( column = 'H' )
                          ( column = 'I' )
                          ( column = 'J' )
                          ( column = 'K' )
                          ( column = 'L' )
                          ( column = 'M' )
                          ( column = 'N' )
                          ( column = 'O' )
                          ( column = 'P' )
                          ( column = 'Q' )
                          ( column = 'R' )
                          ( column = 'S' )
                          ( column = 'T' )
                          ( column = 'U' )
                          ( column = 'W' )
                          ( column = 'X' )
                          ( column = 'Y' )
                          ( column = 'Z' )
                          ( column = 'AA' )
                          ( column = 'AB' )
                          ( column = 'AC' )
                          ( column = 'AD' )
                          ( column = 'AE' )
                          ( column = 'AF' )
                          ( column = 'AG' )
                          ( column = 'AH' )
                          ( column = 'AI' )
                          ( column = 'AJ' )
                          ( column = 'AK' )
                          ( column = 'AL' )
                          ( column = 'AM' )
                          ( column = 'AN' )
                          ( column = 'AO' )
                          ( column = 'AP' )
                          ( column = 'AQ' )
                          ( column = 'AR' )
                          ( column = 'AS' )
                          ( column = 'AT' )
                          ( column = 'AU' )
                          ( column = 'AW' )
                          ( column = 'AX' )
                          ( column = 'AY' )
                          ( column = 'AZ' ) ).

    CALL METHOD cl_gui_frontend_services=>directory_browse
      EXPORTING
        window_title    = lv_titulo
        initial_folder  = 'C:\'
      CHANGING
        selected_folder = lv_selected_folder
      EXCEPTIONS
        cntl_error      = 1
        error_no_gui    = 2
        OTHERS          = 3.
    CHECK NOT lv_selected_folder IS INITIAL.

    CREATE OBJECT lo_application 'EXCEL.application'.
    CALL METHOD OF lo_application
        'WORKBOOKS' = lo_workbooks.
    CALL METHOD OF lo_workbooks
        'ADD' = lo_workbook.
    SET PROPERTY OF lo_application 'VISIBLE' = 0.
    GET PROPERTY OF lo_application 'ACTIVESHEET' = lo_worksheet.


    CALL FUNCTION 'NAMETAB_GET'
      EXPORTING
*       LANGU               = SY-LANGU
*       ONLY                = ' '
        tabname             = gv_kontab
*    IMPORTING
*       header              = ls_header
*       RC                  =
      TABLES
        nametab             = gt_dntab
      EXCEPTIONS
        internal_error      = 1
        table_has_no_fields = 2
        table_not_activ     = 3
        no_texts_found      = 4
        OTHERS              = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
*
    LOOP AT gt_dntab INTO DATA(ls_dntab).
      CLEAR: ls_exc_title.
*      IF NOT ( ls_dntab-fieldname EQ 'MANDT' OR ls_dntab-fieldname EQ 'KAPPL' OR ls_dntab-fieldname EQ 'KSCHL' ).
      ls_exc_title-string = ls_dntab-fieldtext.
      APPEND ls_exc_title TO lt_exc_title.
*      ENDIF.
    ENDLOOP.

    LOOP AT lt_exc_title INTO ls_exc_title.
      READ TABLE lt_column INTO ls_column INDEX sy-tabix.
      CALL METHOD OF lo_worksheet
        'Cells'      = lo_cell
      EXPORTING
        #1           = 1    "ROW
        #2           = ls_column-column. " 'A'. "COL
      SET PROPERTY OF lo_cell 'Value' = ls_exc_title-string.
    ENDLOOP.


    CONCATENATE lv_selected_folder '\Uçuş_' sy-datum '_' sy-timlo INTO lv_complete_path.

    CALL METHOD OF lo_workbook 'SaveAs'
      EXPORTING
        #1 = lv_complete_path.
    IF sy-subrc EQ 0.
      MESSAGE 'Dosya kaydedildi!' TYPE 'S'.
    ELSE.
      MESSAGE 'Dosya kaydedilemedi!' TYPE 'E'.
    ENDIF.

    CALL METHOD OF lo_application 'QUIT'.
    FREE OBJECT lo_worksheet.
    FREE OBJECT lo_workbook.
    FREE OBJECT lo_application.



  ENDMETHOD.

ENDCLASS.

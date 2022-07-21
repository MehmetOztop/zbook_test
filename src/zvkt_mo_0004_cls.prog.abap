*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0004_CLS
*&---------------------------------------------------------------------*

CLASS lcl_alv DEFINITION.
  PUBLIC SECTION.
    DATA: gt_org TYPE TABLE OF mara,
          gs_org TYPE mara.


    TYPES: BEGIN OF gty_mara,
             matnr TYPE matnr,
             ernam TYPE ernam,
             laeda TYPE laeda,
             matkl TYPE matkl,
             ntgew TYPE ntgew,
             gewei TYPE gewei,
           END OF gty_mara.

    DATA: gs_mara TYPE gty_mara,
          gt_mara TYPE TABLE OF gty_mara.

    DATA:gt_fcat   TYPE lvc_t_fcat,
         gs_fcat   TYPE lvc_s_fcat,
         gs_layout TYPE lvc_s_layo.

    DATA: go_alv TYPE REF TO cl_gui_alv_grid.
    DATA: go_cont TYPE REF TO cl_gui_custom_container.

    DATA: go_split    TYPE REF TO cl_gui_splitter_container,
          go_subcont1 TYPE REF TO cl_gui_container,
          go_subcont2 TYPE REF TO cl_gui_container,
          go_doc      TYPE REF TO cl_dd_document.

    METHODS: get_data,
      set_fcat,
      set_layout,
      display_alv_full,
      display_alv_cont,
      display_alv_event,
      delete_data.

    METHODS: handle_hotspot_click FOR EVENT hotspot_click
    OF cl_gui_alv_grid IMPORTING e_column_id
                                 e_row_id
                                 es_row_no,

    handle_data_changed FOR EVENT data_changed
    OF cl_gui_alv_grid IMPORTING er_data_changed,

    handle_toolbar FOR EVENT toolbar
    OF cl_gui_alv_grid IMPORTING e_interactive
                                 e_object,

    handle_user_command FOR EVENT user_command
    OF cl_gui_alv_grid IMPORTING e_ucomm .




ENDCLASS.

CLASS lcl_alv IMPLEMENTATION.

  METHOD get_data.
    SELECT matnr,
      ernam,
      laeda,
      matkl,
      ntgew,
      gewei
      FROM mara
      INTO TABLE @gt_mara
      ORDER BY matnr.

    "    SELECT * FROM mara INTO TABLE @gt_org.

  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZVKT_MO_S2'
      CHANGING
        ct_fieldcat      = gt_fcat.

    LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      CASE <lfs_fcat>-fieldname.
        WHEN 'MATNR'.
          <lfs_fcat>-hotspot = abap_true.
        WHEN 'MATKL'.
          <lfs_fcat>-edit = abap_true.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD set_layout.

    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.


  ENDMETHOD.

  METHOD display_alv_full.
*    CREATE OBJECT go_alv.

    go_alv = NEW cl_gui_alv_grid(

        i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout    " Layout
      CHANGING
        it_outtab       = gt_mara  " Output Table
        it_fieldcatalog = gt_fcat.  " Field Catalog
*    it_sort                       =     " Sort Criteria
*    it_filter                     =     " Filter Criteria
*  EXCEPTIONS
*    invalid_parameter_combination = 1
*    program_error                 = 2
*    too_many_lines                = 3
*    others                        = 4
    .
    IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD display_alv_cont.
    CREATE OBJECT go_cont
      EXPORTING
*       parent         =     " Parent container
        container_name = 'CC_CONTAINER'.    " Name of the Screen CustCtrl Name to Link Container To
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cont.  " Parent Container

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout    " Layout
      CHANGING
        it_outtab       = gt_mara  " Output Table
        it_fieldcatalog = gt_fcat.  " Field Catalog

    IF sy-subrc <> 0.

    ENDIF.

  ENDMETHOD.

  METHOD display_alv_event.

    DATA: lv_text   TYPE sdydo_text_element,
          lv_backgr TYPE sdydo_key VALUE 'ALV_BACKGROUND'.

    IF go_alv IS INITIAL.

      CREATE OBJECT go_cont
        EXPORTING
*         parent         =     " Parent container
          container_name = 'CC_CONTAINER'.   " Name of the Screen CustCtrl Name to Link Container To

      CREATE OBJECT go_split
        EXPORTING
          parent  = go_cont   " Parent Container
          rows    = 2   " Number of Rows to be displayed
          columns = 1.   " Number of Columns to be Displayed

      go_split->get_container(
        EXPORTING
          row       =  1   " Row
          column    =  1   " Column
        RECEIVING
          container =  go_subcont1   " Container
      ).


      go_split->get_container(
           EXPORTING
             row       =  2   " Row
             column    =  1   " Column
           RECEIVING
             container =  go_subcont2   " Container
         ).

      go_split->set_row_height(
        EXPORTING
          id                =  1   " Row ID
          height            =   20 ) .  " Height


      CREATE OBJECT go_doc
        EXPORTING
          style = 'ALV_GRID'.    " Adjusting to the Style of a Particular GUI Environment

      lv_text = 'OO_ALV_EVENTLERİ'.

      go_doc->add_text(
        EXPORTING
          text          = lv_text  " Single Text, Up To 255 Characters Long
          sap_style     = cl_dd_document=>heading    " Recommended Styles
          sap_color     = cl_dd_document=>list_positive_int    " Not Release 99
          sap_fontsize  = cl_dd_document=>list_heading ) .    " Recommended Font Sizes


      go_doc->set_document_background(
          picture_id = lv_backgr
      ).

      go_doc->display_document(
        EXPORTING
          parent   = go_subcont1 ).    " Contain Object Already Exists

      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_subcont2.  " Parent Container

      go_alv->register_edit_event(
        EXPORTING
          i_event_id =  cl_gui_alv_grid=>mc_evt_modified   " Event ID
*        EXCEPTIONS
*          error      = 1
*          others     = 2
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      SET HANDLER me->handle_hotspot_click FOR go_alv.
      SET HANDLER me->handle_data_changed FOR go_alv.
      SET HANDLER me->handle_toolbar FOR go_alv.
      SET HANDLER me->handle_user_command FOR go_alv.

      CALL METHOD go_alv->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout    " Layout
        CHANGING
          it_outtab       = gt_mara  " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ENDIF.

    go_alv->refresh_table_display( ).
  ENDMETHOD.

  METHOD handle_hotspot_click.

    DATA: lv_date TYPE datum.

    READ TABLE gt_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>) INDEX e_row_id-index.

    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
      EXPORTING
        date_internal = <lfs_mara>-laeda
      IMPORTING
        date_external = lv_date.



    DATA(lv_message) = |Bu malzeme | & | | & |{ <lfs_mara>-ernam }| & | | & |tarafından| & | | & |{  lv_date }|
    & | | & | tarihinde oluşturulmuştur. | .

    MESSAGE lv_message TYPE 'I'.

  ENDMETHOD.

  METHOD handle_data_changed.

    DATA: ls_mod_cell TYPE lvc_s_modi,
          ls_zvkt     TYPE zvkt_t0041.

    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cell.
      READ TABLE gt_mara INTO DATA(ls_mara) INDEX ls_mod_cell-row_id.

      ls_zvkt-ernam = ls_mara-ernam .
      ls_zvkt-gewei = ls_mara-gewei .
      ls_zvkt-laeda = ls_mara-laeda .
      ls_zvkt-matkl = ls_mod_cell-value .
      ls_zvkt-matnr = ls_mara-matnr .
      ls_zvkt-ntgew = ls_mara-ntgew .

      MODIFY zvkt_t0041 FROM ls_zvkt .
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.

      ENDIF.

      UPDATE mara SET matkl = ls_mod_cell-value
                        WHERE matnr = ls_mara-matnr.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.

      ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD handle_toolbar.

    DATA: ls_toolbar TYPE stb_button .

    ls_toolbar-function = '&SIL'.
    ls_toolbar-text = 'SİL'.
    ls_toolbar-icon = '@11@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR : ls_toolbar.



  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN '&SIL'.

        me->delete_data( ).

    ENDCASE.

    go_alv->refresh_table_display( ).

  ENDMETHOD.

  METHOD delete_data.
    DATA: lt_rows TYPE lvc_t_row,
          ls_rows TYPE lvc_s_row.

    go_alv->get_selected_rows(
      IMPORTING
        et_index_rows = lt_rows    " Indexes of Selected Rows

    ).

    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_mara INTO DATA(ls_mara) INDEX ls_rows-index.
      DELETE gt_mara INDEX ls_rows-index.


      DELETE FROM mara WHERE matnr = ls_mara-matnr.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.





    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

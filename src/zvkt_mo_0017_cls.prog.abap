*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0017_CLS
*&---------------------------------------------------------------------*
CLASS lcl_report DEFINITION.
  PUBLIC SECTION.
    METHODS:
      screen_output,
      start_of_selection,
      get_data,
      get_pop_data IMPORTING iv_vbeln TYPE vbeln_va
                   EXPORTING et_data  TYPE zvkt_mo_tt0001,
      get_report,
      get_pop_report IMPORTING iv_temp TYPE vbeln_va,
      save_not,
      print_adobe,
      down_excel,
      print_smart,
      send_mail,
      get_selected_rows,
      add_message IMPORTING iv_msg_type TYPE bapi_mtype
                            iv_msg_numb TYPE syst_msgno
                            iv_msg_id   TYPE syst_msgid
                            iv_par1     TYPE syst_msgv
                            iv_par2     TYPE syst_msgv
                            iv_par3     TYPE syst_msgv
                            iv_par4     TYPE syst_msgv
                  CHANGING  ct_return   TYPE bapirettab,
      prepare_alv,
      prepare_pop_alv,
      display_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid
                           cs_layout  TYPE lvc_s_layo
                           cs_variant TYPE disvariant
                           ct_output  TYPE ANY TABLE
                           ct_fielcat TYPE lvc_t_fcat
                           ct_sort    TYPE lvc_t_sort
                           ct_exclude TYPE ui_functions,
      refresh_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid,
      refresh_alv_2.

  PROTECTED SECTION.
    "ALV Tanımlamaları
    DATA: lv_cc            TYPE scrfname VALUE 'CC',
          lo_container     TYPE REF TO cl_gui_custom_container,
          lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
          lo_popup         TYPE REF TO cl_salv_table,
          lt_fc            TYPE lvc_t_fcat,
          ls_layout        TYPE lvc_s_layo,
          ls_variant       TYPE disvariant,
          ls_stable        TYPE lvc_s_stbl,
          lt_exclude       TYPE ui_functions,
          lt_sort          TYPE lvc_t_sort,
          lt_selected_rows TYPE lvc_t_row,
          ls_selected_rows TYPE lvc_s_row,
          lv_lines         TYPE i,
          lv_vbeln         TYPE vbeln_va,
          lt_pop_fc        TYPE slis_t_fieldcat_alv,
          us_pdf_file      TYPE fpformoutput.

  PRIVATE SECTION.
    METHODS:
      handle_data_changed  FOR EVENT data_changed   OF cl_gui_alv_grid IMPORTING er_data_changed,
      handle_hotspot_click FOR EVENT hotspot_click  OF cl_gui_alv_grid IMPORTING e_row_id
                                                                                   e_column_id
                                                                                   es_row_no,
      handle_toolbar       FOR EVENT toolbar        OF cl_gui_alv_grid IMPORTING e_object
                                                                                   e_interactive,
      handle_user_command  FOR EVENT user_command   OF cl_gui_alv_grid IMPORTING e_ucomm,
      clear_all,
      clear_alv,
      create_container    IMPORTING iv_cont_name TYPE scrfname
                          CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                    cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_container2   CHANGING  cs_alv_grid    TYPE REF TO cl_gui_alv_grid,
      create_layout       IMPORTING iv_title  TYPE lvc_title
                          EXPORTING es_layout TYPE lvc_s_layo,
      create_variant      IMPORTING iv_handle  TYPE slis_handl
                          EXPORTING es_variant TYPE disvariant,
      create_fcat         EXPORTING et_fc          TYPE lvc_t_fcat,
      modify_fcat         IMPORTING iv_field TYPE lvc_fname
                                    iv_text  TYPE string
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_edit    IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_no_out  IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_hotspot IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_chkbox  IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_color   IMPORTING iv_field TYPE lvc_fname
                                    iv_color TYPE lvc_emphsz
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      exclude             IMPORTING iv_statu   TYPE char1
                          EXPORTING et_exclude TYPE ui_functions,
      sort_filter         IMPORTING iv_field       TYPE lvc_fname
                                    it_fc          TYPE lvc_t_fcat
                          CHANGING  ct_sort_filter TYPE lvc_t_sort,
      event_receiver      CHANGING cs_alvgird      TYPE REF TO cl_gui_alv_grid,
      get_tabname         IMPORTING iv_tabname     TYPE tabname.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD handle_data_changed.
*    DATA: ls_mod_cell TYPE lvc_s_modi.
*    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cell.
*      READ TABLE gt_output INTO DATA(ls_output) INDEX ls_mod_cell-row_id.
*
*      ls_zvkt- = ls_output-ernam .
*      ls_zvkt-gewei = ls_output-gewei .
*      ls_zvkt-laeda = ls_output-laeda .
*      ls_zvkt-matnr = ls_output-matnr .
*      gs_not-vbeln = ls_output-vbeln .
*      gs_not-znot = ls_mod_cell-value .
*
*
*      APPEND gs_not TO gt_not.
*
*    ENDLOOP.
  ENDMETHOD. "handle_data_changed

  METHOD handle_hotspot_click.
*    DATA: lv_tknum TYPE tknum.
*
*    CLEAR: lv_tknum.
*
*    CASE e_column_id.
*      WHEN 'TKNUM'.
***        READ TABLE gt_output INTO gs_output INDEX e_row_id.
***        IF sy-subrc EQ 0.
***
***        ENDIF.
*        lv_tknum =  VALUE #( gt_output[ e_row_id ]-tknum OPTIONAL ).
*        SET PARAMETER ID: 'TNR' FIELD lv_tknum.
*        CALL TRANSACTION 'VT03N' AND SKIP FIRST SCREEN.
*    ENDCASE.

    READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_out>) INDEX e_row_id-index.

    lv_vbeln = <lfs_out>-vbeln.
    REFRESH:  gt_pop_data.
    CLEAR: lo_popup.
    me->get_pop_report( iv_temp = <lfs_out>-vbeln ).

  ENDMETHOD. "handle_hotspot_click

  METHOD handle_toolbar.
*    DATA: ls_toolbar  TYPE stb_button.
*    CLEAR ls_toolbar.
*
*    IF gv_tabname EQ gc_output.
*      MOVE   3          TO ls_toolbar-butn_type.
*      APPEND ls_toolbar TO e_object->mt_toolbar.
*
*      CLEAR ls_toolbar.
*      MOVE 'INS'            TO ls_toolbar-function.
*      MOVE icon_insert_row  TO ls_toolbar-icon.
*      MOVE TEXT-034         TO ls_toolbar-quickinfo.
*      MOVE TEXT-034         TO ls_toolbar-text.
*      MOVE ' '              TO ls_toolbar-disabled.
*      APPEND ls_toolbar     TO e_object->mt_toolbar.
*
*      CLEAR ls_toolbar.
*      MOVE 'DEL'            TO ls_toolbar-function.
*      MOVE icon_delete_row  TO ls_toolbar-icon.
*      MOVE  TEXT-035        TO ls_toolbar-quickinfo.
*      MOVE  TEXT-035        TO ls_toolbar-text.
*      MOVE ' '              TO ls_toolbar-disabled.
*      APPEND ls_toolbar     TO e_object->mt_toolbar.
*    ENDIF.
  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.
*    WAIT UP TO 1 SECONDS.
*    CASE e_ucomm.
*      WHEN 'INS'.
*        "Sat#r Ekle
*        me->add_order_get_data( ).
*      WHEN 'DEL'.
*        "Sat#r Sil
*        CLEAR:  lt_selected_rows,
*                ls_selected_rows,
*                lv_lines.
*
*        CALL METHOD lo_alvgrid->get_selected_rows
*          IMPORTING
*            et_index_rows = lt_selected_rows.
*
*        lv_lines = lines( lt_selected_rows ).
*        IF lv_lines EQ 0.
*          MESSAGE e010(zsd_order).
*        ENDIF.
*
*        LOOP AT lt_selected_rows INTO ls_selected_rows.
*          DELETE gt_output INDEX ls_selected_rows-index.
*        ENDLOOP.
*        me->refresh_alv_2( ).
*    ENDCASE.
  ENDMETHOD. "handle_user_command
  METHOD screen_output.
*    LOOP AT SCREEN.
*      IF p_r01 EQ abap_true.
*        CASE screen-group1.
*          WHEN 'M' OR 'M1'.
*            screen-active = 1.
*          WHEN 'M2'.
*            screen-active = 0.
*        ENDCASE.
*      ELSEIF p_r02 EQ abap_true.
*        CASE screen-group1.
*          WHEN 'M' OR 'M2'.
*            screen-active = 1.
*          WHEN 'M1'.
*            screen-active = 0.
*        ENDCASE.
*      ENDIF.
*      MODIFY SCREEN.
*    ENDLOOP.
  ENDMETHOD. "screen_output

  METHOD clear_all.
    CLEAR:    gv_tabname,
              gv_error,
              gs_return,
              gs_output.

    REFRESH:  gt_output,
              gt_return.
  ENDMETHOD."clear_all

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD. "start_of_selection

  METHOD get_data.
    me->clear_all( ).

    SELECT a~mandt,
           a~vbeln,
           erdat,
           ernam,
           auart,
           vkorg,
           vtweg,
           spart,
           netwr,
           waerk,
           znot
        INTO TABLE @gt_output
        FROM vbak AS a
        LEFT OUTER JOIN zvkt_mo_t0002 AS b
        ON a~vbeln EQ b~vbeln
        WHERE a~vbeln IN @s_vbeln.

  ENDMETHOD. "get_data

  METHOD get_report.
    me->get_data( ).

    IF gt_output IS NOT INITIAL.
      CALL SCREEN 0100.
    ELSE.
      MESSAGE s001(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDMETHOD. "get_report

  METHOD add_message.
    DATA: ls_return TYPE bapiret2.
    CLEAR:  ls_return.
    CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
      EXPORTING
        type   = iv_msg_type
        cl     = iv_msg_id
        number = iv_msg_numb
        par1   = iv_par1
        par2   = iv_par2
        par3   = iv_par3
        par4   = iv_par4
      IMPORTING
        return = ls_return.
    APPEND ls_return TO ct_return.
  ENDMETHOD. "add_message

  METHOD clear_alv.
    CLEAR:  lo_container,
            lo_alvgrid,
            ls_layout,
            ls_variant.
    REFRESH: lt_exclude.
    "lt_fc.

    FREE: lo_container,
          lo_alvgrid.

  ENDMETHOD. "clear_alv

  METHOD prepare_alv.
    IF lo_alvgrid IS INITIAL.
      me->get_tabname( iv_tabname = gc_output ).
      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = TEXT-000
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    IMPORTING et_fc          = lt_fc ).
      me->modify_fcat_edit(
        EXPORTING
          iv_field = 'ZNOT'
        CHANGING
          ct_fc    = lt_fc
      ).
      me->modify_fcat_hotspot(
        EXPORTING
          iv_field = 'VBELN'
        CHANGING
          ct_fc    = lt_fc
      ).
      me->exclude(        EXPORTING iv_statu       = abap_false
                          IMPORTING et_exclude     = lt_exclude ).
      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->sort_filter(    EXPORTING iv_field       = 'VBELN'
                                    it_fc          = lt_fc
                           CHANGING ct_sort_filter = lt_sort ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_output
                                    ct_fielcat     = lt_fc
                                    ct_sort        = lt_sort
                                    ct_exclude     = lt_exclude ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv

  METHOD create_container.
*    CREATE OBJECT co_alv_grid
*      EXPORTING
*        i_parent = cl_gui_custom_container=>screen0.

    CREATE OBJECT cs_container
      EXPORTING
        container_name = iv_cont_name.

    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cs_container.

  ENDMETHOD. "create_container

  METHOD create_container2.
    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cl_gui_custom_container=>screen0.
  ENDMETHOD. "create_container2

  METHOD create_layout.
    es_layout-zebra       = abap_true.
    es_layout-smalltitle  = abap_true.
    es_layout-cwidth_opt  = abap_true.
    es_layout-sel_mode    = 'D'.
    es_layout-grid_title  = iv_title.
    es_layout-info_fname  = 'COLOR'."Style
  ENDMETHOD. "create_layout

  METHOD create_variant.
    es_variant-handle = iv_handle.
    es_variant-report = sy-repid.
  ENDMETHOD. "create_variant

  METHOD create_fcat.
    DATA: lv_text TYPE string,
          ls_fcat TYPE lvc_s_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZVKT_MO_S0002'
      CHANGING
        ct_fieldcat            = et_fc
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc EQ 0.
      "field catalog ekranda göstermeme i#lemi
*      me->modify_fcat_no_out( EXPORTING iv_field = 'SELECT' CHANGING  ct_fc    = et_fc ).

      "field catalog hotspot
*      me->modify_fcat_hotspot( EXPORTING iv_field = 'TKNUM' CHANGING  ct_fc    = et_fc ).

      "field catalog tan#m de#i#tirme i#lemi
*      lv_text = TEXT-003.
*      me->modify_fcat( EXPORTING iv_field ='EDATU'
*                                 iv_text  = lv_text
*                       CHANGING  ct_fc    = et_fc ).
      "field catalog edite açma i#lemi
*      me->modify_fcat_edit( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog checkbox olarak gösterme i#lemi
*      me->modify_fcat_chkbox( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog hücre renklendirme
*      me->modify_fcat_color( EXPORTING  iv_field = 'ZTERM'
*                                        iv_color = 'C500'
*                             CHANGING   ct_fc    =  et_fc ).

    ENDIF.
  ENDMETHOD. "create_fcat
  METHOD modify_fcat.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-scrtext_s = iv_text.
      <lfs_fc>-scrtext_m = iv_text.
      <lfs_fc>-scrtext_l = iv_text.
      <lfs_fc>-reptext   = iv_text.
      <lfs_fc>-coltext   = iv_text.
      <lfs_fc>-col_opt   = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat

  METHOD modify_fcat_edit.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-edit = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_edit

  METHOD modify_fcat_no_out.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-no_out = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_hotspot.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-hotspot = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_chkbox.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-checkbox = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_chkbox

  METHOD modify_fcat_color.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-emphasize = iv_color.
    ENDIF.
  ENDMETHOD. "modify_fcat_color

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

  METHOD sort_filter.
    REFRESH: ct_sort_filter.
    READ TABLE it_fc INTO DATA(ls_fc) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      ct_sort_filter = VALUE #( ( fieldname = ls_fc-fieldname spos = ls_fc-col_pos up = 'X') ).
    ENDIF.
  ENDMETHOD.  "sort_filter

  METHOD event_receiver.
    SET HANDLER me->handle_data_changed  FOR cs_alvgird.
    SET HANDLER me->handle_hotspot_click FOR cs_alvgird.
    SET HANDLER me->handle_toolbar       FOR cs_alvgird.
    SET HANDLER me->handle_user_command  FOR cs_alvgird.
  ENDMETHOD. "event_receiver

  METHOD display_alv.
    CALL METHOD cs_alvgird->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    CALL METHOD cs_alvgird->set_table_for_first_display
      EXPORTING
        is_layout            = cs_layout
        is_variant           = cs_variant
        i_save               = 'A'
        it_toolbar_excluding = ct_exclude
      CHANGING
        it_outtab            = ct_output
        it_fieldcatalog      = ct_fielcat
        it_sort              = lt_sort.

  ENDMETHOD. "display_alv

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alvgird->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

  METHOD refresh_alv_2.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD lo_alvgrid->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv_2

  METHOD get_tabname.
    gv_tabname = iv_tabname.
  ENDMETHOD. "get_tabname

  METHOD get_pop_data.
    REFRESH:  gt_pop_data.

    SELECT a~vbeln,
           a~posnr,
           c~vbeln AS vbeln_vl,
           b~posnr AS posnr_vl,
           b~matnr,
           d~maktx,
           b~lfimg,
           b~vrkme
      FROM vbap AS a
      LEFT OUTER JOIN lips AS b ON a~vbeln EQ b~vgbel AND a~posnr EQ b~vgpos
      LEFT OUTER JOIN likp AS c ON b~vbeln EQ c~vbeln
      LEFT OUTER JOIN makt AS d ON b~matnr EQ d~matnr AND d~spras EQ @sy-langu
      WHERE a~vbeln EQ @iv_vbeln
      INTO TABLE @et_data.


  ENDMETHOD.

  METHOD get_pop_report.
    me->get_pop_data(
      EXPORTING
        iv_vbeln =  iv_temp
      IMPORTING
        et_data  = gt_pop_data
    ).

    IF gt_pop_data IS NOT INITIAL.

      me->prepare_pop_alv( ).
    ELSE.
      MESSAGE s001(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDMETHOD. "get_report

  METHOD prepare_pop_alv.
    IF lo_popup IS INITIAL.
      TRY.
          cl_salv_table=>factory(
            IMPORTING
              r_salv_table =  lo_popup
            CHANGING
              t_table      = gt_pop_data ) .

        CATCH cx_salv_msg.
      ENDTRY.

      DATA: lr_functions TYPE REF TO cl_salv_functions_list.

      lr_functions = lo_popup->get_functions( ).
      lr_functions->set_all( 'X' ).

      IF lo_popup IS BOUND.
        lo_popup->set_screen_popup(
           start_column = 25
           end_column  = 100
           start_line  = 6
           end_line    = 10 ).

        lo_popup->display( ).

      ENDIF.
    ENDIF.


*    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = 'ZVKT_MO_S0003'
*      CHANGING
*        ct_fieldcat      = lt_pop_fc.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*    CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
*      EXPORTING
**       I_TITLE     =
**       I_SELECTION = 'X'
**       I_ALLOW_NO_SELECTION          =
**       I_ZEBRA     = ' '
**       I_SCREEN_START_COLUMN         = 0
**       I_SCREEN_START_LINE           = 0
**       I_SCREEN_END_COLUMN           = 0
**       I_SCREEN_END_LINE             = 0
**       I_CHECKBOX_FIELDNAME          =
**       I_LINEMARK_FIELDNAME          =
**       I_SCROLL_TO_SEL_LINE          = 'X'
*        i_tabname   = 'ZVKT_MO_S0003'
**       I_STRUCTURE_NAME              =
*        it_fieldcat = lt_pop_fc
**       IT_EXCLUDING                  =
**       I_CALLBACK_PROGRAM            =
**       I_CALLBACK_USER_COMMAND       =
**       IS_PRIVATE  =
**     IMPORTING
**       ES_SELFIELD =
**       E_EXIT      =
*      TABLES
*        t_outtab    = gt_pop_data
**     EXCEPTIONS
**       PROGRAM_ERROR                 = 1
**       OTHERS      = 2
*      .
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

  ENDMETHOD.

  METHOD save_not.

    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).


    IF lv_lines EQ 0.
      MESSAGE TEXT-002 TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_selected_rows-index.

      gs_not-vbeln = <lfs_output>-vbeln .
      gs_not-znot = <lfs_output>-znot .


      APPEND gs_not TO gt_not.

    ENDLOOP.

    MODIFY zvkt_mo_t0002 FROM TABLE gt_not.

    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      MESSAGE TEXT-004 TYPE 'E' DISPLAY LIKE 'S'.
    ELSE.
      ROLLBACK WORK.

    ENDIF.


  ENDMETHOD.

  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
        ls_selected_rows,
        lv_lines.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.
  ENDMETHOD.

  METHOD print_adobe.
    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).


    IF lv_lines EQ 0.
      MESSAGE TEXT-002 TYPE 'E' DISPLAY LIKE 'E'.
    ELSEIF lv_lines GT 1.
      MESSAGE TEXT-003 TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        DATA(lv_vbeln) = <lfs_output>-vbeln.
      ENDIF.
    ENDLOOP.

    me->get_pop_data(
      EXPORTING
        iv_vbeln = lv_vbeln
      IMPORTING
        et_data  = gt_items
    ).

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZVKT_AF_MO_0002'
      IMPORTING
        e_funcname = fm_name.

    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        it_items          = gt_items
*   IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.

  METHOD print_smart.


    DATA : lv_fm_name TYPE rs38l_fnam.
    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).


    IF lv_lines EQ 0.
      MESSAGE TEXT-002 TYPE 'E' DISPLAY LIKE 'E'.
    ELSEIF lv_lines GT 1.
      MESSAGE TEXT-003 TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        DATA(lv_vbeln) = <lfs_output>-vbeln.
      ENDIF.
    ENDLOOP.

    me->get_pop_data(
      EXPORTING
        iv_vbeln = lv_vbeln
      IMPORTING
        et_data  = gt_items
    ).


    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZMEHMETO_SF_001' "Kullanılacak smartforms adı
      IMPORTING
        fm_name            = lv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.


    CALL FUNCTION lv_fm_name
      EXPORTING
*       archive_index    = toa_dara
*       archive_parameters = arc_params
*       control_parameters = ls_control_param
*       mail_recipient   = ls_recipient
*       mail_sender      = ls_sender
*       output_options   = ls_composer_param
*       user_settings    = ' '
        it_items         = gt_items
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.


  ENDMETHOD.

  METHOD down_excel.

    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).


    IF lv_lines EQ 0.
      MESSAGE TEXT-002 TYPE 'E' DISPLAY LIKE 'E'.
    ELSEIF lv_lines GT 1.
      MESSAGE TEXT-003 TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        DATA(lv_vbeln) = <lfs_output>-vbeln.
      ENDIF.
    ENDLOOP.

    me->get_pop_data(
      EXPORTING
        iv_vbeln = lv_vbeln
      IMPORTING
        et_data  = gt_items
    ).

    DATA:   lv_title TYPE char35.
    lv_title = 'Satış Bilgileri'.
    CALL FUNCTION 'ZMO_OLE_EXCEL_DOWNLOAD'
      EXPORTING
        iv_subject = 'Sayfa'
        it_data    = gt_items
*       IT_TITLE   =
*       IT_COMPONENTS       =
        iv_italic  = 1
        iv_title   = lv_title.

  ENDMETHOD.

  METHOD send_mail.

    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).


    IF lv_lines EQ 0.
      MESSAGE TEXT-002 TYPE 'E' DISPLAY LIKE 'E'.
    ELSEIF lv_lines GT 1.
      MESSAGE TEXT-003 TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        DATA(lv_vbeln) = <lfs_output>-vbeln.
      ENDIF.
    ENDLOOP.

    me->get_pop_data(
      EXPORTING
        iv_vbeln = lv_vbeln
      IMPORTING
        et_data  = gt_items
    ).

    DATA: lv_subject         TYPE so_obj_des,
          lt_body_text       TYPE w3htmltab,
          lv_subject_attach  TYPE char255,
          lt_attachments     TYPE rmps_t_post_content,
          lt_attachments_tmp TYPE rmps_t_post_content,
          lv_sender          TYPE ad_smtpadr,
          lv_recipient       TYPE ad_smtpadr,
          lt_recipients      TYPE uiyt_iusr,
          lv_result          TYPE boolean,
          lv_text            TYPE char255.

    DATA: lt_where TYPE dmc_where_clause_tab.
    REFRESH: lt_where.

    CLEAR:  lv_subject,
            lv_subject_attach,
            lv_sender,
            lv_recipient,
            lv_result,
            lv_text.

    REFRESH:  lt_body_text,
              lt_attachments,
              lt_attachments_tmp,
              lt_recipients.

    "subject
    lv_subject =  lv_vbeln.

    INSERT: VALUE #( line = 'Selamlar,' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = '<br>' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = '<br>' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = lv_vbeln ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = ' Siparişine ait bilgiler mail ekinde bulunmaktadır.' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = '<br>' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = '<br>' ) INTO TABLE lt_body_text.
    INSERT: VALUE #( line = 'İyi çalışmalar.' ) INTO TABLE lt_body_text.

    lv_sender = 'INFO@VEKTORA.COM'.

    SELECT  mandt,
            email
      FROM zvkt_mo_t0003
      INTO CORRESPONDING FIELDS OF TABLE @lt_recipients.

    IF lt_recipients IS INITIAL.
      MESSAGE s007(zbulent) WITH 'ZVKT_MO_T0003' DISPLAY LIKE 'E'.  "Gönderilecek mail adresi bulunamadı! ZVKT_CT_MAIL tablosunun bakımını yapınız!
      EXIT.
    ENDIF.

    fp_outputparams-getpdf = 'X'.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZVKT_AF_MO_0002'
      IMPORTING
        e_funcname = fm_name.

    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams  = fp_docparams
        it_items           = gt_items
      IMPORTING
        /1bcdwb/formoutput = us_pdf_file
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.




    REFRESH: lt_attachments_tmp.
    CALL FUNCTION 'Z_FM_MAIL_ATTACHMENT_PDF'
      EXPORTING
        iv_subject     = 'Teslimat Bildirim Formu'
        is_pdf         = us_pdf_file
      IMPORTING
        et_attachments = lt_attachments_tmp.
    IF lt_attachments_tmp IS NOT INITIAL.
      INSERT LINES OF lt_attachments_tmp INTO TABLE lt_attachments.
      REFRESH: lt_attachments_tmp.
    ENDIF.

    CALL FUNCTION 'Z_FM_SEND_MAIL'
      EXPORTING
        subject      = lv_subject
        message_type = 'HTM'
        message_body = lt_body_text
*       ATTACHMENTS  = lt_attachments
        sender_mail  = lv_sender
        recipients   = lt_recipients
      IMPORTING
        result       = lv_result.
    IF lv_result EQ abap_true.
      MESSAGE s008(zbulent). "Mail gönderimi başarılı!
    ELSE.
      MESSAGE s009(zbulent) DISPLAY LIKE 'E'.  "Mail gönderimi başarısız!
      EXIT.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

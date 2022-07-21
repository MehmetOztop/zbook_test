*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0025_CLS
*&---------------------------------------------------------------------*
CLASS: lcl_personel DEFINITION.
  PUBLIC SECTION.
    DATA: go_personel    TYPE REF TO lcl_personel,
          gv_tabname     TYPE tabname,
          gt_return      TYPE bapirettab,
          gs_return      TYPE bapiret2,
          gv_error       TYPE char1,
          gt_output      TYPE TABLE OF zvkt_mo_t0006,
          gt_output_sent TYPE TABLE OF zvkt_mo_t0006,
          gs_output      TYPE zvkt_mo_t0006,
          gt_output2     TYPE TABLE OF zvkt_mo_s0005,
          gs_output2     TYPE zvkt_mo_s0005,
          gv_output      TYPE tabname VALUE 'ZVKT_MO_T0006'.

    METHODS:
      screen_output,
      start_of_selection,
      get_data,
      get_report,
      get_register,
      clear_alv,
      clear_all,
      get_selected_rows,
      add_message IMPORTING iv_msg_type TYPE bapi_mtype
                            iv_msg_numb TYPE syst_msgno
                            iv_msg_id   TYPE syst_msgid
                            iv_par1     TYPE syst_msgv
                            iv_par2     TYPE syst_msgv
                            iv_par3     TYPE syst_msgv
                            iv_par4     TYPE syst_msgv
                  CHANGING  ct_return   TYPE bapirettab,
      prepare_alv IMPORTING iv_struc_name TYPE dd02l-tabname,
      prepare_alv2 IMPORTING iv_struc_name TYPE dd02l-tabname,
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


      create_container    IMPORTING iv_cont_name TYPE scrfname
                          CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                    cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_container2   CHANGING  cs_alv_grid    TYPE REF TO cl_gui_alv_grid,
      create_layout       IMPORTING iv_title  TYPE lvc_title
                          EXPORTING es_layout TYPE lvc_s_layo,
      create_variant      IMPORTING iv_handle  TYPE slis_handl
                          EXPORTING es_variant TYPE disvariant,
      create_fcat         IMPORTING ev_struc_name TYPE dd02l-tabname
                          EXPORTING et_fc         TYPE lvc_t_fcat,
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
      get_tabname         IMPORTING iv_tabname     TYPE tabname,
      insert_row,
      modify_fcat_lower   IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      save_row.
ENDCLASS.


CLASS lcl_personel IMPLEMENTATION.
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

*    READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_out>) INDEX e_row_id-index.
*
*    lv_vbeln = <lfs_out>-vbeln.
*    REFRESH:  gt_pop_data.
*    CLEAR: lo_popup.
*    me->get_pop_report( iv_temp = <lfs_out>-vbeln ).

  ENDMETHOD. "handle_hotspot_click

  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
    CLEAR ls_toolbar.

    IF gv_output EQ 'ZVKT_MO_T0006'.
      MOVE   3          TO ls_toolbar-butn_type.
      APPEND ls_toolbar TO e_object->mt_toolbar.

      CLEAR ls_toolbar.
      MOVE 'INS'            TO ls_toolbar-function.
      MOVE icon_insert_row  TO ls_toolbar-icon.
      MOVE TEXT-003         TO ls_toolbar-quickinfo.
      MOVE TEXT-003         TO ls_toolbar-text.
      MOVE ' '              TO ls_toolbar-disabled.
      APPEND ls_toolbar     TO e_object->mt_toolbar.


      CLEAR ls_toolbar.
      MOVE 'SAVE'            TO ls_toolbar-function.
      MOVE icon_alv_variant_save  TO ls_toolbar-icon.
      MOVE TEXT-004         TO ls_toolbar-quickinfo.
      MOVE TEXT-004         TO ls_toolbar-text.
      MOVE ' '              TO ls_toolbar-disabled.
      APPEND ls_toolbar     TO e_object->mt_toolbar.


*      CLEAR ls_toolbar.
*      MOVE 'DEL'            TO ls_toolbar-function.
*      MOVE icon_delete_row  TO ls_toolbar-icon.
*      MOVE  TEXT-035        TO ls_toolbar-quickinfo.
*      MOVE  TEXT-035        TO ls_toolbar-text.
*      MOVE ' '              TO ls_toolbar-disabled.
*      APPEND ls_toolbar     TO e_object->mt_toolbar.
    ENDIF.
  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.
    IF gv_output EQ 'ZVKT_MO_T0006'.
      WAIT UP TO 1 SECONDS.
      CASE e_ucomm.
        WHEN 'INS'.
          "Satır Ekle
          me->insert_row( ).
          RETURN.
        WHEN 'SAVE'.
          me->save_row( ).
          RETURN.
      ENDCASE.
    ENDIF.
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
    CLEAR:    gs_output,
              gt_output,
              gv_tabname,
              gv_error,
              gs_return,
              lv_lines.

*    FREE  : lo_container,
*            screen.
*            lo_alvgrid.

*    FREE .
    IF lo_container IS NOT INITIAL.


      lo_container->free(
*  EXCEPTIONS
*    cntl_error        = 1
*    cntl_system_error = 2
*    others            = 3
      ).

    ENDIF.
    REFRESH: gt_return.

  ENDMETHOD."clear_all

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD. "start_of_selection

  METHOD get_data.
    me->clear_all( ).
    gv_output = 'ZVKT_MO_S0005'.
    SELECT t6~id,
           t6~ad,
           t6~soyad,
           t7~ad AS dep_ad,
           t8~ad AS tit_ad,
           t6~tecrube,
           t8~katsayi
      FROM zvkt_mo_t0006 AS t6
      INNER JOIN zvkt_mo_t0007 AS t7 ON t7~id EQ t6~departman_id
      INNER JOIN zvkt_mo_t0008 AS t8 ON t8~id EQ t6~title_id
      INTO TABLE @DATA(lt_temp)
      WHERE t6~ad    IN @s_ad    AND
            t6~soyad IN @s_soyad AND
            t7~ad    IN @s_dept  AND
            t8~ad    IN @s_title
      ORDER BY t6~id.

    LOOP AT lt_temp INTO DATA(ls_temp).
      CLEAR gs_output2.
      gs_output2-ad = ls_temp-ad.
      gs_output2-departman_adi = ls_temp-dep_ad.
      gs_output2-id = ls_temp-id.
      gs_output2-soyad = ls_temp-soyad.
      gs_output2-tecrube = ls_temp-tecrube.
      gs_output2-title_adi = ls_temp-tit_ad.

      DATA(lv_maas) = ls_temp-tecrube * ls_temp-katsayi * 2000.
      DATA(lv_tecrube) = ls_temp-tecrube.
      IF lv_tecrube = 1.
        gs_output2-izin = '-'.
      ELSEIF lv_tecrube >= 1 AND lv_tecrube < 3.
        gs_output2-izin = '1 HAFTA'.
      ELSEIF lv_tecrube >= 3 AND lv_tecrube < 5.
        gs_output2-izin = '2 HAFTA'.
      ELSEIF lv_tecrube >= 5 AND lv_tecrube < 10.
        gs_output2-izin = '3 HAFTA'.
      ELSE.
        gs_output2-izin = '1 AY    '.
      ENDIF.
*      DATA: lv_maas_f TYPE char8.
**      lv_maas_f = lv_maas.
*      CALL FUNCTION 'FLTP_CHAR_CONVERSION'
*        EXPORTING
*          decim = lv_maas
**         EXPON = 0
**         INPUT = 0
**         IVALU = ' '
**         MASKN = ' '
*        IMPORTING
*          flstr = lv_maas_f.

      gs_output2-maas = lv_maas.
      APPEND gs_output2 TO gt_output2.
    ENDLOOP.
    me->prepare_alv2( iv_struc_name = 'ZVKT_MO_S0005' ).

  ENDMETHOD. "get_data

  METHOD get_report.
    me->get_data( ).


    CALL SCREEN 0100.

  ENDMETHOD. "get_report

  METHOD get_register.
    me->clear_all( ).
    me->clear_alv( ).
    me->prepare_alv( iv_struc_name = 'ZVKT_MO_S0004' ).
    CALL SCREEN 0100.
  ENDMETHOD.

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
      me->get_tabname( iv_tabname = gv_output ).
      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = TEXT-000
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    EXPORTING ev_struc_name = iv_struc_name
                          IMPORTING et_fc          = lt_fc ).
*      me->modify_fcat_edit(
*        EXPORTING
*          iv_field = 'ZNOT'
*        CHANGING
*          ct_fc    = lt_fc
*      ).
*      me->modify_fcat_hotspot(
*        EXPORTING
*          iv_field = 'VBELN'
*        CHANGING
*          ct_fc    = lt_fc
*      ).
      me->exclude(        EXPORTING iv_statu       = abap_false
                          IMPORTING et_exclude     = lt_exclude ).
      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->sort_filter(    EXPORTING iv_field       = 'ID'
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
    CLEAR lt_fc.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = ev_struc_name
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

  METHOD modify_fcat_lower.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-lowercase = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_lower

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
*       i_soft_refresh = ''
        is_stable = ls_stable.


  ENDMETHOD. "refresh_alv_2

  METHOD get_tabname.
    gv_tabname = iv_tabname.
  ENDMETHOD. "get_tabname


  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
        ls_selected_rows,
        lv_lines.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.
  ENDMETHOD.

  METHOD insert_row.
*    lo_alvgrid->append_rows(
*       i_row_count = 1
*    ).

    APPEND gs_output TO gt_output.

*    lo_alvgrid->get_frontend_fieldcatalog(
*      IMPORTING
*        et_fieldcatalog =   DATA(lt_field)  " Field Catalog
*    ).

    LOOP AT lt_fc INTO DATA(ls_fc).
*      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ( ls_fc-row_pos + 1 ).
*      IF sy-subrc EQ 0.
*      IF <lfs_output>-id IS INITIAL.
      me->modify_fcat_edit(
      EXPORTING
        iv_field = ls_fc-fieldname
      CHANGING
        ct_fc    = lt_fc ).
*      ENDIF.
*      me->modify_fcat_lower( " Need case sensitive domains
*        EXPORTING
*          iv_field = ls_fc-fieldname
*        CHANGING
*          ct_fc    = lt_field
*      ).
*
*      ENDIF.
    ENDLOOP.

    lo_alvgrid->set_frontend_fieldcatalog( it_fieldcatalog = lt_fc ).
    me->refresh_alv_2( ).
  ENDMETHOD.

  METHOD save_row.

    me->get_selected_rows( ).
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s002(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
    DATA: ls_dept_ids  TYPE zvkt_mo_t0007,
          lt_dept_ids  TYPE TABLE OF zvkt_mo_t0007,
          ls_title_ids TYPE  zvkt_mo_t0008,
          lt_title_ids TYPE TABLE OF  zvkt_mo_t0008.

    SELECT id FROM zvkt_mo_t0007 AS t1
      INTO TABLE @DATA(lt_db_dept_ids).

    SELECT id FROM zvkt_mo_t0008 AS t1
      INTO TABLE @DATA(lt_db_tit_ids).

    LOOP AT lt_selected_rows INTO DATA(ls_rows).
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_rows-index.
      IF sy-subrc EQ 0.
        IF <lfs_output>-ad EQ space OR <lfs_output>-departman_id EQ space OR <lfs_output>-soyad EQ space
          OR <lfs_output>-soyad EQ space OR <lfs_output>-tecrube EQ space OR <lfs_output>-title_id EQ space.
          MESSAGE s004(zzy_0001) DISPLAY LIKE 'E'.
          CLEAR <lfs_output>.
          me->refresh_alv_2( ).
          RETURN.

        ELSE.
          ls_dept_ids-id = <lfs_output>-departman_id.
          APPEND ls_dept_ids TO lt_dept_ids.
          ls_title_ids-id = <lfs_output>-title_id.
          APPEND ls_title_ids TO lt_title_ids.

        ENDIF.
      ENDIF.

    ENDLOOP.
"range ile dene loopsuz
    LOOP AT lt_dept_ids INTO DATA(ls_depts).
      DATA(row) = VALUE #( lt_db_dept_ids[ id = ls_depts-id ] OPTIONAL ).
      IF row IS INITIAL.
        MESSAGE s005(zzy_0001) DISPLAY LIKE 'E'.
*        me->refresh_alv_2( ).
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_title_ids INTO DATA(ls_titles).
      DATA(row2) = VALUE #( lt_db_tit_ids[ id = ls_titles-id ] OPTIONAL ).
      IF row2 IS INITIAL.
        MESSAGE s006(zzy_0001) DISPLAY LIKE 'E'.
*        me->refresh_alv_2( ).
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output2>) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        IF <lfs_output2>-ad EQ space OR <lfs_output2>-departman_id EQ space OR <lfs_output2>-soyad EQ space
          OR <lfs_output2>-soyad EQ space OR <lfs_output2>-tecrube EQ space OR <lfs_output2>-title_id EQ space.
          MESSAGE s004(zzy_0001) DISPLAY LIKE 'E'.
          CLEAR <lfs_output2>.
          me->refresh_alv_2( ).

          RETURN.

        ELSE.
          "Tüm bilgiler girildi ve geçerli:

          gs_output-ad = <lfs_output2>-ad.
          gs_output-departman_id = <lfs_output2>-departman_id.
          gs_output-id = <lfs_output2>-id.
          gs_output-soyad = <lfs_output2>-soyad.
          gs_output-tecrube = <lfs_output2>-tecrube.
          gs_output-title_id = <lfs_output2>-title_id.
          gs_output-mandt = sy-mandt.
          APPEND gs_output TO gt_output_sent.

*          READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_table>) WITH KEY id = <lfs_output>-id.
*          <lfs_table>-ad = <lfs_output2>-ad.
*          <lfs_table>-departman_id = <lfs_output2>-departman_id.
*          <lfs_table>-id = <lfs_output2>-id.
*          <lfs_table>-mandt = <lfs_output2>-mandt.
*          <lfs_table>-soyad = <lfs_output2>-soyad.
*          <lfs_table>-tecrube = <lfs_output2>-tecrube.
*          <lfs_table>-title_id = <lfs_output2>-title_id.
*          <lfs_table>-mandt = sy-mandt.
*          APPEND <lfs_table> TO gt_output.
*          CLEAR <lfs_output2>.
        ENDIF.
      ENDIF.
    ENDLOOP.

    MODIFY zvkt_mo_t0006 FROM TABLE gt_output_sent.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      MESSAGE TEXT-005 TYPE 'S' DISPLAY LIKE 'S'.
    ELSE.
      ROLLBACK WORK.

    ENDIF.

    SORT gt_output_sent BY id.
    LOOP AT gt_output INTO DATA(ls_output_clearing).
      READ TABLE gt_output_sent TRANSPORTING NO FIELDS WITH KEY id = ls_output_clearing-id
                                                                   BINARY SEARCH.
      IF sy-subrc EQ 0.
        DELETE gt_output WHERE id EQ ls_output_clearing-id.
      ENDIF.
    ENDLOOP.

    CLEAR: gt_output_sent,
           gs_output.
    IF gt_output IS INITIAL.
      APPEND gs_output TO gt_output.
    ENDIF.

    me->refresh_alv_2( ).
  ENDMETHOD.

  METHOD prepare_alv2.
    IF lo_alvgrid IS INITIAL.
      "   me->get_tabname( iv_tabname = gc_output ).
      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = TEXT-000
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    EXPORTING ev_struc_name = iv_struc_name
                          IMPORTING et_fc          = lt_fc ).
*      me->modify_fcat_edit(
*        EXPORTING
*          iv_field = 'ZNOT'
*        CHANGING
*          ct_fc    = lt_fc
*      ).
*      me->modify_fcat_hotspot(
*        EXPORTING
*          iv_field = 'VBELN'
*        CHANGING
*          ct_fc    = lt_fc
*      ).
      me->exclude(        EXPORTING iv_statu       = abap_false
                          IMPORTING et_exclude     = lt_exclude ).
      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->sort_filter(    EXPORTING iv_field       = 'ID'
                                    it_fc          = lt_fc
                           CHANGING ct_sort_filter = lt_sort ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_output2
                                    ct_fielcat     = lt_fc
                                    ct_sort        = lt_sort
                                    ct_exclude     = lt_exclude ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv2


ENDCLASS.

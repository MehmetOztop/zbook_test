*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0027_CLS
*&---------------------------------------------------------------------*
CLASS lcl_six DEFINITION.
  PUBLIC SECTION.
    DATA: lt_fc     TYPE lvc_t_fcat,
          ls_layout TYPE lvc_s_layo.
    DATA: gt_result TYPE TABLE OF zvkt_mo_t0009.
    DATA: lv_cc            TYPE scrfname VALUE 'CC'.
    DATA: gt_bilet TYPE TABLE OF zvkt_mo_t0011.
    METHODS: check_input,
      generate EXPORTING ev_num TYPE int4,
      set_output,
      check_prize,
      buy_ticket,
      generate_lottery,
      call_alv,
      random_lottery IMPORTING iv_min    TYPE int4
                               iv_max    TYPE int4
                               iv_amount TYPE int4
                     EXPORTING et_result TYPE zvkt_mo_tt0003,
      get_selected_rows,
      display_ticket .
  PROTECTED SECTION.
    DATA: lo_container     TYPE REF TO cl_gui_custom_container,
          lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
          ls_variant       TYPE disvariant,
          ls_stable        TYPE lvc_s_stbl,
          lt_sort          TYPE lvc_t_sort,
          lt_selected_rows TYPE lvc_t_row,
          ls_selected_rows TYPE lvc_s_row,
          lv_lines         TYPE i,
          lt_exclude       TYPE ui_functions.
  PRIVATE SECTION.
    METHODS:     create_fcat         IMPORTING ev_struc_name TYPE dd02l-tabname
                                     EXPORTING et_fc         TYPE lvc_t_fcat,
      create_layout       IMPORTING iv_title  TYPE lvc_title
                          EXPORTING es_layout TYPE lvc_s_layo,

      prepare_alv IMPORTING iv_struc_name TYPE dd02l-tabname
                  CHANGING  ct_output     TYPE ANY TABLE,
      display_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid
                           cs_layout  TYPE lvc_s_layo
                           cs_variant TYPE disvariant
                           ct_output  TYPE ANY TABLE
                           ct_fielcat TYPE lvc_t_fcat
                           ct_sort    TYPE lvc_t_sort
                           ct_exclude TYPE ui_functions,
      create_container  IMPORTING iv_cont_name TYPE scrfname
                        CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                  cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_variant      IMPORTING iv_handle  TYPE slis_handl
                          EXPORTING es_variant TYPE disvariant   ,
      refresh_alv   CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid ,
      handle_toolbar       FOR EVENT toolbar        OF cl_gui_alv_grid IMPORTING e_object
                                                                                   e_interactive,
      handle_user_command  FOR EVENT user_command   OF cl_gui_alv_grid IMPORTING e_ucomm  ,
      exclude             IMPORTING iv_statu   TYPE char1
                          EXPORTING et_exclude TYPE ui_functions,
      sort_filter         IMPORTING iv_field       TYPE lvc_fname
                                    it_fc          TYPE lvc_t_fcat
                          CHANGING  ct_sort_filter TYPE lvc_t_sort,
      buy_ticket_actually,
      set_prizes,
      event_receiver      CHANGING cs_alvgird      TYPE REF TO cl_gui_alv_grid,
      categorize IMPORTING iv_odul      TYPE int4
                           iv_odul_turu TYPE string
                 CHANGING  cs_bilet     TYPE zvkt_mo_t0011.
ENDCLASS.

CLASS lcl_six IMPLEMENTATION.
  METHOD check_input.

    IF gs_input-num1 IS INITIAL OR gs_input-num2 IS INITIAL OR gs_input-num3 IS INITIAL OR
      gs_input-num4 IS INITIAL OR gs_input-num5 IS INITIAL OR gs_input-num6 IS INITIAL.
      MESSAGE  s007(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.

    ELSEIF ( abs( gs_input-num3 - gs_input-num2 ) = 1 AND abs( gs_input-num2 - gs_input-num1 ) = 1 ) OR
         ( abs( gs_input-num4 - gs_input-num3 ) = 1 AND abs( gs_input-num3 - gs_input-num2 ) = 1 ) OR
         ( abs( gs_input-num5 - gs_input-num4 ) = 1 AND abs( gs_input-num4 - gs_input-num3 ) = 1 ) OR
         ( abs( gs_input-num6 - gs_input-num5 ) = 1 AND abs( gs_input-num5 - gs_input-num4 ) = 1 )  .

      MESSAGE s008(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.

    ELSE.

      gs_number-znumber = gs_input-num1.
      APPEND gs_number TO gt_number.
      gs_number-znumber = gs_input-num2.
      APPEND gs_number TO gt_number.
      gs_number-znumber = gs_input-num3.
      APPEND gs_number TO gt_number.
      gs_number-znumber = gs_input-num4.
      APPEND gs_number TO gt_number.
      gs_number-znumber = gs_input-num5.
      APPEND gs_number TO gt_number.
      gs_number-znumber = gs_input-num6.
      APPEND gs_number TO gt_number.

      SORT gt_number BY znumber.
      DELETE ADJACENT DUPLICATES FROM gt_number COMPARING znumber.
    ENDIF.
    LOOP AT gt_number INTO DATA(ls_num).
      IF ls_num-znumber LT 1 OR ls_num-znumber GT 49.
        MESSAGE s009(zzy_0001) DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDLOOP.
    DATA(lv_count) = lines( gt_number ).
    IF lv_count LT 6.
      MESSAGE s010(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.

    ENDIF.
    DATA: lv_flag TYPE int1.
    CALL FUNCTION 'ZMEHMETO_F0003'
      EXPORTING
        it_numbers = gt_number
      IMPORTING
        ev_flag    = lv_flag.
    IF lv_flag EQ 0.
      MESSAGE s011(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
    gv_account = gv_account - 50.
    me->set_output( ).
    go_six->check_prize( ).
  ENDMETHOD.

  METHOD generate.

    CALL FUNCTION 'GENERAL_GET_RANDOM_INT'
      EXPORTING
        range  = 49
      IMPORTING
        random = ev_num.

  ENDMETHOD.

  METHOD set_output.
    CLEAR gs_output.
    CLEAR gs_number2.
    CLEAR gt_number2.
    DATA: lv_temp TYPE int4.
    me->generate(
      IMPORTING
        ev_num = lv_temp
    ).
    gs_output-num1 = lv_temp.
    me->generate(
  IMPORTING
    ev_num = lv_temp
).
    gs_output-num2 = lv_temp.
    me->generate(
  IMPORTING
    ev_num = lv_temp
).
    gs_output-num3 = lv_temp.
    me->generate(
  IMPORTING
    ev_num = lv_temp
).
    gs_output-num4 = lv_temp.
    me->generate(
  IMPORTING
    ev_num = lv_temp
).
    gs_output-num5 = lv_temp.
    me->generate(
  IMPORTING
    ev_num = lv_temp
).
    gs_output-num6 = lv_temp.

    IF ( abs( gs_output-num3 - gs_output-num2 ) = 1 AND abs( gs_output-num2 - gs_output-num1 ) = 1 ) OR
           ( abs( gs_output-num4 - gs_output-num3 ) = 1 AND abs( gs_output-num3 - gs_output-num2 ) = 1 ) OR
           ( abs( gs_output-num5 - gs_output-num4 ) = 1 AND abs( gs_output-num4 - gs_output-num3 ) = 1 ) OR
           ( abs( gs_output-num6 - gs_output-num5 ) = 1 AND abs( gs_output-num5 - gs_output-num4 ) = 1 )  .

      me->set_output( ).
      EXIT.

    ELSE.

      gs_number2-znumber = gs_output-num1.
      APPEND gs_number2 TO gt_number2.
      gs_number2-znumber = gs_output-num2.
      APPEND gs_number2 TO gt_number2.
      gs_number2-znumber = gs_output-num3.
      APPEND gs_number2 TO gt_number2.
      gs_number2-znumber = gs_output-num4.
      APPEND gs_number2 TO gt_number2.
      gs_number2-znumber = gs_output-num5.
      APPEND gs_number2 TO gt_number2.
      gs_number2-znumber = gs_output-num6.
      APPEND gs_number2 TO gt_number2.

      SORT gt_number2 BY znumber.
      DELETE ADJACENT DUPLICATES FROM gt_number2 COMPARING znumber.

      LOOP AT gt_number2 INTO DATA(ls_num).
        IF ls_num-znumber LT 1 OR ls_num-znumber GT 49.

          me->set_output( ).
          EXIT.
        ENDIF.
      ENDLOOP.
      DATA(lv_count) = lines( gt_number2 ).
      IF lv_count LT 6.

        me->set_output( ).
        EXIT.
        EXIT.
      ENDIF.
      DATA: lv_flag TYPE int1.
      CALL FUNCTION 'ZMEHMETO_F0003'
        EXPORTING
          it_numbers = gt_number2
        IMPORTING
          ev_flag    = lv_flag.
      IF lv_flag EQ 0.

        me->set_output( ).
        EXIT.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD check_prize.
    DATA: lv_counter TYPE int4 VALUE 0.
    DATA: lv_prize TYPE int4 VALUE 0.
    SORT gt_number2 BY znumber.
    LOOP AT gt_number INTO DATA(gs_number).
      READ TABLE gt_number2 TRANSPORTING NO FIELDS WITH KEY znumber = gs_number-znumber
      BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_counter = lv_counter + 1.
      ENDIF.
    ENDLOOP.

    IF lv_counter GT 1.
      SELECT SINGLE odul FROM zvkt_mo_t0010
        INTO @DATA(lv_odul) WHERE bilinen EQ @lv_counter.
      lv_prize = lv_odul.
      DATA: lv_temp TYPE string.
      lv_temp = lv_counter.
      CONCATENATE lv_temp 'sayı tutturdunuz' INTO DATA(lv_msg).
      MESSAGE lv_msg TYPE 'S' DISPLAY LIKE 'S'.
    ELSEIF lv_counter EQ 1.
      MESSAGE 'Bir tane tutturdunuz, bir dahakine kesin ödül var' TYPE 'S' DISPLAY LIKE 'S'.
    ELSE.
      MESSAGE 'Hiç tutturamadınız hehe' TYPE 'S' DISPLAY LIKE 'S'.
    ENDIF.
    gv_account = gv_account + lv_prize.

  ENDMETHOD.

  METHOD buy_ticket.
    gv_bilet_mod = 'buy'.
    IF p_amount IS NOT INITIAL AND p_date IS NOT INITIAL AND p_type IS NOT INITIAL.


      DATA: ls_bilet TYPE zvkt_mo_t0011.

      me->random_lottery(
        EXPORTING
          iv_min    = 1000000
          iv_max    = 9999999
          iv_amount = p_amount
        IMPORTING
          et_result = DATA(gt_result)
      ).
      LOOP AT gt_result INTO DATA(ls_result).
        ls_bilet-kullanici = sy-uname.
        ls_bilet-mandt = sy-mandt.
        ls_bilet-tarih = p_date.
        ls_bilet-tur = p_type.
        ls_bilet-znumara = ls_result-znumber.
        APPEND ls_bilet TO gt_bilet.
      ENDLOOP.
      go_six->call_alv( ).
    ELSE.
      MESSAGE s007(zzy_0001) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD random_lottery.
    CLEAR: gt_result.
    DATA: ls_result TYPE  zvkt_mo_t0009.
    DATA: lv_ran    TYPE zvkt_mo_t0009-znumber,
          lv_amount TYPE int4.
    lv_amount = iv_amount.
    WHILE lv_amount > 0.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max = iv_max
          ran_int_min = iv_min
        IMPORTING
          ran_int     = lv_ran.

      TRY.
          DATA(row) = gt_result[ znumber = lv_ran ].
        CATCH cx_sy_itab_line_not_found.

      ENDTRY.
      IF row IS INITIAL.
        ls_result-znumber = lv_ran.
        APPEND ls_result TO gt_result.
        lv_amount = lv_amount - 1.

      ENDIF.
      CLEAR row.
      CLEAR ls_result.


    ENDWHILE.

    et_result = gt_result.
    SORT et_result BY znumber.
  ENDMETHOD.


  METHOD create_fcat.
    DATA: lv_text TYPE string,
          ls_fcat TYPE lvc_s_fcat.
    CLEAR: lt_fc.
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


    ENDIF.
  ENDMETHOD. "create_fcat

  METHOD create_layout.
    es_layout-zebra       = abap_true.
    es_layout-smalltitle  = abap_true.
    es_layout-cwidth_opt  = abap_true.
    es_layout-sel_mode    = 'D'.
    es_layout-grid_title  = iv_title.
    es_layout-info_fname  = 'COLOR'."Style
  ENDMETHOD. "create_layout

  METHOD prepare_alv.
    IF lo_alvgrid IS INITIAL.

      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid
                                      ).
      me->create_layout(  EXPORTING iv_title       = TEXT-000
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    EXPORTING ev_struc_name = iv_struc_name
                          IMPORTING et_fc          = lt_fc ).
      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->exclude(        EXPORTING iv_statu       = abap_false
                          IMPORTING et_exclude     = lt_exclude ).
      me->sort_filter(    EXPORTING iv_field       = 'ID'
                                    it_fc          = lt_fc
      CHANGING ct_sort_filter = lt_sort ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = ct_output
                                    ct_fielcat     = lt_fc
                                    ct_sort        = lt_sort
                                    ct_exclude     = lt_exclude ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv

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

  METHOD create_container.

    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cl_gui_custom_container=>screen0.
  ENDMETHOD. "create_container2

  METHOD create_variant.
    es_variant-handle = iv_handle.
    es_variant-report = sy-repid.
  ENDMETHOD. "create_variant

  METHOD call_alv.
    SORT gt_bilet BY znumara.
    me->prepare_alv(
      EXPORTING
        iv_struc_name = 'ZVKT_MO_S0008'
      CHANGING
        ct_output     = gt_bilet
    ).
    CALL SCREEN 0300.
  ENDMETHOD.

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alvgird->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
    CLEAR ls_toolbar.

    IF gv_bilet_mod = 'buy'.
      MOVE   3          TO ls_toolbar-butn_type.
      APPEND ls_toolbar TO e_object->mt_toolbar.

      CLEAR ls_toolbar.
      MOVE 'BUY'            TO ls_toolbar-function.
      MOVE icon_alv_variant_save  TO ls_toolbar-icon.
      MOVE TEXT-002         TO ls_toolbar-quickinfo.
      MOVE TEXT-002         TO ls_toolbar-text.
      MOVE ' '              TO ls_toolbar-disabled.
      APPEND ls_toolbar     TO e_object->mt_toolbar.


    ENDIF.
  ENDMETHOD. "handle_toolbar

  METHOD event_receiver.
    SET HANDLER me->handle_toolbar       FOR cs_alvgird.
    SET HANDLER me->handle_user_command  FOR cs_alvgird.
  ENDMETHOD. "event_receiver

  METHOD buy_ticket_actually.
    DATA: ls_bilet TYPE zvkt_mo_t0011.
    DATA: lt_bilet TYPE TABLE OF zvkt_mo_t0011.
    me->get_selected_rows( ).
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s002(zzy_0001) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
    LOOP AT lt_selected_rows INTO DATA(ls_rows).
      READ TABLE gt_bilet ASSIGNING FIELD-SYMBOL(<lfs_bilet>) INDEX ls_rows-index.
      IF sy-subrc EQ 0.
        ls_bilet-kullanici = sy-uname.
        ls_bilet-mandt = sy-mandt.
        ls_bilet-tarih = p_date.
        ls_bilet-tur = p_type.
        ls_bilet-znumara = <lfs_bilet>-znumara.
        APPEND ls_bilet TO lt_bilet.

      ENDIF.
    ENDLOOP.
    INSERT zvkt_mo_t0011 FROM TABLE @lt_bilet.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      MESSAGE 'Biletler satın alındı' TYPE 'S' DISPLAY LIKE 'S'.
      SORT lt_bilet BY znumara.
      LOOP AT gt_bilet INTO DATA(ls_bilet_clearing).
        READ TABLE lt_bilet TRANSPORTING NO FIELDS WITH KEY znumara = ls_bilet_clearing-znumara
                                                                     BINARY SEARCH.
        IF sy-subrc EQ 0.
          DELETE gt_bilet WHERE znumara EQ ls_bilet_clearing-znumara AND tur EQ p_type.
        ENDIF.
      ENDLOOP.
      me->refresh_alv(
        CHANGING
          cs_alvgird = lo_alvgrid
      ).
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

  METHOD handle_user_command.

    WAIT UP TO 1 SECONDS.
    CASE e_ucomm.
      WHEN 'BUY'.
        me->buy_ticket_actually( ).
        RETURN.
    ENDCASE.

  ENDMETHOD. "handle_user_command

  METHOD sort_filter.
    REFRESH: ct_sort_filter.
    READ TABLE it_fc INTO DATA(ls_fc) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      ct_sort_filter = VALUE #( ( fieldname = ls_fc-fieldname spos = ls_fc-col_pos up = 'X') ).
    ENDIF.
  ENDMETHOD.
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

  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
        ls_selected_rows,
        lv_lines.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.
  ENDMETHOD.

  METHOD display_ticket.
    gv_bilet_mod = 'check'.
    CLEAR: gt_bilet.
    me->set_prizes( ).
    SELECT * FROM zvkt_mo_t0011 INTO TABLE @gt_bilet
      WHERE kullanici EQ @sy-uname.
    SORT gt_bilet BY tarih.
    me->prepare_alv(
          EXPORTING
            iv_struc_name = 'ZVKT_MO_S0009'
          CHANGING
            ct_output     = gt_bilet
        ).
    CALL SCREEN 0300.
  ENDMETHOD.


  METHOD generate_lottery.
    IF p_date IS NOT INITIAL.


      DATA: lt_cekilis TYPE TABLE OF zvkt_mo_t0012,
            ls_cekilis TYPE zvkt_mo_t0012,
            lv_temp    TYPE string,
            lv_conv    TYPE string.
      me->random_lottery(
        EXPORTING
          iv_min    = 1000000
          iv_max    = 9999999
          iv_amount = 1
        IMPORTING
          et_result = DATA(lt_result)
      ).
      READ TABLE lt_result INTO DATA(ls_result) INDEX 1.
      ls_cekilis-yedi = ls_result-znumber.
      CLEAR: lt_result,
             ls_result.

      me->random_lottery(
        EXPORTING
          iv_min    = 100000
          iv_max    = 999999
          iv_amount = 5
        IMPORTING
          et_result = lt_result
      ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-alti = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.


      me->random_lottery(
    EXPORTING
      iv_min    = 10000
      iv_max    = 99999
      iv_amount = 10
    IMPORTING
      et_result = lt_result
  ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-bes = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.


      me->random_lottery(
    EXPORTING
      iv_min    = 1000
      iv_max    = 9999
      iv_amount = 15
    IMPORTING
      et_result = lt_result
  ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-dort = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.


      me->random_lottery(
  EXPORTING
   iv_min    = 100
   iv_max    = 999
   iv_amount = 20
  IMPORTING
   et_result = lt_result
  ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-uc = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.


      me->random_lottery(
    EXPORTING
      iv_min    = 10
      iv_max    = 99
      iv_amount = 25
    IMPORTING
      et_result = lt_result
  ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-iki = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.

      me->random_lottery(
    EXPORTING
      iv_min    = 1
      iv_max    = 9
      iv_amount = 2
    IMPORTING
      et_result = lt_result
  ).
      LOOP AT lt_result INTO ls_result.
        lv_conv = ls_result-znumber.
        CONCATENATE lv_temp lv_conv '-' INTO lv_temp.
      ENDLOOP.
      CONDENSE lv_temp NO-GAPS.
      ls_cekilis-amorti = lv_temp.
      CLEAR: lt_result,
         ls_result,
         lv_temp.

      ls_cekilis-mandt = sy-mandt.
      ls_cekilis-tarih = p_date.

      INSERT zvkt_mo_t0012 FROM @ls_cekilis.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        SELECT * FROM zvkt_mo_t0012
          INTO TABLE @DATA(lt_cekilisler).
        SORT lt_cekilisler BY tarih.
        me->prepare_alv(
   EXPORTING
     iv_struc_name = 'ZVKT_MO_S0010'
   CHANGING
     ct_output     = lt_cekilisler
 ).
        CALL SCREEN 0300.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s012(zzy_0001) DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE s004(zzy_0001) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD set_prizes.

    DATA: lt_bilet_islem TYPE TABLE OF zvkt_mo_t0011,
          lv_odul        TYPE int4.
    SELECT * FROM zvkt_mo_t0012
  INTO TABLE @DATA(lt_cekilisler).

    SELECT * FROM zvkt_mo_t0011
      INTO TABLE @DATA(lt_biletler).

    SORT lt_cekilisler BY tarih.
    LOOP AT lt_biletler INTO DATA(ls_bilet).
      READ TABLE lt_cekilisler INTO DATA(ls_cekilisler) WITH KEY tarih = ls_bilet-tarih
                                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF ls_bilet-znumara EQ ls_cekilisler-yedi.
          me->categorize(
            EXPORTING
              iv_odul      = 1000000
              iv_odul_turu = 'Büyük İkramiye'
            CHANGING
              cs_bilet     = ls_bilet
          ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.
        ELSEIF ls_cekilisler-alti CS ls_bilet-znumara+1(6) .
          me->categorize(
           EXPORTING
             iv_odul      = 500000
             iv_odul_turu = 'Altılı'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ELSEIF ls_cekilisler-bes CS ls_bilet-znumara+2(5) .
          me->categorize(
           EXPORTING
             iv_odul      = 250000
             iv_odul_turu = 'Beşli'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ELSEIF ls_cekilisler-dort CS ls_bilet-znumara+3(4) .
          me->categorize(
           EXPORTING
             iv_odul      = 125000
             iv_odul_turu = 'Dörtlü'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ELSEIF ls_cekilisler-uc CS ls_bilet-znumara+4(3) .
          me->categorize(
           EXPORTING
             iv_odul      = 75000
             iv_odul_turu = 'Üçlü'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ELSEIF ls_cekilisler-iki CS ls_bilet-znumara+5(2) .
          me->categorize(
           EXPORTING
             iv_odul      = 35000
             iv_odul_turu = 'İkili'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ELSEIF ls_cekilisler-amorti CS ls_bilet-znumara+6(1) .
          me->categorize(
           EXPORTING
             iv_odul      = 500
             iv_odul_turu = 'Amorti'
           CHANGING
             cs_bilet     = ls_bilet
         ).
          APPEND ls_bilet TO lt_bilet_islem.
          CONTINUE.

        ENDIF.
      ELSE.

      ENDIF.
    ENDLOOP.

    UPDATE zvkt_mo_t0011 FROM TABLE lt_bilet_islem.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

  METHOD categorize.
    DATA(lv_odul) = iv_odul.
    CASE cs_bilet-tur.
      WHEN 'TAM'.
        lv_odul = iv_odul.
        cs_bilet-odul_turu = iv_odul_turu.
        cs_bilet-ikramiye = lv_odul.
      WHEN 'YARIM'.
        lv_odul = iv_odul / 2.
        cs_bilet-odul_turu = iv_odul_turu.
        cs_bilet-ikramiye = lv_odul.
      WHEN 'ÇEYREK'.
        lv_odul = iv_odul / 4.
        cs_bilet-odul_turu = iv_odul_turu.
        cs_bilet-ikramiye = lv_odul.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0032_CLS
*&---------------------------------------------------------------------*
CLASS lcl_demir DEFINITION.
  PUBLIC SECTION.
    METHODS: get_data,
      display_alv.

  PROTECTED SECTION.

    DATA: ls_stable        TYPE lvc_s_stbl.


  PRIVATE SECTION.
    METHODS: build_fcat,
      build_layout IMPORTING iv_title TYPE lvc_title,
      refresh_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid,
      handle_button_click2 FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING
            es_col_id
            es_row_no
            sender,
      handle_button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING
            es_col_id
            es_row_no
            sender.
ENDCLASS.

CLASS lcl_demir IMPLEMENTATION.

  METHOD get_data.
    SELECT * FROM zvkt_mo_t0016
      INTO TABLE @gt_stok.

    LOOP AT gt_stok ASSIGNING FIELD-SYMBOL(<lfs_stok>).
      <lfs_stok>-ztus = 'Taşı'.
      IF <lfs_stok>-demirbas_mi EQ 'D'.

        APPEND <lfs_stok> TO gt_demir.
        DELETE gt_stok WHERE matnr = <lfs_stok>-matnr.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD display_alv.

    CREATE OBJECT go_cont
      EXPORTING
        container_name = 'CC'.


    CREATE OBJECT go_split
      EXPORTING
        parent  = go_cont   " Parent Container
        rows    = 2   " Number of Rows to be displayed
        columns = 1.  " Number of Columns to be Displayed


    CALL METHOD go_split->get_container
      EXPORTING
        row       = 1 " Row
        column    = 1 " Column
      RECEIVING
        container = go_sub1.  " Container

    CALL METHOD go_split->set_row_height
      EXPORTING
        id     = 1   " Row ID
        height = 35.    " Height

    CALL METHOD go_split->get_container
      EXPORTING
        row       = 2 " Row
        column    = 1 " Column
      RECEIVING
        container = go_sub2.  " Container

    CALL METHOD go_split->set_row_height
      EXPORTING
        id     = 1   " Row ID
        height = 35.    " Height

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_sub1.   " Parent Container

    gv_flag = 'S'.
    me->build_fcat( ).
    SET HANDLER:
    me->handle_button_click FOR go_alv.
    me->build_layout( iv_title = 'Serbest Stoklar Listesi' ).
    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_stok   " Output Table
        it_fieldcatalog = gt_fieldcatalog.

    CREATE OBJECT go_alv2
      EXPORTING
        i_parent = go_sub2.   " Parent Container
    gv_flag = 'D'.
    me->build_fcat( ).
    SET HANDLER:
    me->handle_button_click2 FOR go_alv2.
    me->build_layout( iv_title = 'Demirbaşlar Listesi' ).
    CALL METHOD go_alv2->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_demir   " Output Table
        it_fieldcatalog = gt_fieldcatalog.
  ENDMETHOD.

  METHOD build_fcat.
    CLEAR gt_fieldcatalog.

    gs_fieldcatalog-fieldname   = 'MATNR'.
    " gs_fieldcatalog-coltext     = 'Hiyerarşi Kodu'.
    gs_fieldcatalog-scrtext_s   = 'Mal. No.'.
    gs_fieldcatalog-scrtext_m   = 'Malzeme Numarası'.
    gs_fieldcatalog-scrtext_l   = 'Malzeme Numarası'.
    gs_fieldcatalog-outputlen   = 25.
    gs_fieldcatalog-col_pos     = 1.
    APPEND gs_fieldcatalog TO gt_fieldcatalog.
    CLEAR  gs_fieldcatalog.

    gs_fieldcatalog-fieldname   = 'MAKTX'.
    " gs_fieldcatalog-coltext     = 'Hiyerarşi Kodu'.
    gs_fieldcatalog-scrtext_s   = 'Mal. Tan.'.
    gs_fieldcatalog-scrtext_m   = 'Malzeme Tanımı'.
    gs_fieldcatalog-scrtext_l   = 'Malzeme Tanımı'.
    gs_fieldcatalog-outputlen   = 25.
    gs_fieldcatalog-col_pos     = 2.
    APPEND gs_fieldcatalog TO gt_fieldcatalog.
    CLEAR  gs_fieldcatalog.

    gs_fieldcatalog-fieldname   = 'LABST'.
    " gs_fieldcatalog-coltext     = 'Hiyerarşi Kodu'.
    gs_fieldcatalog-scrtext_s   = 'Stok'.
    gs_fieldcatalog-scrtext_m   = 'Stok Miktarı'.
    gs_fieldcatalog-scrtext_l   = 'Stok Miktarı'.
    gs_fieldcatalog-outputlen   = 25.
    gs_fieldcatalog-col_pos     = 3.
    APPEND gs_fieldcatalog TO gt_fieldcatalog.
    CLEAR  gs_fieldcatalog.

    IF gv_flag = 'S'.
      gs_fieldcatalog-fieldname   = 'ZTUS'.
      " gs_fieldcatalog-coltext     = 'Hiyerarşi Kodu'.
      gs_fieldcatalog-scrtext_s   = 'Demirbaş'.
      gs_fieldcatalog-scrtext_m   = 'Demirbaşlara Ekle'.
      gs_fieldcatalog-scrtext_l   = 'Demirbaşlara Ekle '.
      gs_fieldcatalog-outputlen   = 15.
      gs_fieldcatalog-col_pos     = 4.
      gs_fieldcatalog-style = cl_gui_alv_grid=>mc_style_button.

      APPEND gs_fieldcatalog TO gt_fieldcatalog.
      CLEAR  gs_fieldcatalog.
    ELSE.
      gs_fieldcatalog-fieldname   = 'ZTUS'.
      " gs_fieldcatalog-coltext     = 'Hiyerarşi Kodu'.
      gs_fieldcatalog-scrtext_s   = 'Stok'.
      gs_fieldcatalog-scrtext_m   = 'Serbest Stok'.
      gs_fieldcatalog-scrtext_l   = 'Serbest Stoklara Ekle '.
      gs_fieldcatalog-outputlen   = 15.
      gs_fieldcatalog-col_pos     = 4.
      gs_fieldcatalog-style = cl_gui_alv_grid=>mc_style_button.

      APPEND gs_fieldcatalog TO gt_fieldcatalog.
      CLEAR  gs_fieldcatalog.
    ENDIF.

  ENDMETHOD.



  METHOD handle_button_click.
*   define local data
    DATA:
      ls_stok   TYPE zvkt_mo_t0016,
      ls_col_id TYPE lvc_s_col.


    READ TABLE gt_stok INTO ls_stok INDEX es_row_no-row_id.
    DELETE gt_stok WHERE matnr = ls_stok-matnr.
    ls_stok-demirbas_mi = 'D'.
    APPEND ls_stok TO gt_demir.

    UPDATE zvkt_mo_t0016 FROM @ls_stok.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.


    me->refresh_alv(
         CHANGING
           cs_alvgird = go_alv
       ).
    me->refresh_alv(
            CHANGING
              cs_alvgird = go_alv2
          ).

  ENDMETHOD.

  METHOD handle_button_click2.
*   define local data
    DATA:
      ls_stok   TYPE zvkt_mo_t0016,
      ls_col_id TYPE lvc_s_col.



    READ TABLE gt_demir INTO ls_stok INDEX es_row_no-row_id.

    DELETE gt_demir WHERE matnr = ls_stok-matnr.
    ls_stok-demirbas_mi = 'S'.
    APPEND ls_stok TO gt_stok.

    UPDATE zvkt_mo_t0016 FROM @ls_stok.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    me->refresh_alv(
        CHANGING
          cs_alvgird = go_alv
      ).
    me->refresh_alv(
            CHANGING
              cs_alvgird = go_alv2
          ).



  ENDMETHOD.
  "handle_button_click

  "lcl_eventhandler IMPLEMENTATION

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alvgird->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

  METHOD build_layout.
    CLEAR: gs_layout.
"    gs_layout-cwidth_opt = 'X'.
    gs_layout-zebra      = 'X'.
    gs_layout-grid_title = iv_title.
  ENDMETHOD.
ENDCLASS.

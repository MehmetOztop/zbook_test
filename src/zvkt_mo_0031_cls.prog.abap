*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0031_CLS
*&---------------------------------------------------------------------*
CLASS lcl_il DEFINITION.
  PUBLIC SECTION.
    METHODS: get_data,
      display,
      set_layout,
      set_fcat,
      build_alv,
      build_fcat IMPORTING iv_col_pos   TYPE lvc_colpos
                           iv_fieldname TYPE string
                           iv_scrtext_s TYPE string
                           iv_scrtext_m TYPE string
                           iv_scrtext_l TYPE string.
ENDCLASS.
CLASS  lcl_il IMPLEMENTATION.
  METHOD get_data.
    SELECT * FROM zvkt_mo_t0013
INTO TABLE @gt_il.

    SELECT * FROM zvkt_mo_t0014
INTO TABLE @gt_ilce.

    SELECT * FROM zvkt_mo_t0015
INTO TABLE @gt_pair.
  ENDMETHOD.

  METHOD display.
    IF go_grid IS INITIAL.
      me->set_layout( ).
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = cl_gui_container=>screen0.    " Parent Container

      CALL METHOD go_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = <dyn_table>   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD set_layout.
    "   gs_layout-cwidth_opt = 'X'.
    gs_layout-zebra = 'X'.
  ENDMETHOD.
  METHOD build_alv.
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat     " Field Catalog
      IMPORTING
        ep_table        = go_table.   " Pointer to Dynamic Data Table

    ASSIGN go_table->* TO <dyn_table>.
    CREATE DATA gs_table LIKE LINE OF <dyn_table>.
    ASSIGN gs_table->* TO <gfs_table>.

    SORT gt_pair BY il_kodu.
    DATA(lv_counter) = 1.

    LOOP AT gt_il INTO DATA(ls_il).
      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.
      IF <gfs_table> IS ASSIGNED.
        READ TABLE gt_fcat INDEX lv_counter INTO DATA(ls_fcat).
        ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
        IF <gfs1> IS ASSIGNED.
          <gfs1> = ls_il-il_tanim.
        ENDIF.
      ENDIF.
      CLEAR: ls_fcat.
      lv_counter = lv_counter + 1.
      READ TABLE gt_pair TRANSPORTING NO FIELDS WITH KEY il_kodu = ls_il-il_kodu BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_pair_index) = sy-tabix.
        LOOP AT gt_pair INTO DATA(ls_pair) FROM lv_pair_index.
          IF ls_pair-il_kodu NE ls_il-il_kodu.
            CLEAR: ls_fcat.
            lv_counter = 1.
            EXIT.
          ENDIF.
          READ TABLE gt_ilce ASSIGNING FIELD-SYMBOL(<lfs_ilce>) WITH KEY ilce_kodu = ls_pair-ilce_kodu.
          IF sy-subrc EQ 0.
            READ TABLE gt_fcat INDEX lv_counter INTO ls_fcat.
            ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
            IF <gfs1> IS ASSIGNED.
              <gfs1> = <lfs_ilce>-ilce_tanim.
              lv_counter = lv_counter + 1.
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDLOOP.






  ENDMETHOD.
  METHOD build_fcat.
    CLEAR gs_fcat.
    gs_fcat-col_pos = iv_col_pos.
    gs_fcat-fieldname = iv_fieldname.
    gs_fcat-scrtext_s = iv_scrtext_s.
    gs_fcat-scrtext_m = iv_scrtext_m.
    gs_fcat-scrtext_l = iv_scrtext_l.
    gs_fcat-datatype = 'CHAR'.
    gs_fcat-intlen = 40.




    .
    APPEND gs_fcat TO gt_fcat.
  ENDMETHOD.
  METHOD set_fcat.
    DATA : lv_count     TYPE int4 VALUE 2,
           lv_fieldname TYPE string,
           lv_ilce      TYPE string,
           lv_text      TYPE string.
    me->build_fcat(
      EXPORTING
        iv_col_pos   = 1
        iv_fieldname = 'IL'
        iv_scrtext_s = 'İl Tanımı'
        iv_scrtext_m = 'İl Tanımı'
        iv_scrtext_l = 'İl Tanımı'
    ).
*    LOOP AT gt_ilce INTO DATA(ls_ilce).
*      lv_ilce = ls_ilce-ilce_kodu.
*      SHIFT lv_ilce LEFT DELETING LEADING '0'.
*      CONCATENATE 'İlçe Tanım' lv_ilce INTO lv_text SEPARATED BY space.
*      CONCATENATE 'ilce_tanım_' lv_ilce INTO lv_fieldname.
*      me->build_fcat(
*        EXPORTING
*          iv_col_pos   = lv_count
*          iv_fieldname = lv_fieldname
*          iv_scrtext_s = lv_text
*          iv_scrtext_m = lv_text
*          iv_scrtext_l = lv_text
*      ).
*      lv_count = lv_count + 1.
*      CLEAR: lv_fieldname, lv_text.
*    ENDLOOP.

    DATA lt_col TYPE TABLE OF int4.
    DATA(lv_col_count) = 0.
    SORT gt_il BY il_kodu.
    SORT gt_pair BY il_kodu.
    LOOP AT gt_il INTO DATA(ls_il).
      READ TABLE gt_pair TRANSPORTING NO FIELDS WITH KEY il_kodu = ls_il-il_kodu.
      DATA(lv_index) = sy-tabix.

      LOOP AT gt_pair INTO DATA(ls_pair) FROM lv_index.
        IF ls_pair-il_kodu NE ls_il-il_kodu.
          APPEND lv_col_count TO lt_col.
          CLEAR: lv_col_count.
          EXIT.
        ENDIF.
        lv_col_count = lv_col_count + 1.
      ENDLOOP.

    ENDLOOP.
    APPEND lv_col_count TO lt_col.
    SORT lt_col DESCENDING.
    READ TABLE lt_col INTO DATA(lv_column) INDEX 1.

    DATA: lv_ind TYPE int4 VALUE 1.
    DO lv_column TIMES.
      lv_ilce = lv_ind.
      CONCATENATE 'İlçe Tanım' lv_ilce INTO lv_text SEPARATED BY space.
      CONCATENATE 'ilce_tanım_' lv_ilce INTO lv_fieldname.
      me->build_fcat(
        EXPORTING
          iv_col_pos   = lv_count
          iv_fieldname = lv_fieldname
          iv_scrtext_s = lv_text
          iv_scrtext_m = lv_text
          iv_scrtext_l = lv_text
      ).
      lv_count = lv_count + 1.
      lv_ind = lv_ind + 1.
      CLEAR: lv_fieldname, lv_text.
    ENDDO.


  ENDMETHOD.
ENDCLASS.

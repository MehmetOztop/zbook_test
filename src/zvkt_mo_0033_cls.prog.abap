*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0033_CLS
*&---------------------------------------------------------------------*
CLASS lcl_urun DEFINITION.
  PUBLIC SECTION.
    DATA: gt_urun TYPE TABLE OF zvkt_mo_t0020,
          gt_stok TYPE TABLE OF zvkt_mo_t0021.
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

CLASS lcl_urun IMPLEMENTATION.

  METHOD get_data.

    SELECT * FROM zvkt_mo_t0020 INTO TABLE @gt_urun.

    SELECT * FROM zvkt_mo_t0021 INTO TABLE @gt_stok.

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
    gs_layout-zebra = 'X'.
  ENDMETHOD.

  METHOD set_fcat.

    DATA : lv_count     TYPE int4 VALUE 3,
           lv_num       TYPE int4,
           lv_fieldname TYPE string,
           lv_temp      TYPE string,
           lv_text      TYPE string.
    me->build_fcat(
      EXPORTING
        iv_col_pos   = 1
        iv_fieldname = 'ANA_MALZEME'
        iv_scrtext_s = 'Ana Malz.'
        iv_scrtext_m = 'Ana Malzeme'
        iv_scrtext_l = 'Ana Malzeme'
    ).
    me->build_fcat(
       EXPORTING
         iv_col_pos   = 2
         iv_fieldname = 'URT_MIKTAR'
         iv_scrtext_s = 'Ürt. Mikt.'
         iv_scrtext_m = 'Üretilebilecek Mİktar'
         iv_scrtext_l = 'Üretilebilecek Mİktar'
     ).
    SORT gt_stok BY alt_malzeme.
    LOOP AT gt_stok INTO DATA(ls_stok).
      lv_num = lv_count - 2.
      lv_temp = ls_stok-alt_malzeme+17(1).
      CONCATENATE 'ALT_MALZEME_' lv_temp INTO lv_fieldname.
      lv_temp = ls_stok-alt_malzeme.
      SHIFT lv_temp LEFT DELETING LEADING '0'.
      me->build_fcat(
           EXPORTING
             iv_col_pos   = lv_count
             iv_fieldname = lv_fieldname
             iv_scrtext_s = lv_temp
             iv_scrtext_m = lv_temp
             iv_scrtext_l = lv_temp
         ).
      lv_count = lv_count + 1.
    ENDLOOP.


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

    DATA(lv_counter) = 1.
    DATA: lv_ana TYPE string.
    DATA lv_div TYPE p.
    DATA(lv_min) = 10000.
    DATA(lv_used) = 1.
    SORT gt_stok BY alt_malzeme.
    DATA lv_ana_mal TYPE matnr.
    DATA lv_stok TYPE p.
    DATA lv_bolen TYPE p.
    DATA lv_res TYPE p.
    DATA: ls_adet TYPE zvkt_mo_t0022,
          lt_adet TYPE TABLE OF zvkt_mo_t0022.

    LOOP AT gt_urun INTO DATA(ls_urun).

      READ TABLE gt_stok  ASSIGNING FIELD-SYMBOL(<lfs_stok>) WITH KEY alt_malzeme = ls_urun-alt_malzeme BINARY SEARCH.


      IF sy-subrc EQ 0.
        DATA(lv_index) = sy-tabix.
        lv_stok = <lfs_stok>-stok_miktari.
        lv_bolen =  ls_urun-alt_malzeme_miktar.

        lv_res = floor( lv_stok / lv_bolen ).
        IF lv_res < lv_min.
          lv_min = lv_res.
        ENDIF.
        ls_adet-ana_malzeme = ls_urun-ana_malzeme.
        ls_adet-adet = lv_res.
        MODIFY zvkt_mo_t0022 FROM ls_adet.

      ENDIF.
    ENDLOOP.
    CLEAR: ls_urun.
    SELECT * FROM zvkt_mo_t0022 INTO TABLE @lt_adet.
    SORT gt_stok.
    LOOP AT gt_urun INTO ls_urun.
      IF lv_ana_mal <> ls_urun-ana_malzeme.
        lv_counter = 1.
        lv_ana_mal = ls_urun-ana_malzeme.
        APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.
        IF <gfs_table> IS ASSIGNED.
          READ TABLE gt_fcat INDEX lv_counter INTO DATA(ls_fcat).
          ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
          IF <gfs1> IS ASSIGNED.
            lv_ana = ls_urun-ana_malzeme.
            SHIFT lv_ana LEFT DELETING LEADING '0'.
            <gfs1> = lv_ana.
          ENDIF.
          lv_counter = lv_counter + 1.
          READ TABLE lt_adet ASSIGNING FIELD-SYMBOL(<lfs_adet>) WITH KEY ana_malzeme = ls_urun-ana_malzeme.
          READ TABLE gt_fcat INDEX lv_counter INTO ls_fcat.
          ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
          IF <gfs1> IS ASSIGNED.

            <gfs1> = <lfs_adet>-adet.
          ENDIF.

        ENDIF.
      ENDIF.
      lv_counter = lv_counter + 1.
      "      READ TABLE gt_stok TRANSPORTING NO FIELDS WITH KEY alt_malzeme = ls_urun-alt_malzeme BINARY SEARCH.
      "     IF sy-subrc EQ 0.


      DATA(lv_alt_num) = ls_urun-alt_malzeme+17(1).
      CONCATENATE 'ALT_MALZEME_' lv_alt_num INTO DATA(lv_fn).
      READ TABLE gt_fcat WITH KEY fieldname = lv_fn INTO ls_fcat .
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
        IF <gfs1> IS ASSIGNED.
          lv_res =  <lfs_adet>-adet * ls_urun-alt_malzeme_miktar .
          <gfs1> = lv_res.
        ENDIF.
      ENDIF.



      "       ENDIF.


    ENDLOOP.


*    READ TABLE gt_fcat INDEX lv_counter INTO ls_fcat.
*    ASSIGN COMPONENT ls_fcat-fieldname OF STRUCTURE <gfs_table> TO <gfs1>.
*    IF <gfs1> IS ASSIGNED.
*      <gfs1> = lv_res.
*    ENDIF.
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

    APPEND gs_fcat TO gt_fcat.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0026_CLS
*&---------------------------------------------------------------------*
CLASS lcl_tarih DEFINITION.
  PUBLIC SECTION.
    TYPES BEGIN OF gty_alv.
    TYPES day TYPE string.
    TYPES END OF gty_alv.

    DATA: gv_month     TYPE char2,
          gv_day_count TYPE int4,
          gv_day       TYPE scal-indicator,
          gt_alv       TYPE TABLE OF gty_alv.


    METHODS:
      find_month,
      get_day,
      set_fcat,
      display,
      set_layout,
      build_alv,
      build_fcat IMPORTING iv_col_pos   TYPE lvc_colpos
                           iv_fieldname TYPE lvc_fname
                           iv_scrtext_s TYPE string
                           iv_scrtext_m TYPE string
                           iv_scrtext_l TYPE string
                           iv_weekend   TYPE int1.
ENDCLASS.

CLASS lcl_tarih IMPLEMENTATION.
  METHOD find_month.
    gv_month = p_month+4(2).
    DATA(lv_year) = p_month(4).

  ENDMETHOD.
  METHOD get_day.
    DATA lv_initial_date TYPE p0001-begda.
    DATA lv_temp_date TYPE p0001-begda.
    DATA lv_temp TYPE string.
    DATA lv_temp2 TYPE string.
    DATA lv_result TYPE gty_alv.
    DATA: lv_day TYPE c.
    DATA: lv_last_day TYPE datum.
    DATA: lv_col_pos TYPE lvc_colpos.
    lv_temp = p_month.

    CONCATENATE lv_temp '01' INTO lv_temp2.
    lv_initial_date = lv_temp2.
    lv_temp_date = lv_initial_date.

    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = lv_initial_date
      IMPORTING
        last_day_of_month = lv_last_day
*     EXCEPTIONS
*       DAY_IN_NO_DATE    = 1
*       OTHERS            = 2
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    lv_col_pos = 1.
    gv_day_count = lv_last_day+6(2).

    DATA: lv_month(10) TYPE c.
    SELECT SINGLE ltx FROM t247
    INTO @lv_month
    WHERE spras = 'EN'
    AND mnr = @p_month+4(2). "==> month.

    DO ( gv_day_count - 1 ) TIMES.

      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date   = lv_temp_date
        IMPORTING
          day    = lv_day
        EXCEPTIONS
          OTHERS = 8.

      CASE lv_day.
        WHEN 1.
          lv_result-day = 'Monday'.
        WHEN 2.
          lv_result-day = 'Tuesday'.
        WHEN 3.
          lv_result-day = 'Wednesday'.
        WHEN 4.
          lv_result-day = 'Thursday'.
        WHEN 5.
          lv_result-day = 'Friday'.
        WHEN 6.
          lv_result-day = 'Saturday'.
          "          lv_result-color = 1.
        WHEN 7.
          lv_result-day = 'Sunday'.
          "          lv_result-color = 1.

      ENDCASE.

*      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*        EXPORTING
*          date      = lv_initial_date
*          days      = 1
*          months    = 0
*          signum    = '+'
*          years     = 0
*        IMPORTING
*          calc_date = lv_temp_date.

*      DATA: lv_field   TYPE char30,
*            lv_field_s TYPE char10,
*            lv_field_m TYPE char20,
*            lv_field_l TYPE char40.

      DATA: lv_field   TYPE string,
            lv_field_s TYPE string,
            lv_field_m TYPE string,
            lv_field_l TYPE string.
*lv_field = lv_temp_date.

      CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
        EXPORTING
          date_internal = lv_temp_date
        IMPORTING
          date_external = lv_field
* EXCEPTIONS
*         DATE_INTERNAL_IS_INVALID       = 1
*         OTHERS        = 2
        .
      DATA: lv_conv TYPE char30.
      lv_conv = lv_field(2).



      CONCATENATE lv_conv space lv_month INTO DATA(lv_fname) SEPARATED BY space.
      CONCATENATE lv_conv space lv_month(3) INTO DATA(lv_fname_s) SEPARATED BY space.

      lv_field_s = lv_fname_s.
      lv_field_m = lv_fname.
      lv_field_l = lv_fname.

      IF lv_day = 6 OR lv_day = 7 .
        me->build_fcat(
          EXPORTING
                  iv_col_pos   = lv_col_pos
                  iv_fieldname = lv_conv
                  iv_scrtext_s = lv_field_s
                  iv_scrtext_m = lv_field_m
                  iv_scrtext_l = lv_field_l
                  iv_weekend = 1
        ).
      ELSE.
        me->build_fcat(
          EXPORTING
            iv_col_pos   = lv_col_pos
            iv_fieldname = lv_conv
            iv_scrtext_s = lv_field_s
            iv_scrtext_m = lv_field_m
            iv_scrtext_l = lv_field_l
            iv_weekend = 0
        ).

      ENDIF.
      lv_temp_date = lv_temp_date + 1.
      lv_col_pos = lv_col_pos + 1.
      APPEND lv_result TO gt_alv.
    ENDDO.
  ENDMETHOD.

  METHOD set_fcat .
    DATA: lv_count     TYPE int4 VALUE 2,
          lv_fieldname TYPE string,
          lv_ilkodu    TYPE string,
          lv_text      TYPE string.

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

    CASE iv_weekend.
      WHEN 1.
        gs_fcat-emphasize =  'C300'.
    ENDCASE.


    .
    APPEND gs_fcat TO gt_fcat.

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
    gs_layout-cwidth_opt = 'X'.
    gs_layout-zebra = 'X'.
    gs_layout-ctab_fname = 'CELL_COLOR'.
  ENDMETHOD.

  METHOD build_alv.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat     " Field Catalog
      IMPORTING
        ep_table        = gt_table.   " Pointer to Dynamic Data Table

    ASSIGN gt_table->* TO <dyn_table>.
    CREATE DATA gs_table LIKE LINE OF <dyn_table>.
    ASSIGN gs_table->* TO <gfs_table>.

    DATA(lv_counter) = 1.
    DATA(lv_max) = lines( gt_alv ).
    WHILE lv_counter <= lv_max.
      DATA lv_temp TYPE string.
      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.
      LOOP AT gt_alv INTO DATA(gs_alv).
        IF <gfs_table> IS ASSIGNED.
          READ TABLE gt_fcat INDEX lv_counter INTO DATA(ls_fcat).

          lv_temp = ls_fcat-fieldname.
          ASSIGN COMPONENT lv_temp OF STRUCTURE <gfs_table> TO <gfs1>.
          IF <gfs1> IS ASSIGNED.
            <gfs1> = gs_alv-day.
            lv_counter = lv_counter + 1.
          ENDIF.

        ENDIF.



      ENDLOOP.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.

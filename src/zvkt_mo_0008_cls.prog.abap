*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0008_CLS
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.

    METHODS handle_top_of_page
          FOR EVENT top_of_page OF cl_gui_alv_grid
      IMPORTING
          e_dyndoc_id
          table_index.

    METHODS handle_hotspot_click
          FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
          e_row_id
          e_column_id.

    METHODS handle_double_click
          FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
          e_row
          e_column
          es_row_no.

    METHODS handle_data_changed
          FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
          er_data_changed
          e_onf4
          e_onf4_before
          e_onf4_after
          e_ucomm.

    METHODS handle_onf4
          FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING
          e_fieldname
          e_fieldvalue
          es_row_no
          er_event_data
          et_bad_cells
          e_display.

ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_top_of_page.
    DATA: lv_text TYPE sdydo_text_element.

    lv_text = 'FLIGHT_DETAILS'.

    CALL METHOD go_docu->add_text
      EXPORTING
        text      = lv_text   " Single Text, Up To 255 Characters Long
        sap_style = cl_dd_document=>heading.   " Recommended Styles

    CALL METHOD go_docu->new_line.

    CLEAR: lv_text.

    CONCATENATE: 'User: ' sy-uname INTO lv_text SEPARATED BY space.

    CALL METHOD go_docu->add_text
      EXPORTING
        text         = lv_text  " Single Text, Up To 255 Characters Long
        sap_color    = cl_dd_document=>list_positive  " Not Release 99
        sap_fontsize = cl_dd_document=>medium.  " Recommended Font Sizes

    CALL METHOD go_docu->display_document
      EXPORTING
        parent = go_sub1.    " Contain Object Already Exists


  ENDMETHOD.                    "handle top of page

  METHOD handle_hotspot_click.
    BREAK-POINT.
  ENDMETHOD.                    "handle top of page

  METHOD handle_double_click.
    BREAK-POINT.
  ENDMETHOD.                    "handle top of page

  METHOD handle_data_changed.
    BREAK-POINT.
  ENDMETHOD.                    "handle top of page

  METHOD handle_onf4.
    BREAK-POINT.
  ENDMETHOD.                    "handle top of page
ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0006_CLS
*&---------------------------------------------------------------------*
CLASS lcl_ooalv DEFINITION.
  PUBLIC SECTION.

    DATA: gs_sbook TYPE sbook,
          gt_sbook TYPE TABLE OF sbook.

    DATA:gt_fcat   TYPE lvc_t_fcat,
         gs_fcat   TYPE lvc_s_fcat,
         gs_layout TYPE lvc_s_layo.

    DATA: go_alv TYPE REF TO cl_gui_alv_grid.
    DATA: go_cont TYPE REF TO cl_gui_custom_container.
    METHODS: get_data,
      set_fcat,
      set_layout,
      display_alv_full,
      display_alv_cont.



ENDCLASS.

CLASS lcl_ooalv IMPLEMENTATION.

  METHOD get_data.
    SELECT *
      FROM sbook
      WHERE fldate EQ @p_date
      INTO TABLE @gt_sbook.

  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = gv_tabname
      CHANGING
        ct_fieldcat      = gt_fcat
*     EXCEPTIONS
*       INCONSISTENT_INTERFACE       = 1
*       PROGRAM_ERROR    = 2
*       OTHERS           = 3
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

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
        it_outtab       = gt_sbook  " Output Table
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
        it_outtab       = gt_sbook  " Output Table
        it_fieldcatalog = gt_fcat.  " Field Catalog

    IF sy-subrc <> 0.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

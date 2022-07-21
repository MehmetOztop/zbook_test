*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0014_TOP
*&---------------------------------------------------------------------*
CLASS lcl_alv DEFINITION DEFERRED.
TABLES: sscrfields.

DATA: gt_table TYPE TABLE OF zvkt_mo_t0001,
      gs_table TYPE zvkt_mo_t0001,
      go_alv   TYPE REF TO cl_gui_alv_grid,
      go_cont  TYPE REF TO cl_gui_custom_container.

*TYPES: BEGIN OF gty_list,
*         uc_id  TYPE zvkt_de_id,
*         kalkis TYPE zvkt_de_kal,
*         varis  TYPE zvkt_de_var,
*         tarih  TYPE zvkt_de_tar,
*         sinif  TYPE zvkt_de_sin,
*       END OF gty_list.
*
*DATA: gt_list type TABLE OF gty_list.

DATA: gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   TYPE lvc_s_fcat,
      gs_layout TYPE lvc_s_layo.

DATA: go_oo_alv TYPE REF TO lcl_alv.

DATA: "gt_title TYPE zem_str01_t,
      "gs_title LIKE LINE OF gt_title
      gv_title TYPE char35.

DATA: gs_sel_button TYPE smp_dyntxt.

PARAMETERS: p_file TYPE localfile.

SELECTION-SCREEN FUNCTION KEY 1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.



AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM download.


  ENDCASE.

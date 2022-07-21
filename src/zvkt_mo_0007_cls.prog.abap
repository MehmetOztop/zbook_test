*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0007_CLS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
*  CREATE OBJECT go_cont
*    EXPORTING
*      container_name = 'CC_ALV'.


  CREATE OBJECT go_alv
    EXPORTING
      i_parent = cl_gui_container=>screen0.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR'   " Internal Output Table Structure Name
    CHANGING
      it_outtab        = gt_table.   " Output Table
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT * FROM scarr
    INTO TABLE @gt_table.
ENDFORM.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0008_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT * FROM sbook
    INTO TABLE @gt_table.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CREATE OBJECT go_cont
    EXPORTING
      container_name = 'ALV_CC'.





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

  CALL METHOD go_split->get_container
    EXPORTING
      row       = 2 " Row
      column    = 1 " Column
    RECEIVING
      container = go_sub2.  " Container

  CALL METHOD go_split->set_row_height
    EXPORTING
      id     = 1   " Row ID
      height = 15.    " Height

  CREATE OBJECT go_docu
    EXPORTING
      style = 'ALV_GRID'.     "



  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_sub2.   " Parent Container

  CREATE OBJECT go_event_receiver.

  SET HANDLER go_event_receiver->handle_top_of_page FOR go_alv.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'   " Internal Output Table Structure Name
    CHANGING
      it_outtab        = gt_table.   " Output Table

  CALL METHOD go_alv->list_processing_events
    EXPORTING
      i_event_name = 'TOP_OF_PAGE'   " Event Name List Processing
      i_dyndoc_id  = go_docu.    " Dynamic Document


ENDFORM.

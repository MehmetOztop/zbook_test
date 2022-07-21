*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0034
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0034.

DATA: dockingbottom TYPE REF TO cl_gui_docking_container,
      html_viewer   TYPE REF TO cl_gui_html_viewer,
      repid         TYPE syrepid.
DATA v_url TYPE bapibds01-uri.

PARAMETERS: p_check TYPE c,
            p_rad1  RADIOBUTTON GROUP grp1 DEFAULT 'X',
            p_rad2  RADIOBUTTON GROUP grp1,
            p_rad3  RADIOBUTTON GROUP grp1.

START-OF-SELECTION.

AT SELECTION-SCREEN OUTPUT.


  repid = sy-repid.

  CHECK dockingbottom IS INITIAL.

  CREATE OBJECT dockingbottom
    EXPORTING
      repid     = repid
      dynnr     = sy-dynnr
      side      = dockingbottom->dock_at_bottom
      extension = 300.

  CREATE OBJECT html_viewer
    EXPORTING
      parent = dockingbottom.


* This document_id is the document upload via transaction SMW0 as
* an HTML template
  html_viewer->load_html_document(
     EXPORTING  document_id  = 'HTMLCNTL_CNHTTST1_START'
     IMPORTING  assigned_url = v_url ).

  html_viewer->show_url( EXPORTING url = v_url ).

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0017_MDL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
  go_report->prepare_alv( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CLEAR: gv_error.
  CASE sy-ucomm.
    WHEN '&F2' OR '&F3'.
      LEAVE TO SCREEN 0.
    WHEN '&F4'.
      LEAVE PROGRAM.
    WHEN '&F5'.
      IF go_report IS NOT INITIAL.
        go_report->get_data( ).
        go_report->refresh_alv_2( ).
      ENDIF.
    WHEN '&F6'.
      go_report->print_adobe( ).
    WHEN '&F12'.
      go_report->save_not( ).
    WHEN '&F7'.
      go_report->print_smart( ).
    WHEN '&F11'.
      go_report->down_excel( ).
    WHEN '&F8'.
      go_report->send_mail( ).
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

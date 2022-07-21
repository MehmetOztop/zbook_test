*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0027_MDL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  LOOP AT SCREEN .
    IF gv_account LT 50.
      IF screen-group1 EQ 'G1'.
*        screen-active = 0.
*        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ELSE.
      IF screen-group1 EQ 'G1'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&F3' OR '&F4'.
      LEAVE TO SCREEN 0.
    WHEN '&F5'.
      LEAVE PROGRAM.
    WHEN '&CEK'.

      CLEAR: gt_number,
             gt_number2,
             gs_number,
             gs_number2.
      go_six->check_input( ).

    WHEN '&ADD'.
      IF gv_add IS NOT INITIAL.

        CALL SCREEN 0200 STARTING AT 10 05
                         ENDING AT 70 15.
      ELSE.
        MESSAGE s004(zzy_0001) DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER'.
      DATA: lv_length  TYPE i,
            lv_length2 TYPE i.
*      DATA(lv_cart_num) = gv_cnum.
*      DATA(lv_cvv) = gv_ccv.
      SHIFT gv_cnum LEFT DELETING LEADING '0'.


      lv_length = strlen( gv_cnum ).
      lv_length2 = strlen( gv_ccv ).
      IF lv_length = 16 AND lv_length2 = 3.
        gv_account = gv_account + gv_add.
        LEAVE TO SCREEN 0.
      ELSE.
        MESSAGE s004(zzy_0001) DISPLAY LIKE 'W'.
        EXIT.
      ENDIF.

*      CLEAR: gv_cnum,
*           gv_ccv.
*      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      CLEAR: gv_cnum,
             gv_ccv.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

MODULE status_0300 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE sy-ucomm.
    WHEN '&F3' OR '&F4'.
      LEAVE TO SCREEN 0.
    WHEN '&F5'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

AT SELECTION-SCREEN OUTPUT. "pbo of screen 1000
  LOOP AT SCREEN.
    IF rb_satin EQ 'X'.
      IF screen-group1 EQ 'SID' OR screen-group1 EQ 'HID'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 EQ 'BID'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.

    ELSEIF rb_cek EQ 'X'.
      IF screen-group1 EQ 'HID'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 EQ 'SID' OR screen-group1 EQ 'BID'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.

    ELSEIF rb_loto EQ 'X'.
      IF screen-group1 EQ 'HID' OR screen-group1 EQ 'SID' OR screen-group1 EQ 'BID'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.

      ENDIF.

    ELSEIF rb_bilet EQ 'X'.
      IF screen-group1 EQ 'SID' OR screen-group1 EQ 'HID'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.


    ENDIF.

  ENDLOOP.

AT SELECTION-SCREEN. "pai of screen 1000
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

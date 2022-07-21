*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0014_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE PROGRAM.
    WHEN '&DOWN'.
*      gs_title-reptext = 'Uçuş Bilgileri'.
*      APPEND gs_title TO gt_title.
      gv_title = 'Uçuş Bilgileri'.
      CALL FUNCTION 'ZMO_OLE_EXCEL_DOWNLOAD'
        EXPORTING
          iv_subject = 'Sayfa'
          it_data    = gt_table
*         IT_TITLE   =
*         IT_COMPONENTS       =
          iv_italic  = 1
          iv_title   = gv_title.

  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0025.

INCLUDE: zvkt_mo_0025_top,
         zvkt_mo_0025_cls,
         zvkt_mo_0025_mdl.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF rb_yeni EQ 'X'.
      IF screen-group1 EQ 'LID'.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.

    ELSEIF rb_liste EQ 'X'.
      IF screen-group1 EQ 'LID'.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.

    ENDIF.

  ENDLOOP.


AT SELECTION-SCREEN.

  go_personel = NEW lcl_personel( ).
  CASE sscrfields.
    WHEN 'BUT1'.
      IF rb_yeni EQ 'X'.
        go_personel->get_register( ).

      ELSEIF rb_liste EQ 'X'.
        go_personel->get_report( ).
      ENDIF.
  ENDCASE.

INITIALIZATION.
  button1 = 'Çalıştır'.

START-OF-SELECTION.

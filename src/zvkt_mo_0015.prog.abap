*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0015.

INCLUDE: zvkt_mo_0015_top,
         zvkt_mo_0015_cls,
         zvkt_mo_0015_mdl.

START-OF-SELECTION.

  go_report = NEW lcl_report( ).
  go_report->start_of_selection( ).

  IF gt_output IS NOT INITIAL.
    CALL SCREEN 0100.
  ELSE.
    MESSAGE s001(zzy_0001) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

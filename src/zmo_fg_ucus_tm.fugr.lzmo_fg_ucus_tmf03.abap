*----------------------------------------------------------------------*
***INCLUDE LZMO_FG_UCUS_TMF03.
*----------------------------------------------------------------------*
FORM kontrol.
  DATA: lv_date TYPE datum.
  lv_date = sy-datum.
  IF zvkt_mo_t0001-tarih > sy-datum.
    MESSAGE 'Gelecekten uçuş kaydı olamaz!' TYPE 'E' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

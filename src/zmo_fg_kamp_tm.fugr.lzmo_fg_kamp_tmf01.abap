*----------------------------------------------------------------------*
***INCLUDE LZMO_FG_KAMP_TMF01.
*----------------------------------------------------------------------*
FORM kontrol.

  "DATA: gt_dolu_malzeme TYPE TABLE OF matnr.

  SELECT SINGLE t1~kampanya_tanim FROM zvkt_mo_t0018 AS t1
    WHERE kampanya_id EQ @zvkt_mo_t0019-kampanya_id
    INTO @DATA(lv_tanim).
  IF sy-subrc EQ 0.
    zvkt_mo_t0019-kampanya_tanim = lv_tanim.
  ELSE.
*    MESSAGE 'Böyle bir kampanya yok!' TYPE 'E' DISPLAY LIKE 'E'.
*    RETURN.
  ENDIF.

*chain.
*fields: zvkt_mo_t0019-baslangic_tarihi, zvkt_mo_t0019-bitis_tarihi.
*module xx.
*endchain.
  IF zvkt_mo_t0019-baslangic_tarihi IS INITIAL OR zvkt_mo_t0019-bitis_tarihi IS INITIAL.
    MESSAGE 'Başlangıç veya bitiş tarihi boş olamaz' TYPE 'S' DISPLAY LIKE 'E'.
    vim_abort_saving = 'X'.
    LEAVE TO SCREEN 0.
  ENDIF.

  IF zvkt_mo_t0019-baslangic_tarihi >= zvkt_mo_t0019-bitis_tarihi.
    MESSAGE 'Bitiş tarihi başlangıç tarihinden büyük olmalı' TYPE 'E' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  SELECT malzeme_no, bitis_tarihi FROM zvkt_mo_t0019 INTO TABLE @DATA(gt_dolu_malzeme).

  READ TABLE gt_dolu_malzeme INTO DATA(gs_dolu_malzeme) WITH KEY zvkt_mo_t0019-malzeme_no.
  IF sy-subrc EQ 0.
    IF gs_dolu_malzeme-bitis_tarihi >= zvkt_mo_t0019-baslangic_tarihi.
      MESSAGE 'Bu malzeme için bitmemiş bir kampanya mevcut' TYPE 'E' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDIF.


ENDFORM.

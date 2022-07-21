FUNCTION zmehmeto_f0002.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_NUM) TYPE  INT4
*"  EXPORTING
*"     VALUE(EV_PRIME) TYPE  INT1
*"     VALUE(EV_EVEN) TYPE  INT2
*"     VALUE(EV_PERFECT) TYPE  INT2
*"----------------------------------------------------------------------

  DATA: lv_check  TYPE int2 VALUE 2.
  DATA: lt_denom TYPE TABLE OF int2.
  IF iv_num MOD 2 EQ 0.
    ev_even = 1.
  ELSE.
    ev_even = 0.
  ENDIF.
  ev_perfect = 0.
  ev_prime = 1.
  APPEND 1 TO lt_denom.
  WHILE lv_check <= iv_num / 2 .
    IF ( iv_num MOD lv_check ) EQ 0.
      APPEND lv_check TO lt_denom.
      ev_prime = 0.

    ENDIF.
    lv_check = lv_check + 1.

  ENDWHILE.
  DATA: lv_total_denom TYPE int4.
  lv_total_denom = 0.

  LOOP AT lt_denom INTO DATA(ls_denom).
    lv_total_denom = lv_total_denom + ls_denom.
  ENDLOOP.
  IF lv_total_denom EQ iv_num.
    ev_perfect = 1.
  ENDIF.

ENDFUNCTION.

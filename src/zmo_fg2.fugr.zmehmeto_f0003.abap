FUNCTION zmehmeto_f0003.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_NUMBERS) TYPE  ZVKT_MO_TT0002
*"  EXPORTING
*"     REFERENCE(EV_FLAG) TYPE  INT1
*"----------------------------------------------------------------------
  DATA: lv_even  TYPE int1,
        lv_odd   TYPE int1,
        lv_prime TYPE int1 VALUE 0.
*  DATA: lv_check  TYPE int2 VALUE 2.
  DATA: lt_any_prime TYPE TABLE OF int1.

  LOOP AT it_numbers INTO DATA(is_numbers).
    IF is_numbers-znumber MOD 2 EQ 0.
      lv_even = 1.
    ELSE.
      lv_odd = 1.

    ENDIF.
    CALL FUNCTION 'ZMEHMETO_F0002'
      EXPORTING
        iv_num   = is_numbers-znumber
      IMPORTING
        ev_prime = lv_prime
*       EV_EVEN  =
*       EV_PERFECT       =
      .
    APPEND lv_prime TO lt_any_prime.

  ENDLOOP.
  LOOP AT lt_any_prime INTO DATA(ls_any_prime).
    IF ls_any_prime = 1.
      lv_prime = 1.
    ENDIF.
  ENDLOOP.
  IF lv_even = 1 AND lv_odd = 1 AND lv_prime = 1.
    ev_flag = 1.
  ELSE.
    ev_flag = 0.
  ENDIF.




ENDFUNCTION.

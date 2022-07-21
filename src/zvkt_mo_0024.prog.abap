*&---------------------------------------------------------------------*
*& Report zvkt_mo_0024
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0024.

*SELECT lifnr
*&& '(WOKEGE' && name1 && ')' AS vendor,
*ort01 AS city
*FROM lfa1
*INTO TABLE @DATA(lt_bp_data)
*UP TO 100 ROWS.
*IF sy-subrc = 0.
*  cl_demo_output=>display_data(
*  EXPORTING
*  value = lt_bp_data
*  name = 'New AGE SQL : 6' ).
*ENDIF.

*SELECT SINGLE @abap_true
*FROM mara
*INTO @DATA(lv_exists)
*WHERE mtart = 'HALB'.
*IF lv_exists = abap_true.
*  WRITE:/ 'Data Exists!! New AGE SQL : 7'.
*ENDIF.

DATA: lv_even    TYPE int2,
      lv_prime   TYPE int2,
      lv_perfect TYPE int2.

CALL FUNCTION 'ZMEHMETO_F0002'
  EXPORTING
    iv_num     = 6
  IMPORTING
    ev_prime   = lv_prime
    ev_even    = lv_even
    ev_perfect = lv_perfect.

WRITE: lv_prime  .
WRITE: lv_even.
WRITE: lv_perfect.

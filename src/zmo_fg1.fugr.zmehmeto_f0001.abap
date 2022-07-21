FUNCTION zmehmeto_f0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  VBELN
*"  EXPORTING
*"     VALUE(ES_DETAIL) TYPE  VBAK
*"----------------------------------------------------------------------

  DATA lv_vbeln TYPE vbeln.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_vbeln
    IMPORTING
      output = lv_vbeln.

  SELECT SINGLE * FROM vbak
    INTO @es_detail
    WHERE vbeln EQ @lv_vbeln.


ENDFUNCTION.

*&---------------------------------------------------------------------*
*& Report zvkt_mo_0023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0023.

*START-OF-SELECTION.
*  SELECT SINGLE * FROM vbak
*  INTO @DATA(lt_vbak).
*
*  WRITE:/ 'X O X O X O X O X O X O'.

TYPES: BEGIN OF ty_ekpo,
         ebeln    TYPE ebeln,
         ebelp    TYPE ebelp,
         werks    TYPE ewerk,
         netpr    TYPE bprei,
         pur_type TYPE char14,
       END OF ty_ekpo.

DATA: it_ekpo TYPE STANDARD TABLE OF ty_ekpo.

*FIELD-SYMBOLS <fs_ekpo> TYPE ty_ekpo.

SELECT ebeln ebelp werks netpr
FROM ekpo
INTO TABLE it_ekpo.

LOOP AT it_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

  IF <fs_ekpo>-netpr GT 299.
    <fs_ekpo>-pur_type = 'High Purchase'.
  ELSE.
    <fs_ekpo>-pur_type = 'Low Purchase'.
  ENDIF.

ENDLOOP.

IF it_ekpo IS NOT INITIAL.
  cl_demo_output=>display_data(
  EXPORTING
  value = it_ekpo
  name = 'Old AGE SQL : 1' ).
ENDIF.

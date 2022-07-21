*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0021_CLS
*&---------------------------------------------------------------------*
CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
  METHODS: calc IMPORTING iv_num1 TYPE int4
                          iv_num2 TYPE int4
                EXPORTING ev_sum  TYPE int8.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD calc.
    ev_sum = iv_num1 + iv_num2.
  ENDMETHOD.
ENDCLASS.

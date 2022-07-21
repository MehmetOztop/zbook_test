*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0018.

DATA : lr_proxy TYPE REF TO zpre_co_calculator_soap,
       input    TYPE zpre_add_soap_in,
       output   TYPE zpre_add_soap_out.

input-int_a = 10.
input-int_b = 5.

CREATE OBJECT lr_proxy
  EXPORTING
    logical_port_name = 'ZPORT_CALC'.

CALL METHOD lr_proxy->add
  EXPORTING
    input  = input
  IMPORTING
    output = output.

DATA(lv_add) = 'ADD METHOD => ' && output-add_result.


TRY.
    CLEAR output.
    CALL METHOD lr_proxy->divide
      EXPORTING
        input  = input
      IMPORTING
        output = output.
  CATCH cx_ai_system_fault.    "
ENDTRY.

DATA(lv_divide) = 'DIVIDE METHOD => ' && output-add_result.


CALL METHOD lr_proxy->subtract
  EXPORTING
    input  = input
  IMPORTING
    output = output.

DATA(lv_substract) = 'SUBTRACT METHOD => ' && output-add_result.

CLEAR output.
CALL METHOD lr_proxy->multiply
  EXPORTING
    input  = input
  IMPORTING
    output = output.

DATA(lv_multiply) = 'MULTIPLY METHOD => ' && output-add_result.

DATA(numbers) = 'Sayılarımız :(' && input-int_a && ')  (' && input-int_b && ')'.
WRITE /: numbers.
WRITE /: lv_add.
WRITE /: lv_divide.
WRITE /: lv_substract.
WRITE /: lv_multiply.

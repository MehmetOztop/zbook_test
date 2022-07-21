class ZCL_ZMEHMET_DDL005 definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMEHMET_DDL005 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZMEHMET_DDL005| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20220418154037.
  endmethod.
ENDCLASS.

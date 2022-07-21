class ZCL_ZODATA_DDL006 definition
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



CLASS ZCL_ZODATA_DDL006 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZODATA_DDL006| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20220413085426.
  endmethod.
ENDCLASS.

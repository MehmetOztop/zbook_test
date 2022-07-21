*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0005_CLS
*&---------------------------------------------------------------------*
CLASS lcl_salv DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF gty_vbak,
             vbeln TYPE vbeln_va,
             erdat TYPE erdat,
             erzet TYPE erzet,
             netwr TYPE netwr_ak,
             waerk TYPE waerk,
             vkorg TYPE vkorg,
           END OF gty_vbak.

    DATA: gt_vbak TYPE TABLE OF gty_vbak,
          gs_vbak TYPE gty_vbak.

    DATA: go_salv TYPE REF TO cl_salv_table.

    METHODS: get_data,
      display_salv.

ENDCLASS.

CLASS lcl_salv IMPLEMENTATION.

  METHOD get_data.
    SELECT vbeln,
      erdat,
      erzet,
      netwr,
      waerk,
      vkorg
      FROM vbak
      WHERE vbeln IN @so_vb
       INTO TABLE @gt_vbak.

  ENDMETHOD.
  METHOD display_salv.

    cl_salv_table=>factory(

      IMPORTING
        r_salv_table   =  go_salv   " Basis Class Simple ALV Tables
      CHANGING
        t_table        = gt_vbak
    ).
*    CATCH cx_salv_msg.    "

    go_salv->display( ).

  ENDMETHOD.

ENDCLASS.

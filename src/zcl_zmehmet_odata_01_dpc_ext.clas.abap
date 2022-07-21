class ZCL_ZMEHMET_ODATA_01_DPC_EXT definition
  public
  inheriting from ZCL_ZMEHMET_ODATA_01_DPC
  create public .

public section.
protected section.

  methods HEADERSET_CREATE_ENTITY
    redefinition .
  methods HEADERSET_DELETE_ENTITY
    redefinition .
  methods HEADERSET_GET_ENTITY
    redefinition .
  methods HEADERSET_GET_ENTITYSET
    redefinition .
  methods HEADERSET_UPDATE_ENTITY
    redefinition .
  methods ITEMSET_CREATE_ENTITY
    redefinition .
  methods ITEMSET_GET_ENTITY
    redefinition .
  methods ITEMSET_GET_ENTITYSET
    redefinition .
  methods ITEMSET_UPDATE_ENTITY
    redefinition .
  methods ITEMSET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMEHMET_ODATA_01_DPC_EXT IMPLEMENTATION.


  METHOD headerset_create_entity.
    DATA ls_entity TYPE zvkt_mo_t0004.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zvkt_mo_t0004
        WHERE vbeln = @ls_entity-vbeln
        INTO @DATA(ls_count).
      IF sy-subrc NE 0.
        INSERT zvkt_mo_t0004 FROM ls_entity.

        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.

        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = 'Belge mevcut!'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD headerset_delete_entity.
    DATA lv_vbeln TYPE vbeln_va.
    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'.
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN } |.

    DELETE FROM zvkt_mo_t0004 WHERE vbeln = lv_vbeln.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD headerset_get_entity.
    DATA lv_vbeln TYPE vbeln_va.

    READ TABLE it_key_tab WITH KEY name = 'Vbeln' INTO DATA(ls_key).
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.

    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.

    SELECT SINGLE * FROM zvkt_mo_t0004
      INTO CORRESPONDING FIELDS OF er_entity
      WHERE vbeln = lv_vbeln.
  ENDMETHOD.


  METHOD headerset_get_entityset.

    DATA r_vbeln TYPE RANGE OF vbeln_va.
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Vbeln'.
          MOVE-CORRESPONDING ls_filter-select_options TO r_vbeln.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    SELECT * FROM zvkt_mo_t0004
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE (iv_filter_string).

*    SELECT * FROM ZVKT_MO_T0004
*     INTO TABLE @DATA(lt_item)
*     WHERE ebeln IN @r_ebeln.
  ENDMETHOD.


  METHOD headerset_update_entity.
    DATA ls_entity TYPE zvkt_mo_t0004.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zvkt_mo_t0004
        WHERE vbeln = @ls_entity-vbeln
        INTO @DATA(ls_count).
      IF sy-subrc EQ 0.
        UPDATE zvkt_mo_t0004 FROM ls_entity.

        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.

        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = 'Belge mevcut değil!'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method ITEMSET_CREATE_ENTITY.
  DATA ls_entity TYPE zvkt_mo_t0005.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zvkt_mo_t0005
        WHERE vbeln = @ls_entity-vbeln
        AND posnr = @ls_entity-posnr
        INTO @DATA(ls_count).
      IF sy-subrc NE 0.
        INSERT zvkt_mo_t0005 FROM ls_entity.

        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.

        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = 'Belge mevcut!'.
      ENDIF.
    ENDIF.
  endmethod.


  METHOD itemset_delete_entity.
    DATA: lv_vbeln TYPE vbeln_va,
          lv_posnr TYPE posnr_va.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'.
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab INTO DATA(ls_key2) WITH KEY name = 'Posnr'.
    IF sy-subrc EQ 0.
      lv_posnr = ls_key2-value.
    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN } |.
    lv_posnr = |{ lv_posnr ALPHA = IN } |.

    DELETE FROM zvkt_mo_t0005 WHERE vbeln = lv_vbeln AND posnr = lv_posnr.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.


  method ITEMSET_GET_ENTITY.
 DATA: lv_vbeln TYPE vbeln_va,
      lv_posnr type posnr_va.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Vbeln'  .
    IF sy-subrc EQ 0.
      lv_vbeln = ls_key-value.
    ENDIF.

   READ TABLE it_key_tab INTO DATA(ls_key2) WITH KEY name = 'Posnr'  .
    IF sy-subrc EQ 0.
      lv_posnr = ls_key2-value.
    ENDIF.

    lv_vbeln = |{ lv_vbeln ALPHA = IN }|.
    lv_posnr = |{ lv_posnr ALPHA = IN }|.

    SELECT SINGLE * FROM zvkt_mo_t0005
      INTO CORRESPONDING FIELDS OF er_entity
      WHERE vbeln = lv_vbeln AND posnr = lv_posnr.
  endmethod.


  method ITEMSET_GET_ENTITYSET.
 DATA r_vbeln TYPE RANGE OF vbeln_va.
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Vbeln'.
          MOVE-CORRESPONDING ls_filter-select_options TO r_vbeln.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    SELECT * FROM zvkt_mo_t0005
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE (iv_filter_string).
  endmethod.


  METHOD itemset_update_entity.
    DATA ls_entity TYPE zvkt_mo_t0005.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zvkt_mo_t0005
        WHERE vbeln = @ls_entity-vbeln
        AND posnr = @ls_entity-posnr
        INTO @DATA(ls_count).
      IF sy-subrc EQ 0.
        UPDATE zvkt_mo_t0005 FROM ls_entity.

        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.

        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = 'Belge mevcut değil!'.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

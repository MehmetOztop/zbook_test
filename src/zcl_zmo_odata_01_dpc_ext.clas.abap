class ZCL_ZMO_ODATA_01_DPC_EXT definition
  public
  inheriting from ZCL_ZMO_ODATA_01_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods HEADERSET_CREATE_ENTITY
    redefinition .
  methods HEADERSET_DELETE_ENTITY
    redefinition .
  methods HEADERSET_GET_ENTITY
    redefinition .
  methods HEADERSET_UPDATE_ENTITY
    redefinition .
  methods ITEMSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMO_ODATA_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA ls_entity TYPE zcl_zvkt_odata_03_mpc=>ts_return.
    DATA lv_sayi1 TYPE int1.
    DATA lv_sayi2 TYPE int1.

    IF iv_action_name = 'DemoFuncImport'.
      READ TABLE it_parameter INTO DATA(ls_sayi) WITH KEY name = 'Sayi1'.
      IF sy-subrc EQ 0.
        lv_sayi1 = ls_sayi-value.

      ENDIF.

      READ TABLE it_parameter INTO DATA(ls_sayi2) WITH KEY name = 'Sayi2'.
      IF sy-subrc EQ 0.
        lv_sayi2 = ls_sayi2-value.

      ENDIF.

      IF lv_sayi1 > lv_sayi2.
        ls_entity-message = 'Sayı 1 sayı 2 den daha büyüktür.'.
      ELSEIF lv_sayi1 < lv_sayi2.
        ls_entity-message = 'Sayı 1 sayı 2 den daha küçüktür.'.
      ELSE.
        ls_entity-message = 'İki sayı birbirine eşittir.'.
      ENDIF.

copy_data_to_ref(
  EXPORTING
    is_data = ls_entity
  CHANGING
    cr_data = er_data
).

    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    DATA: ls_header TYPE zodata_s_header,
          ls_item   TYPE zodata_s_item,
          ls_deep   TYPE zodata_deep_001,
          lt_header TYPE TABLE OF zodata_s_header,
          lt_item   TYPE TABLE OF zodata_s_item,
          lt_item_d TYPE TABLE OF zodata_s_item,
          lt_deep   TYPE TABLE OF zodata_deep_001,
          lv_ebeln  TYPE ebeln.

    IF iv_entity_set_name = 'HeaderSet'.
      SELECT *
        FROM zodata_t_header
        WHERE (iv_filter_string)
        INTO TABLE @lt_header.
*      IF sy-subrc EQ 0.
*        SELECT *
*          FROM zodata_t_item
*          FOR ALL ENTRIES IN @lt_header
*          WHERE ebeln = @lt_header-ebeln
*          INTO TABLE @lt_item.
*
*      ENDIF.

      LOOP AT lt_header INTO ls_header.
*        CLEAR lt_item_d.
*        LOOP AT lt_item INTO ls_item WHERE ebeln = ls_header-ebeln.
*          APPEND ls_item TO lt_item_d.
*
*        ENDLOOP.
        ls_deep = VALUE #( ebeln = ls_header-ebeln
                           bsart = ls_header-bsart
                           bukrs = ls_header-bukrs
                           bstyp = ls_header-bstyp
                           kunnr = ls_header-kunnr
                           lifnr = ls_header-lifnr
                           "headertoitemnav = lt_item_d
                           ).

        APPEND ls_deep TO lt_deep.

      ENDLOOP.
      copy_data_to_ref(
        EXPORTING
          is_data = lt_deep
        CHANGING
          cr_data = er_entityset
      ).
    ELSEIF iv_entity_set_name = 'itemSet'.
      READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Ebeln'.
      IF sy-subrc EQ 0.
        lv_ebeln = ls_key-value.

      ENDIF.

      SELECT *
        FROM zodata_t_item
        WHERE ebeln = @lv_ebeln
        INTO TABLE @lt_item.

      copy_data_to_ref(
        EXPORTING
          is_data = lt_item
        CHANGING
          cr_data = er_entityset
      ).

    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA : ls_stream TYPE ty_s_media_resource,
           ls_file   TYPE zvkt_odata_file.
    DATA: lv_filename TYPE char30.

    READ TABLE it_key_tab INTO DATA(ls_key) INDEX 1.
    IF sy-subrc EQ 0.
      lv_filename = ls_key-value.

    ENDIF.

    SELECT SINGLE mimetype, value
      FROM zvkt_odata_file
      WHERE filename = @lv_filename
      INTO (@ls_stream-mime_type, @ls_stream-value).

    copy_data_to_ref(
      EXPORTING
        is_data = ls_stream
      CHANGING
        cr_data = er_stream
    ).

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
    DATA: ls_file TYPE zvkt_odata_file.

    READ TABLE it_key_tab INTO DATA(ls_key) INDEX 1.
    IF sy-subrc EQ 0.
      ls_file-filename = ls_key-value.
      ls_file-sydate = sy-datum.
      ls_file-sytime = sy-uzeit.
      ls_file-mimetype = is_media_resource-mime_type.
      ls_file-value = is_media_resource-value.
      MODIFY zvkt_odata_file FROM ls_file.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.

      ENDIF.


    ENDIF.
  ENDMETHOD.


  METHOD headerset_create_entity.
    DATA ls_entity TYPE zodata_s_header.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zodata_t_header
        WHERE ebeln = @ls_entity-ebeln
        INTO @DATA(ls_count).
      IF sy-subrc NE 0.
        INSERT zodata_t_header FROM ls_entity.

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
    DATA lv_ebeln TYPE ebeln.
    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Ebeln'.
    IF sy-subrc EQ 0.
      lv_ebeln = ls_key-value.

    ENDIF.

    lv_ebeln = |{ lv_ebeln ALPHA = IN }|.

    DELETE FROM zodata_t_header WHERE ebeln = lv_ebeln.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.

    ENDIF.
  ENDMETHOD.


  method HEADERSET_GET_ENTITY.
    DATA lv_ebeln TYPE ebeln.

    READ TABLE it_key_tab INTO DATA(ls_key) WITH KEY name = 'Ebeln'.
    IF sy-subrc EQ 0.
      lv_ebeln = ls_key-value.

    ENDIF.

lv_ebeln = |{ lv_ebeln ALPHA = IN }|.

    SELECT SINGLE * FROM zodata_t_header
      INTO CORRESPONDING FIELDS OF er_entity
      WHERE ebeln = lv_ebeln.
  endmethod.


  METHOD headerset_update_entity.
    DATA ls_entity TYPE zodata_s_header.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data                      = ls_entity
        ).
      CATCH /iwbep/cx_mgw_tech_exception.    "


    ENDTRY.

    IF ls_entity IS NOT INITIAL.
      SELECT COUNT(*)
        FROM zodata_t_header
        WHERE ebeln = @ls_entity-ebeln
        INTO @DATA(ls_count).
      IF sy-subrc EQ 0.
        UPDATE zodata_t_header FROM ls_entity.

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


  METHOD itemset_get_entityset.

    DATA r_ebeln TYPE RANGE OF ebeln.
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Ebeln'.
          MOVE-CORRESPONDING ls_filter-select_options TO r_ebeln.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    SELECT * FROM zodata_t_item
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE (iv_filter_string).

    SELECT * FROM zodata_t_item
     INTO TABLE @DATA(lt_item)
     WHERE ebeln IN @r_ebeln.


  ENDMETHOD.
ENDCLASS.

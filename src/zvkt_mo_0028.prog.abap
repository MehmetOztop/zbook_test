*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0028
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0028.
DATA: gt_table TYPE TABLE OF sflight.

*SELECT * FROM sflight
*  INTO TABLE @gt_table
*  WHERE connid = 0017.
*
*SELECT * FROM sflight
*INTO TABLE @DATA(gt_temp)
*WHERE connid = 0555.
*
*APPEND LINES OF gt_temp TO gt_table.
*
*
*IF gt_table IS NOT INITIAL.
*  SELECT carrid, connid, fldate
*         FROM sflight
*         FOR ALL ENTRIES IN @gt_table
*         WHERE carrid = @gt_table-carrid AND
*               connid = @gt_table-connid
*         ORDER BY PRIMARY KEY
*         INTO TABLE @DATA(result_tab).
*  cl_demo_output=>display( result_tab ).
*ENDIF.
*
*
*SELECT * FROM vbap
*  INTO TABLE @DATA(lt_vbap).
*
*SELECT * FROM vbak
*  INTO TABLE @DATA(lt_vbak).
*
*SORT lt_vbap BY vbeln posnr.
*
*LOOP AT lt_vbak INTO DATA(ls_vbak).
*  READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = ls_vbak-vbeln
*                                                        BINARY SEARCH.
*  IF sy-subrc EQ 0.
*
*    DATA(lv_vbap_index) = sy-tabix.
*    LOOP AT lt_vbap INTO DATA(ls_vbap) FROM lv_vbap_index.
*      IF ls_vbap-vbeln <> ls_vbak-vbeln.
*        EXIT.
*      ENDIF.
*      CONCATENATE ls_vbap-vbeln ls_vbap-posnr INTO DATA(lv_res) SEPARATED BY space.
*      WRITE: lv_res.
*    ENDLOOP.
*  ENDIF.
*
*ENDLOOP.

*DATA wa TYPE scarr.
*
*OPEN CURSOR WITH HOLD @DATA(dbcur) FOR
*  SELECT *
*         FROM scarr.
*
*FETCH NEXT CURSOR @dbcur INTO @wa.
*COMMIT CONNECTION default.
*FETCH NEXT CURSOR @dbcur INTO @wa.
*CLOSE CURSOR @dbcur.
*
*TRY.
*    OPEN CURSOR WITH HOLD @dbcur FOR
*      SELECT *
*             FROM scarr.
*
*    COMMIT WORK.
*    FETCH NEXT CURSOR @dbcur INTO @wa.
*    CLOSE CURSOR @dbcur.
*
*  CATCH cx_sy_open_sql_db.
*    ...
*ENDTRY.

DATA: c1        TYPE cursor,
      lt_vbap   TYPE TABLE OF vbap,
      lt_vbap_2 TYPE TABLE OF vbap,
      ls_vbap   TYPE vbap.


OPEN CURSOR c1 FOR
  SELECT *
   FROM vbap

.
WHILE 0 = 0.
  FETCH NEXT CURSOR c1 INTO CORRESPONDING FIELDS OF TABLE lt_vbap
                      PACKAGE SIZE 10000.
  IF sy-subrc <> 0.
    FETCH NEXT CURSOR c1 INTO CORRESPONDING FIELDS OF TABLE lt_vbap_2
                    PACKAGE SIZE 10000.
    EXIT.
  ENDIF.

  LOOP AT lt_vbap INTO ls_vbap.
*    MOVE-CORRESPONDING ls_acdoca TO gs_belge.
*    MOVE-CORRESPONDING ls_acdoca TO gs_matnr_list.
*
*    IF ls_acdoca-racct(3) = '621'.
*      COLLECT gs_belge INTO gt_621.
*    ENDIF.
*
*    gs_belge-hsl = ls_acdoca-hsl * -1.
*    gs_belge-msl = ls_acdoca-msl * -1.
*
*    COLLECT gs_matnr_list INTO gt_matnr_list.
*    IF ls_acdoca-racct(3) = '600'.
*      COLLECT gs_belge INTO gt_600.
*      IF gs_belge-budat GE lv_fromay.
*        gv_tot_ay_ciro = gv_tot_ay_ciro + gs_belge-hsl.
*      ENDIF.
*    ENDIF.
*    IF ls_acdoca-racct IN r_brut.
*      COLLECT gs_belge INTO gt_brut.
*    ENDIF.
*    IF ls_acdoca-racct IN r_indrm.
*      COLLECT gs_belge INTO gt_indrm.
*    ENDIF.
*    IF ls_acdoca-racct IN r_iade.
*      COLLECT gs_belge INTO gt_iade.
*    ENDIF.
*    IF ls_acdoca-racct IN r_smm.
*      COLLECT gs_belge INTO gt_smm.
*    ENDIF.
*    IF ls_acdoca-racct IN r_td.
*      COLLECT gs_belge INTO gt_td.
*    ENDIF.
*    IF ls_acdoca-racct IN r_fire.
*      COLLECT gs_belge INTO gt_fire.
*    ENDIF.
  ENDLOOP.

ENDWHILE.

*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0013.

DATA: gt_table TYPE TABLE OF zvkt_mo_t0001,
      gs_table TYPE zvkt_mo_t0001.

gs_table-uc_id = '1111111111'.
gs_table-kalkis = 'İstanbul'.
gs_table-varis = 'Atina'.
gs_table-tarih = '20210324'.
gs_table-sinif = 'E'.

APPEND gs_table TO gt_table.

gs_table-uc_id = '1111111112'.
gs_table-kalkis = 'Berlin'.
gs_table-varis = 'Paris'.
gs_table-tarih = '20220110'.
gs_table-sinif = 'B'.
APPEND gs_table TO gt_table.
gs_table-uc_id = '1111111113'.
gs_table-kalkis = 'Los Angeles'.
gs_table-varis = 'Roma'.
gs_table-tarih = '20200902'.
gs_table-sinif = 'B'.
APPEND gs_table TO gt_table.
gs_table-uc_id = '1111111114'.
gs_table-kalkis = 'New York'.
gs_table-varis = 'Ankara'.
gs_table-tarih = '20220310'.
gs_table-sinif = 'E'.
APPEND gs_table TO gt_table.
gs_table-uc_id = '1111111115'.
gs_table-kalkis = 'Köln'.
gs_table-varis = 'Venedik'.
gs_table-tarih = '20191110'.
gs_table-sinif = 'E'.
APPEND gs_table TO gt_table.

INSERT zvkt_mo_t0001 FROM TABLE @gt_table.

IF sy-subrc EQ 0.
  COMMIT WORK AND WAIT.
ELSE.
  ROLLBACK WORK.
ENDIF.

*&---------------------------------------------------------------------*
*& Include          ZVKT_MO_0002_TOP
*&---------------------------------------------------------------------*
TABLES: sbook.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_cid type sbook-carrid.
SELECTION-SCREEN : END OF BLOCK b1.

TYPES: BEGIN OF gty_table,
         carrid   TYPE s_carr_id,
         connid   TYPE s_conn_id,
         fldate   TYPE s_date,
         bookid   TYPE s_book_id,
         customid TYPE s_book_id,
         custtype TYPE s_custtype,
         class    TYPE s_class,
       END OF gty_table.
DATA: gs_table    TYPE gty_table,
      gt_table    TYPE TABLE OF gty_table,
      gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

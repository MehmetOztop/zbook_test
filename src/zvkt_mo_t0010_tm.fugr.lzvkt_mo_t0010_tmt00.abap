*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0010...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0010                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0010                 .
CONTROLS: TCTRL_ZVKT_MO_T0010
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0010                 .
TABLES: ZVKT_MO_T0010                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0001...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0001                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0001                 .
CONTROLS: TCTRL_ZVKT_MO_T0001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0001                 .
TABLES: ZVKT_MO_T0001                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

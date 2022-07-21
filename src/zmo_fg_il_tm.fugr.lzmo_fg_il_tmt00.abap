*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0013...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0013                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0013                 .
CONTROLS: TCTRL_ZVKT_MO_T0013
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZVKT_MO_T0014...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0014                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0014                 .
CONTROLS: TCTRL_ZVKT_MO_T0014
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZVKT_MO_T0015...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0015                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0015                 .
CONTROLS: TCTRL_ZVKT_MO_T0015
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0013                 .
TABLES: *ZVKT_MO_T0014                 .
TABLES: *ZVKT_MO_T0015                 .
TABLES: ZVKT_MO_T0013                  .
TABLES: ZVKT_MO_T0014                  .
TABLES: ZVKT_MO_T0015                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

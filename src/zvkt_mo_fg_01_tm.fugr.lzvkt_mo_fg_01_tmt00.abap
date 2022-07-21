*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0007...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0007                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0007                 .
CONTROLS: TCTRL_ZVKT_MO_T0007
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZVKT_MO_T0008...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0008                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0008                 .
CONTROLS: TCTRL_ZVKT_MO_T0008
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0007                 .
TABLES: *ZVKT_MO_T0008                 .
TABLES: ZVKT_MO_T0007                  .
TABLES: ZVKT_MO_T0008                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

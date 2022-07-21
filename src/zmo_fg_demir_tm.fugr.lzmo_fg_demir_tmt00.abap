*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0016...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0016                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0016                 .
CONTROLS: TCTRL_ZVKT_MO_T0016
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0016                 .
TABLES: ZVKT_MO_T0016                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0020...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0020                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0020                 .
CONTROLS: TCTRL_ZVKT_MO_T0020
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZVKT_MO_T0021...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0021                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0021                 .
CONTROLS: TCTRL_ZVKT_MO_T0021
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0020                 .
TABLES: *ZVKT_MO_T0021                 .
TABLES: ZVKT_MO_T0020                  .
TABLES: ZVKT_MO_T0021                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0018...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0018                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0018                 .
CONTROLS: TCTRL_ZVKT_MO_T0018
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZVKT_MO_T0019...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0019                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0019                 .
CONTROLS: TCTRL_ZVKT_MO_T0019
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0018                 .
TABLES: *ZVKT_MO_T0019                 .
TABLES: ZVKT_MO_T0018                  .
TABLES: ZVKT_MO_T0019                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0003...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0003                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0003                 .
CONTROLS: TCTRL_ZVKT_MO_T0003
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0003                 .
TABLES: ZVKT_MO_T0003                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

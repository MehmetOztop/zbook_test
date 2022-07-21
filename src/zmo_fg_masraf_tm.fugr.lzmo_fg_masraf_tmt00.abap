*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVKT_MO_T0017...................................*
DATA:  BEGIN OF STATUS_ZVKT_MO_T0017                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVKT_MO_T0017                 .
CONTROLS: TCTRL_ZVKT_MO_T0017
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVKT_MO_T0017                 .
TABLES: ZVKT_MO_T0017                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZVKT_MO_FG_01_TM
*   generation date: 07.05.2022 at 12:24:59
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZVKT_MO_FG_01_TM   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

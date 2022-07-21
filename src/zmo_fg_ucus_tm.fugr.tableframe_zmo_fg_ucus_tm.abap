*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZMO_FG_UCUS_TM
*   generation date: 23.06.2022 at 17:23:51
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZMO_FG_UCUS_TM     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

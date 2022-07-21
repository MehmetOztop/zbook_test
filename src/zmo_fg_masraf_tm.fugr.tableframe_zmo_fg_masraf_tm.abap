*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZMO_FG_MASRAF_TM
*   generation date: 24.06.2022 at 16:33:09
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZMO_FG_MASRAF_TM   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

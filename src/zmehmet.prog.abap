*&---------------------------------------------------------------------*
*& Include          ZMEHMET
*&---------------------------------------------------------------------*
LOOP AT SCREEN.

  "    if screen-name = 'S_FKART' .
  screen-input = 1.
  MODIFY SCREEN.
  "    endif.


ENDLOOP.

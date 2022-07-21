*&---------------------------------------------------------------------*
*& Report ZVKT_MO_0016
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvkt_mo_0016.

INCLUDE: zvkt_mo_0016_top.

START-OF-SELECTION.


  TRY.
      "Create send request
      gr_send_request = cl_bcs=>create_persistent( ).


      "Email FROM...
      sender = cl_cam_address_bcs=>create_internet_address( p_send ).
      "Add sender to send request
      CALL METHOD gr_send_request->set_sender
        EXPORTING
          i_sender = sender.


      "Email TO...
      gv_email = p_rec.
      gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
      "Add recipient to send request
      CALL METHOD gr_send_request->add_recipient
        EXPORTING
          i_recipient = gr_recipient
          i_express   = 'X'.


      "Email BODY
      APPEND p_body TO gv_text.
      gr_document = cl_document_bcs=>create_document(
                      i_type    = gc_raw
                      i_text    = gv_text
                      i_length  = '12'
                      i_subject = p_sub ).
      "Add document to send request
      CALL METHOD gr_send_request->set_document( gr_document ).

      "Send email
      CALL METHOD gr_send_request->send(
        EXPORTING
          i_with_error_screen = 'X'
        RECEIVING
          result              = gv_sent_to_all ).
      IF gv_sent_to_all = 'X'.
        WRITE 'Email sent!'.
      ENDIF.

      "Commit to send email
      COMMIT WORK.


      "Exception handling
    CATCH cx_bcs INTO gr_bcs_exception.
      WRITE:
        'Error!',
        'Error type:',
        gr_bcs_exception->error_type.
  ENDTRY.

CLASS z2ui5_cl_demo_app_lp_02 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_title          TYPE string VALUE `my title`.


  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_LP_02 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    IF client->check_on_init( ).

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      DATA(shell) = z2ui5_cl_xml_view=>factory( )->shell( ).
      IF client->get( )-check_launchpad_active = abap_true.
        DATA(page) = shell->page( showheader = abap_false ).
        page->_z2ui5( )->lp_title( client->_bind_edit( mv_title ) ).
      ELSE.
        page = shell->page( title = client->_bind_edit( mv_title ) ).
      ENDIF.

      client->view_display( page->simple_form( title    = 'Set Launchpad Title Dynamically'
                                               editable = abap_true
                     )->content( 'form'
                         )->label( ``
                         )->input( client->_bind_edit( mv_title )
                         )->label( ``
                         )->button( text  = 'Go Back'
                                    press = client->_event( val = 'BACK' ) )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'READ_PARAMS'.
        DATA(lv_text) = `Start Parameter: `.
        DATA(lt_params) = client->get( )-t_comp_params.
        LOOP AT lt_params INTO DATA(ls_param).
          lv_text = |{ lv_text } / { ls_param-n } = { ls_param-v }|.
        ENDLOOP.
        client->message_box_display( lv_text ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

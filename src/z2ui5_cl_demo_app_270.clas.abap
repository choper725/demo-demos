CLASS z2ui5_cl_demo_app_270 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA name TYPE string.
    DATA color TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_270 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->shell(
        )->page(
            title          = 'abap2UI5 - Hello World App'
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            navbuttonpress = client->_event( 'BACK' )
        )->simple_form( editable = abap_true
             )->content( ns = `form`
                )->color_picker(
                  colorstring = client->_bind_edit( color )
*                  displaymode =
*                  change      =
*                  livechange  =
                )->input( client->_bind_edit( color )
        )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

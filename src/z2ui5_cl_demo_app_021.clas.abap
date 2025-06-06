CLASS z2ui5_cl_demo_app_021 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA mv_textarea TYPE string.

  PROTECTED SECTION.

    DATA client            TYPE REF TO z2ui5_if_client.


    METHODS z2ui5_set_data.
    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_021 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Text Area Example'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    layout->label( 'text area'
        )->text_area(
            valueliveupdate = abap_true
            value           = client->_bind_edit( mv_textarea )
            growing         = abap_true
            growingmaxlines = '7'
            width           = '100%'
        )->button( text  = `OK`
                   press = client->_event( `POST` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'POST'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      display_view( client ).
      z2ui5_set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mv_textarea = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magn` &&
              `a aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd` &&
          ` gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam n ` &&
            `  onumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit am ` &&
            `  et, consetetur sadipscing elitr, sed diam nonumy eirm sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no ` &&
                  `numy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.

  ENDMETHOD.
ENDCLASS.

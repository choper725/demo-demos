CLASS z2ui5_cl_demo_app_269 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.


    METHODS display_view.
    METHODS on_event.

    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.


CLASS z2ui5_cl_demo_app_269 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.

    IF client->check_on_init( ).
      display_view( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell_bar(
        title               = `Shell Bar`
        secondtitle         = `with title mega menu`
        homeicon            = `https://sapui5.hana.ondemand.com/sdk/resources/sap/ui/documentation/sdk/images/logo_sap.png`
        shownavbutton       = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        showsearch          = abap_true
        shownotifications   = abap_true
        notificationsnumber = `2`
        navbuttonpressed    = client->_event( 'BACK' )
        )->_generic( name = `menu`
                     ns   = `f`
            )->_generic( name = `Menu`
                )->menu_item( text = `Flight booking`
                              icon = `sap-icon://flight`
                )->menu_item( text = `Car rental`
                              icon = `sap-icon://car-rental`
                )->get_parent(
            )->get_parent(
        )->_generic( name = `profile`
                     ns   = `f`
            )->avatar( ns       = `f`
                       initials = 'UI' ).

    DATA(xml) = view->stringify( ).

    client->view_display( xml ).

  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

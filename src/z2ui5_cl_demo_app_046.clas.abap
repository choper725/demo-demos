CLASS z2ui5_cl_demo_app_046 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_display TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_046 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mv_display = 'LIST'.

      t_tab = VALUE #(
        ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'Peter'  info = 'incompleted' descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'Peter'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'Peter'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' ) ).

    ELSE.

      CASE client->get( )-event.
        WHEN 'BACK'.
          client->nav_app_leave( ).
        WHEN OTHERS.
          mv_display = client->get( )-event.
      ENDCASE.

    ENDIF.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = 'abap2UI5 - Table output in two different Ways - Changing UI without Model'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            )->header_content(
                )->button( text  = 'Display List'
                           press = client->_event( 'LIST' )
                )->button( text  = 'Display Table'
                           press = client->_event( 'TABLE' )
                )->link(
      )->get_parent( ).

    CASE mv_display.

      WHEN 'LIST'.
        page->list(
            headertext = 'List Control'
            items      = client->_bind( t_tab )
            )->standard_list_item(
                title       = '{TITLE}'
                description = '{DESCR}'
                icon        = '{ICON}'
                info        = '{INFO}' ).

      WHEN 'TABLE'.

        DATA(tab) = page->table(
          headertext = 'Table Control'
          items      = client->_bind( t_tab ) ).

        tab->columns(
            )->column(
                )->text( 'Title' )->get_parent(
            )->column(
                )->text( 'Descr' )->get_parent(
            )->column(
                )->text( 'Icon' )->get_parent(
             )->column(
                )->text( 'Info' ).

        tab->items( )->column_list_item( )->cells(
           )->text( '{TITLE}'
           )->text( '{DESCR}'
           )->text( '{ICON}'
           )->text( '{INFO}' ).

    ENDCASE.

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.
ENDCLASS.

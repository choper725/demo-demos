CLASS z2ui5_cl_app_demo_72 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        productid    TYPE string,
        productname  TYPE string,
        Suppliername TYPE string,
        Measure      TYPE p LENGTH 10 DECIMALS 2,
        unit         TYPE string, "meins,
        price        TYPE p LENGTH 14 DECIMALS 3, "p LENGTH 10 DECIMALS 2,
        waers        TYPE waers,
        Width        TYPE string,
        Depth        TYPE string,
        Height       TYPE string,
        DimUnit      TYPE meins,
        state_price   type string,
        state_measure type string,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .

    DATA mt_table TYPE ty_t_table .
    DATA lv_cnt_total TYPE i .
    DATA lv_cnt_pos TYPE i .
    DATA lv_cnt_heavy TYPE i .
    DATA lv_cnt_neg TYPE i .
    DATA lv_selectedkey TYPE string .
    CONSTANTS c_lcb TYPE string VALUE '{' ##NO_TEXT.
    CONSTANTS c_rcb TYPE string VALUE '}' ##NO_TEXT.
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .
  PRIVATE SECTION.

    METHODS set_filter .
ENDCLASS.



CLASS z2ui5_cl_app_demo_72 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_set_data( ).
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'OnSelectIconTabBar' .
        client->message_toast_display( |Event SelectedTabBar Key { lv_selectedKey  } | ).
        set_filter( ).
        client->view_model_update( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.


    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - IconTabBar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            class = 'sapUiContentPadding' ).

    page->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  ) ).
    DATA(lo_items) = page->icontabbar( class = 'sapUiResponsiveContentPadding' selectedKey = client->_bind_edit( lv_selectedKey )  select = client->_event( val = 'OnSelectIconTabBar' t_arg = VALUE #( ( `${LV_SELECTEDKEY}` ) ) ) )->items( ).
    lo_items->icontabfilter( count = client->_bind_edit( lv_cnt_total ) text = 'Products' key = 'ALL' showall = abap_true ).
    lo_items->icontabseparator(  ).
    lo_items->icontabfilter( icon = 'sap-icon://begin'     iconcolor = 'Positive' count = client->_bind_edit( lv_cnt_pos ) text = 'OK' key = 'OK'  ).
    lo_items->icontabfilter( icon = 'sap-icon://compare'   iconcolor = 'Critical' count = client->_bind_edit( lv_cnt_heavy ) text = 'Heavy' key = 'HEAVY'  ).
    lo_items->icontabfilter( icon = 'sap-icon://inventory' iconcolor = 'Negative' count = client->_bind_edit( lv_cnt_neg ) text = 'Overweight' key = 'OVERWEIGHT'  ).

    DATA(tab) = page->scroll_container( height = '70%' vertical = abap_true
       )->table(
           inset = abap_false
           showSeparators = 'Inner'
           headerText = 'Products'
*            growing             = abap_true
*            growingthreshold    = '20'
*            growingscrolltoload = abap_true
           items               = client->_bind( mt_table ) ).
*            sticky              = 'ColumnHeaders,HeaderToolbar' ).

    tab->columns(
        )->column( width = '12em'
            )->text( 'Product' )->get_parent(
        )->column( minScreenWidth = 'Tablet' demandPopin = abap_true
            )->text( 'Supplier' )->get_parent(
        )->column( minScreenWidth = 'Desktop' demandPopin = abap_true hAlign = 'End'
            )->text( 'Dimensions' )->get_parent(
        )->column( minScreenWidth = 'Desktop' demandPopin = abap_true hAlign = 'Center'
            )->text( 'Weight' )->get_parent(
         )->column( hAlign = 'End'
            )->text( 'Price' ).

    tab->items(
        )->column_list_item(
           )->cells(
             )->object_identifier( text = '{PRODUCTNAME}' title =  '{PRODUCTID}' )->get_parent(
             )->text( text = '{SUPPLIERNAME}' )->get_parent(
             )->text( text = '{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}'
             )->object_number( number = '{MEASURE}' unit =  '{UNIT}' state = '{STATE_MEASURE}'
*               state = `{ parts: [ { path : 'MEASURE' } ,  { path : 'UNIT' } ] } `
*               state = `{ parts: [ { path : 'MEASURE' } ,  { path : 'UNIT' } ] , formatter: 'sap.m.sample.Table.Formatter.weightState' } `
*             )->object_number( number = `{ parts: [ { path : 'PRICE' } , { path : 'UNIT' } ] , type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false}  } `
*                              unit =  '{WAERS}'
             )->object_number( "number = '{MEASURE}' unit =  '{UNIT}'
                   state = '{STATE_PRICE}'
                   number = `{ parts: [ { path : 'PRICE' } , { path : 'WAERS' } ] } ` ",  type: 'sap.ui.model.type.Currency , formatOptions: { currencyCode : false } } `
*                  number = `{ parts: [ { path : 'PRICE' } , { path : 'UNIT' } ] , ype: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false}  } `
*                    unit = `{UNIT}`
*)->object_number( number = `{ parts: [ '` && client->_bind_edit( val = '{PRICE}' path = abap_true ) && `', '` && client->_bind_edit( val = '{WAERS}' path = abap_true )
*                 && `' ] , type: 'sap.ui.model.type.Currency',formatOptions: {showMeasure: false}  } `
*                              unit =  '{WAERS}'
              ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.
    mt_table = VALUE #(
        ( Productid = '1' productname = 'table' suppliername = 'Company 1' Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure = 100  unit = 'ST' price = '1000.50' waers = 'EUR'  state_price = `Success` state_measure = `Warning`  )
        ( Productid = '2' productname = 'chair' suppliername = 'Company 2'  Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure = 123   unit = 'ST' price = '2000.55' waers = 'USD' state_price = `Error` state_measure = `Warning`  )
        ( Productid = '3' productname = 'sofa'  suppliername = 'Company 3'  Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure  = 700   unit = 'ST' price = '3000.11' waers = 'CNY' state_price = `Success` state_measure = `Warning`  )
        ( Productid = '4' productname = 'computer' suppliername = 'Company 4'  Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure  = 200  unit = 'ST' price = '4000.88' waers = 'USD' state_price = `Success` state_measure = `Success`  )
        ( Productid = '5' productname = 'printer' suppliername = 'Company 5'  Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure  = 90   unit = 'ST' price = '5000.47' waers = 'EUR' state_price = `Error` state_measure = `Warning`  )
        ( Productid = '6' productname = 'table2'  suppliername = 'Company 6'  Width = '10' Depth = '20' Height = '30' DimUnit = 'CM' Measure = 600  unit = 'ST' price = '6000.33' waers = 'GBP' state_price = `Success` state_measure = `Information`  )
    ).

    lv_cnt_pos = REDUCE i( INIT i = 0 FOR wa IN mt_table WHERE ( measure > 0 AND measure <= 100 ) NEXT i = i + 1 ).
    lv_cnt_heavy = REDUCE i( INIT i = 0 FOR wa IN mt_table WHERE ( measure > 100 AND measure <= 500 ) NEXT i = i + 1 ).
    lv_cnt_neg = REDUCE i( INIT i = 0 FOR wa IN mt_table WHERE ( measure > 500 ) NEXT i = i + 1 ).

  ENDMETHOD.


  METHOD set_filter.
    z2ui5_set_data( ).
    CASE lv_selectedkey.
      WHEN 'ALL'.
      WHEN 'OK'.
        DELETE mt_table WHERE  NOT measure BETWEEN 0 AND 100.
      WHEN 'HEAVY'.
        DELETE mt_table WHERE NOT measure BETWEEN 101 AND 500.
      WHEN 'OVERWEIGHT'.
        DELETE mt_table WHERE NOT measure > 500 .
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

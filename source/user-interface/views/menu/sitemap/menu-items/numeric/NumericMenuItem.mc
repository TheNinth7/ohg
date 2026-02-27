import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item represents the Setpoint and Slider widget in the app.
 * It displays the current item value and, when selected,
 * opens a separate view (a DynamicPicker implementation) that allows
 * the user to adjust the value.
 *
 * The widgets respects sitemap settings for minValue, maxValue, and step.
 * It also supports 'releaseOnly' mode: if enabled, the item state is updated
 * only after the user confirms their selection. If disabled, the state updates
 * continuously as the user scrolls through values.
 */
class NumericMenuItem extends BaseWidgetMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapNumeric;
    }

    // For changing the state of the item
    private var _commandRequest as BaseCommandRequest?;

    // Since we need a bunch of values from the sitemap configuration,
    // we just keep the SitemapNumeric
    private var _sitemapNumeric as SitemapNumeric;

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed state and the superclass
    public function initialize( 
        sitemapNumeric as SitemapNumeric,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        _sitemapNumeric = sitemapNumeric;
        _commandRequest = BaseCommandRequest.get( self, false );

        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapNumeric,
                :stateTextResponsive => sitemapNumeric.getDisplayState(),
                :isActionable => true,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapNumeric.getNumericItem().getName();
    }

    // Returns the SitemapNumeric widget associated with this menu item
    public function getSitemapNumeric() as SitemapNumeric {
        return _sitemapNumeric;
    }

    // Nothing to do here, but required to fulfill the delegate interface.
    //
    // Currently, the new state is displayed immediately in updateState()
    // when the command is sent. At some point, this should be aligned with
    // BaseSwitchMenuItem, which applies the new state only when the command
    // was confirmed in onCommandComplete().
    function onCommandComplete( syncMode as Boolean ) as Void {}
    function onException( ex as Exception ) as Void {}

    // When the menu item is selected, the DynamicPicker is initialized
    // and pushed to the view stack
    public function onSelect() as Boolean {
        if( ! BaseWidgetMenuItem.onSelect() ) {
            if( _commandRequest != null ) {
                ViewHandler.pushView(
                    new DynamicPicker( 
                        getLabel(),
                        new NumericPickerDataSource( self )
                    ),
                    new NumericPickerDelegate( self ),
                    WatchUi.SLIDE_LEFT
                );
            }
        }
        return true;
    }

    // The Picker uses this function to update the state
    // It stores the new state and sends a command
    // request to change it on the server
    public function updateState( newState as Float ) as Void {
        
        if( _commandRequest == null ) {
            throw new GeneralException( "NumericMenuItem: state update not possible because command support is not active" );
        }

        if( ConnectionHandler.get().isBluetoothConnected() ) {
            // Store the new state in the sitemap object
            _sitemapNumeric.updateState( newState );
            
            // Update the state
            setStateTextResponsive( _sitemapNumeric.getDisplayState() );
        }
        
        // And send the command
        ( _commandRequest as BaseCommandRequest ).sendCommand( 
            newState.toString()
        );

    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
        var previousItemName = _sitemapNumeric.getNumericItem().getName();
        if( ! ( sitemapWidget instanceof SitemapNumeric ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.getLabel() + "' was passed into NumericMenuItem but is of a different type" );
        }
        _sitemapNumeric = sitemapWidget;
        setStateTextResponsive( sitemapWidget.getDisplayState() );
        // If the item has changed, we need to create a new command request
        if( ! _sitemapNumeric.getNumericItem().getName().equals( previousItemName ) ) {
            _commandRequest = BaseCommandRequest.get( self, false );
        }
    }
}
import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item represents the Setpoint and Slider widget in the app.
 * It displays the current item value and, when selected,
 * opens a separate view (a CustomPicker implementation) that allows
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

    // The text state Drawable
    private var _stateText as Text;

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

        // The state shown in the menu item
        //var item = sitemapNumeric.getNumericItem();
        _stateText = new StateText( sitemapNumeric.getDisplayState() );
        
        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapNumeric,
                :stateDrawable => _stateText,
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

    // Nothing to be done, but needed to fullfil the delegate interface
    function onCommandComplete( syncMode as Boolean ) as Void {
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );
    }

    // When the menu item is selected, the CustomPicker is initialized
    // and pushed to the view stack
    public function onSelect() as Boolean {
        if( ! BaseWidgetMenuItem.onSelect() ) {
            if( _commandRequest != null ) {
                ViewHandler.pushView(
                    new CustomPicker( 
                        getLabel(),
                        new NumericPickerFactory( self )
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
    public function updateState( newState as Number ) as Void {
        if( _commandRequest == null ) {
            throw new GeneralException( "NumericMenuItem: state update not possible because command support is not active" );
        }
        // Store the new state in the sitemap object
        _sitemapNumeric.updateState( newState );
        
        // Update the state
        _stateText.setText( _sitemapNumeric.getDisplayState() );
        
        // And send the command
        ( _commandRequest as BaseCommandRequest ).sendCommand( 
            _sitemapNumeric.getNumericItem().getState() 
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
        _stateText.setText( sitemapWidget.getDisplayState() );
        // If the item has changed, we need to create a new command request
        if( ! _sitemapNumeric.getNumericItem().getName().equals( previousItemName ) ) {
            _commandRequest = BaseCommandRequest.get( self, false );
        }
    }
}
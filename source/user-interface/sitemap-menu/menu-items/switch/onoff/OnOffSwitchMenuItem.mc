import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays an on/off switch as its state.
 * Selecting the item toggles the switch state.
 */
class OnOffSwitchMenuItem extends BaseSwitchMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
               sitemapWidget instanceof SitemapSwitch 
            && ! sitemapWidget.hasMappings()
            && ! sitemapWidget.getSwitchItem().getType().equals( "Rollershutter" );
    }

    // True if the switch is on
    private var _isEnabled as Boolean?;

    // True if the widget has nested elements and
    // thus a smaller icon shall be displayed
    private var _smallIcon as Boolean;

    // The actual Drawable for drawing the switch
    private var _stateDrawable as OnOffStateDrawable;

    // Constructor
    public function initialize( 
        sitemapSwitch as SitemapSwitch,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        _isEnabled = parseItemState( sitemapSwitch.getSwitchItem().getState() );

        _smallIcon = sitemapSwitch.getLinkedPage() != null;
        _stateDrawable = new OnOffStateDrawable( _isEnabled, _smallIcon );
        
        // Initialize the superclass
        // For the toggle switch we support the display
        // of a display state, if provided by the server
        BaseSwitchMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :stateTextResponsive => getStateTextResponsive( sitemapSwitch ),
                :stateDrawable => _stateDrawable,
                :isActionable => false,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // Toggle the state
    public function getNextCommand() as String? {
        // If we have a state, then we toggle,
        // if there is none, we show an action menu
        // with ON/OFF
        if( _isEnabled != null ) {
            return _isEnabled 
                ? SwitchItem.ITEM_STATE_OFF 
                : SwitchItem.ITEM_STATE_ON;
        } else {
            var actionMenu = new ActionMenu( null );
            actionMenu.addItem( new ActionMenuItem( { :label => SwitchItem.ITEM_STATE_ON }, SwitchItem.ITEM_STATE_ON ) );
            actionMenu.addItem( new ActionMenuItem( { :label => SwitchItem.ITEM_STATE_OFF }, SwitchItem.ITEM_STATE_OFF ) );
            WatchUi.showActionMenu( actionMenu, new SwitchActionMenuDelegate( self ) );
            return null;
        }
    }

    // Determines the display state of a toggle switch.
    // Special handling is applied for Dimmers, which are rendered manually
    // to ensure consistent appearance throughout the app.
    private static function getStateTextResponsive( 
        sitemapSwitch as SitemapSwitch 
    ) as String? {
        var switchItem = sitemapSwitch.getSwitchItem();
        return
            switchItem.getType().equals( "Dimmer" )
            ? switchItem.getState().equals( "0" ) || ! switchItem.hasState()
                ? null
                : sitemapSwitch.getDisplayState()
            : sitemapSwitch.getRemoteDisplayStateOrNull();
    }

    // Converts the string state to a nullable Boolean for _isEnabled
    // The widget supports string states:
    // "ON" => true; "OFF" => false
    // And numeric states:
    // 0 => false; 1-100 => true
    // If the state is NO_STATE, then null will be returned.
    private function parseItemState( itemState as String ) as Boolean? {
        if( itemState.equals( Item.NO_STATE ) ) {
            return null;
        } else if( itemState.equals( SwitchItem.ITEM_STATE_ON ) ) {
            return true;            
        } else if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
            return false;
        } else {
            var numericState = itemState.toNumber();
            if( numericState != null ) {
                if( numericState == 0 ) {
                    return false;
                } else if( numericState > 0 && numericState <= 100 ) {
                    return true;
                }
            }
        }
        throw new GeneralException( "OnOffSwitchMenuItem: state '" + itemState + "' is not supported" );
    }

    // Update the member and Drawable
    public function updateItemState( state as String ) as Void {
        BaseSwitchMenuItem.updateItemState( state );
        _isEnabled = parseItemState( state );
        _stateDrawable.setEnabled( _isEnabled, _smallIcon );
    }

    // Override the update method of the super class
    // and obtain the updated list of commmand mappings
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseSwitchMenuItem.updateWidget( sitemapWidget );
        _smallIcon = sitemapWidget.getLinkedPage() != null;
        // Update the display state
        setStateTextResponsive( getStateTextResponsive( sitemapWidget as SitemapSwitch ) );
    }
}
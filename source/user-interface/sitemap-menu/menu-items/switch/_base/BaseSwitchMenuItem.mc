import Toybox.Lang;
import Toybox.WatchUi;

/**
 * Base class for all menu items representing `Switch` sitemap elements
 * that immediately update the associated openHAB item's state upon selection.
 *
 * This class is intended for switches where user interaction should directly
 * trigger a state change (e.g., ON/OFF).
 */

// Defines the options accepted by the `BaseWidgetMenuItem` class.
typedef BaseSwitchMenuItemOptions as {
    :sitemapWidget as SitemapSwitch,
    :stateTextResponsive as String?,
    :stateDrawable as BaseSitemapMenuItem.StateDrawable?,
    :isActionable as Boolean?, // if true, the action icon is displayed
    :parent as BasePageMenu,
    :processingMode as BasePageMenu.ProcessingMode
};

class BaseSwitchMenuItem extends BaseWidgetMenuItem {

    // The command request for sending commands
    // Defined as interface, since two types of command requests are supported
    private var _commandRequest as BaseCommandRequest?;

    // The openHAB item linked to the sitemap element
    private var _itemName as String;

    // If the state is changed, the new state is stored in `_newState` and 
    // only applied after the request succeeds.
    private var _newState as String?;

    // We keep the sitemap element for all the configuration
    // but will also update the state there if it is changed by the app
    protected var _sitemapSwitch as SitemapSwitch;

    // Constructor
    protected function initialize( options as BaseSwitchMenuItemOptions ) {
        _sitemapSwitch = options[:sitemapWidget] as SitemapSwitch;
        _itemName = _sitemapSwitch.getSwitchItem().getName();
        
        BaseWidgetMenuItem.initialize( options );
        
        _commandRequest = BaseCommandRequest.get( self );
    }

    // Returns the name of the openHAB item associated with this menu item
    public function getItemName() as String {
        return _itemName;
    }

    // Abstract function to be implemented by subclasses.
    // getNextCommand() should return the command to be triggered
    // when the menu item is selected.
    // If it returns null, the menu item delegates command selection
    // to an asynchronous process, which is responsible for calling
    // sendCommand() directly.
    public function getNextCommand() as String? {
        throw new AbstractMethodException( "BaseSwitchMenuItem.getNextCommand" );
    }

    // Called by the command request after the command is successfully sent.
    // Triggers `updateItemState()` for the subclass to update the state `Drawable`,
    // and then requests a UI redraw.
    public function onCommandComplete() as Void {
        if( _newState != null ) {
            updateItemState( _newState );
            _newState = null;
            WatchUi.requestUpdate();
        }
    }

    // Called by the command request if an error occurred.
    // The `_newState` will not be applied.
    public function onException( ex as Exception ) as Void {
        _newState = null;
    }

    // `onSelect()` retrieves the command from the subclass and sends it.
    // If getNextCommand() returns null, the menu item delegates command selection
    // to an asynchronous process, which is responsible for calling
    // sendCommand() directly.
    public function onSelect() as Boolean {
        if( ! BaseWidgetMenuItem.onSelect() 
            && _newState == null 
            && _commandRequest != null 
        ) {
            var command = getNextCommand();
            if( command != null ) {
                sendCommand( command );
            }
        }
        return true;
    }

    // Send the command via the command request
    public function sendCommand( command as String ) as Void {
        _newState = command;
        if( _commandRequest != null ) {
            _commandRequest.sendCommand( command );
        }
    }

    // updateItemState() is called when a state change occurs—either received
    // from the server or triggered by user interaction. This method centralizes
    // logic that should apply to both scenarios.
    //
    // Subclasses may override this method to implement custom behavior
    // (e.g., updating Drawables). When doing so, they must call the
    // superclass implementation to ensure the SitemapSwitch object
    // is properly updated.
    public function updateItemState( state as String ) as Void {
        if( ! _sitemapSwitch.getSwitchItem().getState().equals( state ) ) {
            _sitemapSwitch.updateState( state );
            setIcon( _sitemapSwitch.getIcon() );
        }
    }

    // Called by the sitemap request when updated state data is received.
    // Updates the label and delegates state `Drawable` updates to the subclass.
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        // BaseSitemapMenuItem.update needs to come before updateItemState,
        // so that updateItemState can already access the
        // updated label
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
        _sitemapSwitch = sitemapWidget as SitemapSwitch;
        updateItemState( _sitemapSwitch.getSwitchItem().getState() );
    }
}
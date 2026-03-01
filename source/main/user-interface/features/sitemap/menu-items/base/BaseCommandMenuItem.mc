import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;

class BaseCommandMenuItem extends BaseWidgetMenuItem {

    private var _commandRequest as BaseCommandRequest?;
    private var _pendingCommand as Item.ItemState?;

    // Constructor
    protected function initialize( 
        options as BaseWidgetMenuItemOptions
    ) {
        BaseWidgetMenuItem.initialize( options );
        _commandRequest = BaseCommandRequest.get( self, false );
    }

    private function getItem() as Item {
        var item = getSitemapWidget().getItem();
        if( item == null ) {
            throw new GeneralException( "BaseCommandMenuItem does not support widgets without item." );
        }
        return item;
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return getItem().getName();
    }

    protected function getPendingCommand() as String? {
        return _pendingCommand != null
               ? _pendingCommand.toString()
               : null;
    }

    protected function hasCommandsEnabled() as Boolean {
        return _commandRequest != null;
    }

    protected function hasPendingCommand() as Boolean {
        return _pendingCommand != null;
    }

    public function onCommandComplete() as Void {
        if( _pendingCommand != null ) {
            // Perform an internal update of the state in the SitemapSwitch
            getSitemapWidget().updateState( _pendingCommand as Item.ItemState );
            _pendingCommand = null;
            
            // Notify the base class that an internal state update was performed.
            // This triggers the post-command hold time for state updates,
            // if configured in the app settings.
            notifyStateUpdatedLocally();

            // Update state displayed by the menu item
            onStateUpdatedLocally();
 
            WatchUi.requestUpdate();
       }
    }

    // C
    public function onCommandDeferredToSync() as Void {
        _pendingCommand = null;
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    public function onCommandException( ex as Exception ) as Void {
        _pendingCommand = null;
    }

    public function onStateUpdatedLocally() as Void {
        setIcon( getSitemapWidget().getIcon() );
        onStateUpdated();
    }

    public function onStateUpdated() as Void {
    }

    // Send the command via the command request
    public function sendCommand( command as Item.ItemState ) as Void {

        if( ! ( command instanceof String ) ) {
            throw new GeneralException( "BaseCommandMenuItem.sendCommand supports only String arguments." );
        }

        if( ! hasPendingCommand() && _commandRequest != null ) {
            _pendingCommand = command;
            _commandRequest.sendCommand( command );
        }
    }

    // Called by the sitemap request when updated state data is received.
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        // Before updating the base class, we keep the previous item
        // to check if the item name has changed.
        var previousItem = getItem();

        BaseWidgetMenuItem.updateWidget( sitemapWidget );

        // If the item has changed, we create a new command request
        if( ! previousItem.getName().equals( getItem().getName() ) ) {
            _commandRequest = BaseCommandRequest.get( self, false );
        }
    }
}
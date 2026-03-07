import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Input delegate for the command action menu.
 *
 * The action menu is used to allow the user to select a command to send.
 * Once a command is selected, this delegate sends it via the
 * associated menu item.
 */
(:exclForFullMenu)
class CommandActionMenuDelegate extends ActionMenuDelegate {

    var _delegate as SendCommandDelegate;

    // Constructor
    public function initialize( delegate as SendCommandDelegate ) {
        ActionMenuDelegate.initialize();
        _delegate = delegate;
    }

    /*
    public function onBack() as Void {
        Logger.debug( "CommandActionMenuDelegate.onBack" );
    }
    */

    // on select, send the command
    public function onSelect( item as ActionMenuItem ) as Void {
        Logger.debug( "CommandActionMenuDelegate.onSelect" );
        try {
            // The action menu items have the command as Id
            var command = item.getId();
            if( command instanceof String ) {
                _delegate.sendCommand( command );
            } else {
                throw new NonFatalUserInterfaceException( NonFatalUserInterfaceException.EX_INVALID_COMMAND );
            }
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
    }
}
import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Input delegate for the action menu of a GenericSwitchMenuItem.
 *
 * The action menu allows the user to select a command to send.
 * Once a command is selected, this delegate sends it via the
 * associated menu item.
 */
class SwitchActionMenuDelegate extends ActionMenuDelegate {

    var _menuItem as BaseSwitchMenuItem;

    // Constructor
    public function initialize( menuItem as BaseSwitchMenuItem ) {
        ActionMenuDelegate.initialize();
        _menuItem = menuItem;
    }

    // on select, send the command
    public function onSelect( item as ActionMenuItem ) as Void {
        // Logger.debu "SwitchActionMenuDelegate.onSelect" );
        // The action menu items have the command as Id
        var command = item.getId();
        if( command instanceof String ) {
            _menuItem.sendCommand( command );
        } else {
            throw new GeneralException( "SwitchActionMenuDelegate: invalid command" );
        }
    }
}
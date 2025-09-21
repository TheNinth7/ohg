import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays the current state of an item as text
 * and sends a command when selected.
 *
 * Intended for use with `Switch` sitemap elements, where possible
 * commands are defined via the element's `mappings` property.
 *
 * Behavior on selection:
 * - If only one command is defined, it is sent immediately.
 * - If two commands are defined and the current state matches one of them,
 *   the other command is sent (toggling behavior).
 * - In all other cases, an action menu is shown, allowing the user to
 *   manually select a command to send.
 */
class GenericSwitchMenuItem extends BaseSwitchMenuItem {
    
    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        // This menu item applies to all Switches, that
        // have a mapping defined
        return 
            sitemapWidget instanceof SitemapSwitch 
            && sitemapWidget.hasMappings()
            && ! sitemapWidget.getSwitchItem().getType().equals( "Rollershutter" );
    }

    // Constructor
    public function initialize( 
        sitemapSwitch as SitemapSwitch,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        // Initialize the superclass
        BaseSwitchMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :stateTextResponsive => sitemapSwitch.getDisplayState(),
                :isActionable => true,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // Called by the superclass if the state changes
    // Updates the member and Drawable
    // This is called by update() of the superclass, and thus
    // at the end of the update() function above
    // It is also called after a command was sent to immediately
    // show the new state, even before the next sitemap update
    // arrives
    public function updateItemState( state as String ) as Void {
        BaseSwitchMenuItem.updateItemState( state );
        setStateTextResponsive( _sitemapSwitch.getDisplayState() );
    }

    // Called by the superclass to determine the command
    // that shell be sent when the menu item is selected
    public function getNextCommand() as String? {
        var switchItem = _sitemapSwitch.getSwitchItem();
        var hasState = switchItem.hasState(); 
        var itemState = switchItem.getState();
        var commandDescriptions = _sitemapSwitch.getCommandDescriptions();
        if( commandDescriptions.size() == 1 ) {
            // For one mapping, we just send that command
            return commandDescriptions.getCommandDescription( 0 ).getCommand();
        } else if( commandDescriptions.size() == 2 && hasState ) {
            // For two mappings, we check if the current state equals
            // to one of them and then send the other
            var firstCommand = commandDescriptions.getCommandDescription( 0 ).getCommand();
            var secondCommand = commandDescriptions.getCommandDescription( 1 ).getCommand();
            if( firstCommand.equals( itemState ) ) {
                return secondCommand;
            } else if( secondCommand.equals( itemState ) ) {
                return firstCommand;
            }
        }
        
        // For all other cases, we show the action menu
        var actionMenu = new ActionMenu( null );
        // Add items
        for( var i = 0; i < commandDescriptions.size(); i++ ) {
            var commandDescription = commandDescriptions.getCommandDescription( i );
            // We exclude the current state
            var command = commandDescription.getCommand();
            if( ! ( hasState && command.equals( itemState ) ) ) {
                actionMenu.addItem( new ActionMenuItem(
                    { :label => commandDescription.getLabel() },
                    command
                ) );
            }
        }
        WatchUi.showActionMenu( actionMenu, new SwitchActionMenuDelegate( self ) );
        // Returning null tells the super class to not
        // send any command and instead wait for the
        // action menu delegate to trigger the sending
        // of the command
        return null;
    }
}
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
 * - If two commands are defined and the current state is known and 
 *   matches one of them, the other command is sent (toggling behavior).
 * - In all other cases, an command selection menu is shown, allowing the user to
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
        // Initialize the base class
        BaseSwitchMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :stateTextResponsive => sitemapSwitch.getDisplayState(),
                :isActionable => true,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // Called by the base class when the state changes, either due to
    // a sitemap update from the server or a local change after a
    // command was sent.
    // Updates the locally stored state and the associated Drawable.
    // Calling WatchUi.requestUpdate() is handled by the base class.
    public function onStateUpdated() as Void {
        BaseSwitchMenuItem.onStateUpdated();
        setStateTextResponsive( getSitemapSwitch().getDisplayState() );
    }

    // Returns the next state to be used as a command when the menu item
    // is selected.
    //
    // See the class-level comment for details on the applied logic.
    // If a command selection menu is displayed, `null` is returned here,
    // as the command will be sent by the selection menu instead.
    public function getNextCommand() as String? {
        var sitemapSwitch = getSitemapSwitch();
        var switchItem = sitemapSwitch.getSwitchItem();
        var hasState = switchItem.hasState(); 
        var itemState = switchItem.getState();
        var commandDescriptions = sitemapSwitch.getCommandDescriptions();
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
        
        // For all other cases, use the base class function to show a menu that allows the
        // user to select a command. On most devices, an ActionMenu is used. On Edge
        // devices, where ActionMenu is not available, the CommandMenu implementation
        // (a CustomMenu, as used for the sitemap) is used instead.

        // Assemble the list of menu entries ...
        var menuEntries = [];
        for( var i = 0; i < commandDescriptions.size(); i++ ) {
            var commandDescription = commandDescriptions.getCommandDescription( i );
            var command = commandDescription.getCommand();
            // We exclude the current state
            if( ! ( hasState && command.equals( itemState ) ) ) {
                menuEntries.add( [commandDescription.getLabel(), command] );
            }
        }
        
        // ... and show the menu
        CommandMenuHandler.showCommandSelection( 
            getSitemapSwitch().getLabel(), 
            menuEntries, 
            self 
        );

        // Returning null tells the base class to not
        // send any command and instead wait for the
        // action menu delegate to trigger the sending
        // of the command
        return null;
    }
}
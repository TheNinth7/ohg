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

class BaseSwitchMenuItem extends BaseCommandMenuItem {
    
    // Constructor
    protected function initialize( options as BaseSwitchMenuItemOptions ) {
        BaseCommandMenuItem.initialize( options );
    }

    // Returns the underlying `SitemapWidget`, ensuring it is a
    // `SitemapSwitch`. Throws an exception if the type does not match.
    protected function getSitemapSwitch() as SitemapSwitch {
        var sitemapWidget = getSitemapWidget();
        if( ! ( sitemapWidget instanceof SitemapSwitch ) ) {
            throw new GeneralException( "BaseSwitchMenuItem only supports SitemapSwitch." );
        }
        return sitemapWidget;
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

    // Called by `BaseWidgetMenuItem` when `updateWidget` is invoked with a
    // changed state.
    //
    // Currently not used in this class, but declared to allow subclasses
    // to override it. The method is still invoked to preserve the extension
    // point for potential future use.
    public function onStateUpdated() as Void {
    }

    // `onSelect()` retrieves the command from the subclass and sends it.
    // If getNextCommand() returns null, the menu item delegates command selection
    // to an asynchronous process, which is responsible for calling
    // sendCommand() directly.
    public function onSelect() as Boolean {
        if( ! BaseCommandMenuItem.onSelect() && ! hasPendingCommand() ) {
            var command = getNextCommand();
            if( command != null ) {
                sendCommand( command );
            }
        }
        return true;
    }
}
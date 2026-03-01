import Toybox.Lang;
import Toybox.WatchUi;

/**
 * Base class for all menu items representing `Switch` sitemap elements
 * that immediately update the associated openHAB item's state upon selection.
 *
 * This class is intended for switches where user interaction should directly
 * trigger a state change (e.g., ON/OFF).
 */

// Defines the options accepted by the `WidgetMenuItem` class.
typedef BaseSwitchMenuItemOptions as {
    :sitemapWidget as SitemapSwitch,
    :stateTextResponsive as String?,
    :stateDrawable as StructuredMenuItem.StateDrawable?,
    :isActionable as Boolean?, // if true, the action icon is displayed
    :parent as BasePageMenu,
    :processingMode as BasePageMenu.ProcessingMode
};

class BaseSwitchMenuItem extends CommandMenuItem {
    
    // Constructor
    protected function initialize( options as BaseSwitchMenuItemOptions ) {
        CommandMenuItem.initialize( options );
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

}
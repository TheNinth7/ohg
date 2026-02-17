import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;

/*
 * A custom menu item that displays the age of the currently available
 * sitemap data, and provides an option to update it via WiFi.
 */
class SettingsSitemapRefreshMenuItem extends BaseSitemapMenuItem {

    /*
    * Constructor.
    * Initializes the superclass with the label.
    */
    public function initialize() {
        BaseSitemapMenuItem.initialize( { 
            :label => "Update Sitemap over Wi-Fi" 
            //:actionIcon => ACTION_ICON_COMMAND
        } );
    }

    // Trigger the sitemap sync
    public function onSelect() as Boolean {
        // Only if we are on WiFi connection we trigger the sync,
        // otherwise the menu item is disabled (see onUpdate)
        if( ConnectionHandler.get().isWifiConnected() ) {
            // Request a sitemap update in sync mode from the sync delegate
            SitemapSyncDelegate.get().requestSitemapUpdate();
        }

        // True indicates that this function has handled the user input event
        return true;
    }

    // Called by the base class to render the menu item.
    public function onUpdate( dc as Dc ) as Void {
        if( ConnectionHandler.get().isWifiConnected() ) {
            BaseSitemapMenuItem.setLabelColor( Constants.UI_COLOR_TEXT );
            BaseSitemapMenuItem.setActionIcon( ACTION_ICON_COMMAND );
        } else {
            BaseSitemapMenuItem.setLabelColor( Graphics.COLOR_LT_GRAY );
            BaseSitemapMenuItem.setActionIcon( null );
        }
        BaseSitemapMenuItem.onUpdate( dc );
    }
}
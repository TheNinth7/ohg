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
            :label => "Update Sitemap via Wi-Fi" 
            //:actionIcon => ACTION_ICON_COMMAND
        } );
    }

    // Trigger the sitemap sync
    public function onSelect() as Boolean {
        
        SitemapSyncDelegate.get().requestSync();

        SitemapRequest.get().stop();

        // Start sync
        try {
            // Newer API versions support displaying a custom message in the sync view
            if( Communications has :startSync2 ) {
                Communications.startSync2( { :message => "Sending command over Wi-Fi ..." } );
            } else {
                Communications.startSync();
            }
        } catch( ex ) {
            SitemapRequest.get().start();
            throw ex;
        }        
        
        // True indicates that this function has handled the user input event
        return true;
    }

    // Called by the base class to render the menu item.
    public function onUpdate( dc as Dc ) as Void {
        if( ConnectivityHandler.get().isOnWiFiConnection() ) {
            BaseSitemapMenuItem.setLabelColor( Constants.UI_COLOR_TEXT );
            BaseSitemapMenuItem.setActionIcon( ACTION_ICON_COMMAND );
        } else {
            BaseSitemapMenuItem.setLabelColor( Graphics.COLOR_LT_GRAY );
            BaseSitemapMenuItem.setActionIcon( null );
        }
        BaseSitemapMenuItem.onUpdate( dc );
    }
}
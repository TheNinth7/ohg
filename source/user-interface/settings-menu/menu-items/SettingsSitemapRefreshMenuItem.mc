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
            :label => "Sitemap Wi-Fi Refresh",
            :actionIcon => ACTION_ICON_COMMAND
        } );
    }
}
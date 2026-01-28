import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;

/*
 * A custom menu item that displays the age of the currently available
 * sitemap data, and provides an option to update it via WiFi.
 */
class SettingsSitemapAgeMenuItem extends SettingsTextMenuItem {

    /*
    * Constructor.
    * Initializes the superclass with the label and sublabel.
    */
    public function initialize() {
        SettingsTextMenuItem.initialize( 
            "Sitemap Age",
            "Current age: " + getSitemapAge()
        );
    }

    // Returns a formatted version of the current sitemap age
    private function getSitemapAge() as String {
        var duration = SitemapStore.getSitemapAge();
        if( duration != null ) {
            if( duration.value() > 59 ) {
                return TimeFormatting.formatDuration( duration, 4 );
            } else {
                return "< 1 min";
            }
        } else {
            return "n/a";
        }
    }

    /*
    * Called by the superclass to handle drawing.
    * Also updates the sitemap age.
    */
    public function onUpdate( dc as Dc ) as Void {
        setSubLabel( getSitemapAge() );
        SettingsTextMenuItem.onUpdate( dc );
    }
}
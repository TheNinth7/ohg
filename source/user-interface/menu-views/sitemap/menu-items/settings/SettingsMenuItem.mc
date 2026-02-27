import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents the settings menu.
 * On button-based devices, the settings menu is a parallel menu to the homepage menu, 
 * accessible by scrolling past the edges—see HomepageMenuDelegate for details.
 * On touch devices, however, the settings menu appears as a regular menu item 
 * within the homepage menu, using this menu item class.
 */

(:exclForSettingsFooter)
class SettingsMenuItem extends BaseSitemapMenuItem {

    // Singleton accessor
    private static var _instance as SettingsMenuItem?;
    public static function get() as SettingsMenuItem {
        if( _instance == null ) {
            _instance = new SettingsMenuItem();
        }
        return _instance as SettingsMenuItem;
    }

    // Constructor
    private function initialize() {
        // To offset this menu item from the sitemap menu items
        // the font is colored in light grey
        BaseSitemapMenuItem.initialize( { 
            :id => "__settings__",
            :icon => Rez.Drawables.menuSettings,
            :label => "Settings",
            :labelColor => ThemeManager.current.stateColor
        } );
    }

    // On select, show the settings
    public function onSelect() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_LEFT );
        return true;
    }
}
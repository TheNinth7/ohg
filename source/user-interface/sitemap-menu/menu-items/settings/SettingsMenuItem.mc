import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents the settings menu.
 * On button-based devices, the settings menu is a parallel menu to the homepage menu, 
 * accessible by scrolling past the edges—see HomepageMenuDelegate for details.
 * On touch devices, however, the settings menu appears as a regular menu item 
 * within the homepage menu, using this menu item class.
 */

(:exclForButton)
class SettingsMenuItem extends BaseViewMenuItem {

    // Constructor
    public function initialize( parentMenu as CustomMenu ) {
        // To offset this menu item from the sitemap menu items
        // the font is colored in light grey
        BaseViewMenuItem.initialize( { 
            :parentMenu => parentMenu,
            :id => "__settings__",
            :icon => Rez.Drawables.menuSettings,
            :label => "Settings",
            :labelColor => Graphics.COLOR_LT_GRAY
        } );
    }

    // On select, show the settings
    public function onSelectImpl() as Void {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_LEFT );
    }
}
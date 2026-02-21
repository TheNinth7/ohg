import Toybox.Lang;
import Toybox.Graphics;

/*
 * The default `Theme` implementation inherits all default values.
 */
(:glance)
class Theme extends NightModeTheme {
    private function initialize() { NightModeTheme.initialize(); }

    public static function init() as Void {
        Theme.update();
    }

    public static function update() as Void {
        if( NightModeTheme.isNightModeEnabled() ) {
            NightModeTheme.setDarkTheme();
            DefaultTheme.focusedMenuItemTextColor = Graphics.COLOR_BLACK;
            DefaultTheme.focusedMenuItemStateColor = Graphics.COLOR_DK_GRAY;
            DefaultTheme.focusedMenuItemBackgroundColor = Graphics.COLOR_WHITE;
        } else {
            NightModeTheme.setLightTheme();
            DefaultTheme.focusedMenuItemTextColor = Graphics.COLOR_WHITE;
            DefaultTheme.focusedMenuItemStateColor = Graphics.COLOR_LT_GRAY;
            DefaultTheme.focusedMenuItemBackgroundColor = Graphics.COLOR_BLACK;
        }
    }
}
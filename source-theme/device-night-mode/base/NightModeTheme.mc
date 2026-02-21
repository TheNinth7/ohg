import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;
import Rez.Styles;

/*
 * The default `Theme` implementation inherits all default values.
 */
(:glance)
class NightModeTheme extends DefaultTheme {
    protected function initialize() { DefaultTheme.initialize(); }

    public static function init() as Void {
        NightModeTheme.update();
    }

    public static function isNightModeEnabled() as Boolean {
        var deviceSettings = System.getDeviceSettings();
        return deviceSettings has :isNightModeEnabled && deviceSettings.isNightModeEnabled;
    }

    public static function update() as Void {
        if( NightModeTheme.isNightModeEnabled() ) {
            setDarkTheme();
        } else {
            setLightTheme();
        }
    }

    public static function setLightTheme() as Void {
        DefaultTheme.useLightTheme = true;
        DefaultTheme.textColor = Graphics.COLOR_BLACK;
        DefaultTheme.backgroundColor = Graphics.COLOR_WHITE;
        DefaultTheme.stateColor = Graphics.COLOR_DK_GRAY;
        DefaultTheme.menuTitleBackgroundColor = 0xDEDFDE;
        DefaultTheme.menuItemBackgroundColor = Graphics.COLOR_WHITE;
    }

    public static function setDarkTheme() as Void {
        DefaultTheme.useLightTheme = false;
        DefaultTheme.textColor = Graphics.COLOR_WHITE;
        DefaultTheme.backgroundColor = Graphics.COLOR_BLACK;
        DefaultTheme.stateColor = Graphics.COLOR_LT_GRAY;
        DefaultTheme.menuTitleBackgroundColor = 0x212021;
        DefaultTheme.menuItemBackgroundColor = Graphics.COLOR_BLACK;
    }

}
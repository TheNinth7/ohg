import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Config specific to button-based Edge devices.
*/
class Config extends EdgeConfig {
    protected function initialize() { EdgeConfig.initialize(); }

    // On Edge devices, the connection mode indicator is displayed below
    // the title text, so the title text is positioned higher
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.27;

    // Show menu item dividers
    // On the button-based x40 devices, there is a native focus indicator
    // that overlaps the divider, therefore we do not show it.
    public static const UI_MENU_ITEM_SHOW_DIVIDER as Boolean = false;

    // Note: Static functions cannot access inherited static constants.
    // Therefore, any constant that is required in a static function
    // must be explicitly defined in each Config implementation.
    public static const UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR as Boolean = BaseConfig.UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR;

    // Menu item padding is increased, due to the rounded rectangle focus indicator
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.05;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.05;

}
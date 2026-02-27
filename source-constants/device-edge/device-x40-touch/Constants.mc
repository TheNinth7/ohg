import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants for touch-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {

    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // On Edge devices, the connection mode indicator is displayed below
    // the title text, so the title text is positioned higher
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.27;

    // Show menu item dividers
    public static const UI_MENU_ITEM_SHOW_DIVIDER as Boolean = true;

    // Note: Static functions cannot access inherited static constants.
    // Therefore, any constant that is required in a static function
    // must be explicitly defined in each Constants implementation.
    public static const UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR as Boolean = DefaultConstants.UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR;

    // Padding is less then on button-based device, since touch-based
    // devices do not have a focus indicator that takes up space around
    // the focused menu item
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.025;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.025;

}
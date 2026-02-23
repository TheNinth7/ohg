import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants for touch-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {

    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // Show menu item dividers
    public static const UI_MENU_ITEM_SHOW_DIVIDER as Boolean = true;

    // Padding is less then on button-based device, since touch-based
    // devices do not have a focus indicator that takes up space around
    // the focused menu item
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.025;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.025;

}
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants specific to button-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {
    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // Padding is increased, due to the rounded rectangle focus indicator
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.05;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.05;

}
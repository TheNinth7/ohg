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

    /*
    * In the simulator, the Edge 540 and 840 do not show a focus indicator.
    * Therefore, in debug builds, a colored background is added to make
    * it easier to work with the app in the simulator.
    * On real devices, a focus indicator is present, so coloring the
    * background is not required.
    */
    (:debug)
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = 0x04395E; // greyish dark blue
}
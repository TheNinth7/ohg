import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants specific to button-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {
    protected function initialize() { EdgeDefaultConstants.initialize(); }

    /*
    * Button-based Edge devices require a colored background for the focused item,
    * as they do not provide any other visual indication of focus.
    */
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = 0x04395E; // greyish dark blue
}
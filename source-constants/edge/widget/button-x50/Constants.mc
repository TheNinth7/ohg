import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants specific to button-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {
    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // Positions of the keys, for drawing input hints
    // Corresponds to CustomView.InputHints enumeration
    // 0=ENTER
    // 1=BACK
    // 2=UP
    // 3=DOWN
    // + positive position indicates y coordinate on the right side of the screen
    // - negative position indicates y coordinate on the left side of the screen
    public static const UI_INPUT_HINT_POSITIONS as Array<Number> = [
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.125 ).toNumber(), 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.675 ).toNumber(), 
        -( DefaultConstants.UI_SCREEN_HEIGHT * 0.495 ).toNumber(), 
        -( DefaultConstants.UI_SCREEN_HEIGHT * 0.755 ).toNumber() 
    ];

    /*
    * Button-based Edge devices require a colored background for the focused item,
    * as they do not provide any other visual indication of focus.
    */
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = 0x04395E; // greyish dark blue
}
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants specific to button-based Edge devices.
*/
class EdgeX50ButtonDefaultConstants extends EdgeDefaultConstants {
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
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.755 ).toNumber(), 
        -( DefaultConstants.UI_SCREEN_HEIGHT * 0.495 ).toNumber(), 
        -( DefaultConstants.UI_SCREEN_HEIGHT * 0.755 ).toNumber() 
    ];

    // Padding is increased, due to the rounded rectangle focus indicator
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.05;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.05;
}
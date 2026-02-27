import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Constants specific to button-based Edge devices.
*/
class Constants extends EdgeDefaultConstants {
    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // If set to true, a vertical strip is rendered on the left side
    // of the menu item. This serves as a workaround for a firmware bug on the
    // Edge 550 and 850 that prevents the focus indicator from being rendered properly.
    //
    // On these devices, the native focus indicator is a frame drawn on top of the
    // menu item in the system-defined background color (which cannot be changed
    // from the CIQ app). The frame adapts to the system’s dark and light display modes.
    //
    // The intended behavior is that the CIQ app fills the menu item with a contrasting
    // color to highlight the focused item. However, CustomMenuItem.isFocused() is
    // faulty on these devices, so this mechanism does not work as expected.
    //
    // See also:
    // Bug report: https://github.com/openhab/openhab-garmin/issues/267
    // Workaround implementation: https://github.com/openhab/openhab-garmin/issues/268
    public static const UI_MENU_FOCUS_EDGEX50_WORKAROUND as Boolean = true;

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
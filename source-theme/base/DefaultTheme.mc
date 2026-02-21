import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Rez.Styles;

(:glance)
class DefaultTheme {

    protected function initialize() {}

    // Current state of the night mode, for use by other classes
    // to adapt their behavior (e.g. choosing different bitmaps)
    public static var useLightTheme as Boolean = false;
    
    // MAIN COLOR DEFINITIONS
    
    // Text color
    public static var textColor as ColorType = Graphics.COLOR_WHITE;

    // Color for states
    public static var stateColor as ColorType = Graphics.COLOR_LT_GRAY;

    // Color for on/active states (openHAB orange)
    public static var onColor as ColorType = 0xE64E19;

    // Color for displaying errors
    public static var errorColor as ColorType = Graphics.COLOR_RED;

    // General background color
    public static var backgroundColor as ColorType = Graphics.COLOR_BLACK;

    // Background color of the menu titles
    public static var menuTitleBackgroundColor as Number = 0x212021;

    // Background color of menu items. Some newer devices, such as the Fenix 8 series,
    // provide a colored background for the focused item. Therefore, the menu item
    // background color is set to transparent to allow the focus background to show through.
    public static var menuItemBackgroundColor as ColorType = Graphics.COLOR_TRANSPARENT;

    // Color of focused menu items. Is for example used on Edge devices to support the focus indicator
    public static var focusedMenuItemTextColor as ColorType = textColor;
    public static var focusedMenuItemStateColor as ColorType = stateColor;
    public static var focusedMenuItemBackgroundColor as ColorType = menuItemBackgroundColor;

    public static function init() as Void {}

    public static function update() as Void {}

}
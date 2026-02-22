import Toybox.Lang;
import Toybox.Graphics;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime.
 *
 * BaseTheme defines a set of common colors shared by all themes.
 *
 * See the Theme interface in Theme.mc for documentation of
 * each member.
 */
class BaseTheme {
    
    // Constructor
    // This is an abstract class, so it is declared as protected.
    protected function initialize() {}

    // openHAB orange
    public var onColor as ColorType = 0xE64E19;

    public var errorColor as ColorType = Graphics.COLOR_RED;

    // Background color of menu items. Some newer devices, such as the Fenix 8 series,
    // provide a colored background for the focused item. Therefore, the menu item
    // background color is set to transparent to allow the focus background to show through.
    public var menuItemBackgroundColor as ColorType = Graphics.COLOR_TRANSPARENT;

}
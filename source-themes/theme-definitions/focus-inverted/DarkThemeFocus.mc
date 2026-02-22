import Toybox.Lang;
import Toybox.Graphics;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime.
 *
 * The dark focus theme is used to style the menu item that is
 * currently focused when the dark theme is active.
 *
 * This implementation is used for Edge x50 devices. The goal
 * is to invert the background and font colors of the active theme.
 * Therefore, the focus variant for the dark theme is based on
 * the light theme, with the only modification being a solid
 * menu item background instead of a transparent one.
 */
 class DarkThemeFocus extends LightTheme {

    public var menuItemBackgroundColor as ColorType = backgroundColor;

    public function initialize() {
        LightTheme.initialize();
    }
}
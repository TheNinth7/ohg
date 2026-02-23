import Toybox.Lang;
import Toybox.Graphics;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime. This also includes icons
 * whose colors must be adapted to the active theme.
 *
 * The light focus theme is used to style the menu item that is
 * currently focused when the light theme is active.
 *
 * This implementation uses a blue background as the focus
 * indicator and is only applied in the simulator for
 * Edge x40 devices.
 */
class LightThemeFocus extends LightTheme {

    public function initialize() {
        LightTheme.initialize();
    }

    (:debug)
    public var backgroundColor as ColorType = 0xA6D4F5;

    (:debug)
    public var menuItemBackgroundColor as ColorType = 0xA6D4F5;

}
import Toybox.Lang;
import Toybox.Graphics;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime.
 *
 * The dark focus theme is used to style the menu item that is
 * currently focused when the dark theme is active.
 *
 * This implementation uses a blue background as the focus
 * indicator and is only applied in the simulator for
 * Edge x40 devices.
 */
 class DarkThemeFocus extends DarkTheme {

    public function initialize() {
        DarkTheme.initialize();
    }

    (:debug)
    public var backgroundColor as ColorType = 0x04395E;
    (:debug)
    public var menuItemBackgroundColor as ColorType = 0x04395E;

}
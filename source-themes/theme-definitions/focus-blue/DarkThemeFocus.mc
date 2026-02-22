import Toybox.Lang;
import Toybox.Graphics;

class DarkThemeFocus extends DarkTheme {

    public function initialize() {
        DarkTheme.initialize();
    }

    (:debug)
    public var backgroundColor as ColorType = 0x04395E;
    (:debug)
    public var menuItemBackgroundColor as ColorType = 0x04395E;

}
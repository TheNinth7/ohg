import Toybox.Lang;
import Toybox.Graphics;

class LightThemeFocus extends DarkTheme {

    public var menuItemBackgroundColor as ColorType = backgroundColor;

    public function initialize() {
        DarkTheme.initialize();
    }
}
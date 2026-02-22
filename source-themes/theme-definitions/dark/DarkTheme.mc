import Toybox.Lang;
import Toybox.Graphics;

class DarkTheme extends BaseTheme {

    public var textColor as ColorType = Graphics.COLOR_WHITE;

    public var stateColor as ColorType = Graphics.COLOR_LT_GRAY;

    public var backgroundColor as ColorType = Graphics.COLOR_BLACK;

    public var menuTitleBackgroundColor as ColorType = 0x212021;

    public var iconHourglass as ResourceId = Rez.Drawables.iconHourglassWhite;

    public function initialize() {
        BaseTheme.initialize();
    }
}
import Toybox.Lang;
import Toybox.Graphics;

class LightTheme extends BaseTheme {

    public var textColor as ColorType = Graphics.COLOR_BLACK;

    public var stateColor as ColorType = Graphics.COLOR_DK_GRAY;

    public var backgroundColor as ColorType = Graphics.COLOR_WHITE;

    public var menuTitleBackgroundColor as ColorType = 0xDEDFDE;

    public var iconHourglass as ResourceId = Rez.Drawables.iconHourglassBlack;

    public function initialize() {
        BaseTheme.initialize();
    }

}
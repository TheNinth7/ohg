import Toybox.Lang;
import Toybox.Graphics;
import Rez.Styles;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime. This also includes icons
 * whose colors must be adapted to the active theme.
 *
 * The dark theme is the default on devices that do not support
 * night mode (currently all watches). On devices that support
 * night mode (currently all Edge cycling computers), it is
 * used when night mode is active.
 */
class DarkTheme extends DefaultTheme {

    //public var textColor as ColorType = 0xFFFBFF;
    public var backgroundColor as ColorType = 0x31353A;
    public var menuTitleBackgroundColor as ColorType = 0x212429;
    public var menuTitleDividerColor as ColorType = 0xC5C2C5;
    public var menuItemDividerColor as ColorType = 0x171417;

    public function initialize() {
        DefaultTheme.initialize();
    }

}
import Toybox.Lang;
import Toybox.Graphics;

class BaseNightModeThemeManager extends BaseThemeManager {

    public static var light as Theme = new LightTheme();

    public static var current as Theme = getCurrent();
    public static var focused as Theme = current;

    private static function getCurrent() as Theme {
        return NightModeTracker.get().isNightModeEnabled()
               ? BaseThemeManager.dark
               : light;
    }

    public static function update() as Void {
        BaseThemeManager.update();
        current = getCurrent();
        focused = current;
    }

    protected function initialize() {
        BaseThemeManager.initialize();
    }

}
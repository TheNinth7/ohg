import Toybox.Lang;
import Toybox.Graphics;

class ThemeManager extends BaseNightModeThemeManager {
    
    private static var darkFocus as Theme = new DarkThemeFocus();
    private static var lightFocus as Theme = new LightThemeFocus();

    public static var focused as Theme = getFocused();

    private static function getFocused() as Theme {
        return NightModeTracker.get().isNightModeEnabled()
               ? darkFocus
               : lightFocus;
    }

    public static function update() as Void {
        BaseNightModeThemeManager.update();
        focused = getFocused();
    }

    private function initialize() {
        BaseNightModeThemeManager.initialize();
    }

}
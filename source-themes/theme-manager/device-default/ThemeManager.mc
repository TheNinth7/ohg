import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also handles
 * switching between them.
 *
 * This implementation is based on BaseThemeManager,
 * which always uses the dark theme and does not provide
 * any switching logic.
 */
class ThemeManager extends BaseThemeManager {
    
    private function initialize() {
        BaseThemeManager.initialize();
    }

}
import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also
 * manages switching between them.
 *
 * This implementation of the base night mode theme manager
 * does not add additional functionality. It is used on
 * devices that do not require a focus indicator,
 * such as touch-based Edge devices.
 */
class ThemeManager extends BaseNightModeThemeManager {
    
    // Constructor
    // Declared as private to prevent instantiation
    private function initialize() {
        BaseNightModeThemeManager.initialize();
    }

}
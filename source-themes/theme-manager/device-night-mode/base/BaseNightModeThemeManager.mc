import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also handles
 * switching between them.
 *
 * This base implementation for devices with night mode
 * support switches between the light theme (standard)
 * and the dark theme (night mode).
 */
class BaseNightModeThemeManager extends BaseThemeManager {

    // Light theme is instantiated here and reused
    public static var light as Theme = new LightTheme();

    // Override the current and focus theme
    public static var current as Theme = getCurrent();
    public static var focused as Theme = current;

    // Internal function to determine the current theme
    // Used when defining the member above and in onUpdate below
    private static function getCurrent() as Theme {
        return NightModeTracker.get().isNightModeEnabled()
               ? BaseThemeManager.dark
               : light;
    }

    // Public function that updates the current theme
    public static function update() as Void {
        BaseThemeManager.update();
        current = getCurrent();
        focused = current;
    }

    // Constructor
    // Declared as protected.
    // These classes are not intended to be instantiated directly.
    // The base class constructor is protected so that subclasses
    // can invoke it. The constructors of the concrete subclasses
    // are private to prevent external instantiation.
    protected function initialize() {
        BaseThemeManager.initialize();
    }

}
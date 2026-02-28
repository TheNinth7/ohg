import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also
 * manages switching between them.
 *
 * This implementation of the base night mode theme manager
 * adds switching of a dedicated focus theme to provide
 * different styling for the currently focused menu item.
 *
 * It is used on button-based devices, which require a
 * visual indicator of the focused menu item when scrolling
 * through the menu using buttons. This also applies to
 * devices that provide both control buttons and a touch
 * screen, such as the Edge 840 and 850.
 */
class ThemeManager extends BaseNightModeThemeManager {
    
    // The two themes are instantiated once here and reused
    private static var darkFocus as Theme = new DarkThemeFocus();
    private static var lightFocus as Theme = new LightThemeFocus();

    // Override of the focused theme
    public static var focused as Theme = getFocused();

    // Internal function to determine the current focus theme
    // Used when defining the member above and in update() below
    private static function getFocused() as Theme {
        // If the Edge x50 focus indicator workaround is active,
        // the focused menu item is rendered the same way as other menu items.
        // Otherwise, the focus theme is applied.
        // See the Config class for details about the Edge x50 devices.
        return Config.UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR
               ? NightModeTracker.get().isNightModeEnabled()
                 ? BaseNightModeThemeManager.dark
                 : BaseNightModeThemeManager.light
               : NightModeTracker.get().isNightModeEnabled()
                    ? darkFocus
                    : lightFocus;
    }

    // Public function to update the current theme
    // Updates the base class and then the focus theme
    public static function update() as Void {
        BaseNightModeThemeManager.update();
        focused = getFocused();
    }

    // Constructor
    // Declared as private to prevent instantiation
    private function initialize() {
        BaseNightModeThemeManager.initialize();
    }

}
import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also handles switching between them.
 *
 * This base implementation uses the dark theme only and does not provide
 * any switching logic.
 */
 class BaseThemeManager {
    
    // The dark theme is created once here and also used
    // by subclasses
    public static var dark as Theme = new DarkTheme();

    // The main theme
    public static var current as Theme = dark;
    
    // The theme used for focused menu items
    public static var focused as Theme = current;

    // Called by the OhApp when the conditions for
    // choosing the theme shall be re-evaluated
    public static function update() as Void {}

    protected function initialize() {}
}
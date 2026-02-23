import Toybox.Lang;
import Toybox.Graphics;

/*
 * The ThemeManager keeps track of the current theme.
 * On devices that support multiple themes, it also handles
 * switching between them.
 *
 * This implementation always uses the default theme 
 * and does not provide any switching logic.
 */
class ThemeManager {

    // The main theme
    public static var current as Theme = new DefaultTheme();
    
    // The theme used for focused menu items
    public static var focused as Theme = current;

    // Called by the OhApp when the conditions for
    // choosing the theme shall be re-evaluated
    public static function update() as Void {}

    // Constructor
    // Declared private to prevent instantiation of this class
    private function initialize() {}

}
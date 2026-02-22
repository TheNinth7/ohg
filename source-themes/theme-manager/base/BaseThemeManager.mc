import Toybox.Lang;
import Toybox.Graphics;

class BaseThemeManager {
    
    public static var dark as Theme = new DarkTheme();

    public static var current as Theme = dark;
    public static var focused as Theme = current;

    public static function update() as Void {}

    protected function initialize() {}
}
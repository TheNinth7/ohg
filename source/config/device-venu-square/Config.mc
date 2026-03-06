import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Constant overrides for the Venu x1.
 */
class Config extends BaseConfig {
    protected function initialize() { BaseConfig.initialize(); }

    // On rectangular screens no gap between title and menu items is
    // needed, therefore the title height is set to the full amount
    public static const UI_MENU_TITLE_CLIP_FACTOR as Float = 1.0;

    // On rectangular screens, the connection mode indicator is displayed below
    // the title text, so the title text is positioned higher
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.3;

    // Currently only applied for rectangular screens
    public static const UI_MENU_TITLE_CONNECTION_INDICATOR_POSITION as Float = 0.625;
}
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

/*
 * Base config for all Venu devices with rectangular screen.
 */
class VenuSquareConfig extends BaseConfig {
    protected function initialize() { BaseConfig.initialize(); }

    // On rectangular screens no gap between title and menu items is
    // needed, therefore the title height is set to the full amount
    public static const UI_MENU_TITLE_CLIP_FACTOR as Float = 1.0;

    // On rectangular screens, the connection mode indicator is displayed below
    // the title text, so the title text is positioned higher
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.3;

    // Same relative position as above.
    // Vertical position of the connection mode indicator in menus 
    // on rectangular screens for round screens the positions are 
    // hardcoded and work well for all devices
    public static const UI_MENU_TITLE_CMI_POSITION as Float = 0.625;

}
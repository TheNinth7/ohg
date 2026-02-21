import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Constant overrides for the Venu x1.
 */
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }

    // On the rectangle screens no gap between title and menu items is
    // needed, therefore the title height is set to the full amount
    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 1.0;
}
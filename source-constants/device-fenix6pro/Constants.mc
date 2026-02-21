import Toybox.Lang;

/*
* Constants for the Fenix 6 Pro series.
*/
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }
    
    /*
    * The Fenix 6 Pro lacks the vertical bar on the left side of the menu,
    * so it requires additional left padding to balance the default 6% right padding.
    */
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.06;
}
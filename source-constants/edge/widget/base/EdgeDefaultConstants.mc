import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Default values for all Edge devices.
* Constants implementations vary between button-based and touch-based devices.
*/
class EdgeDefaultConstants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }

    // Default height of title and footer is too high
    public static const UI_MENU_TITLE_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_WIDTH * 0.35 ).toNumber();
    public static const UI_MENU_FOOTER_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.2 ).toNumber();

    // On the Edge devices no gap between title and menu items is
    // needed, therefore the title height is set to the full amount (defined above)
    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 1.0;

    // Edge devices need larger fonts
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_LARGE;  
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY];

    // Less padding but more spacing
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.01;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.01;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.05;

    // Also the item heights are set differently and defined as proportion
    // of screen width, not height. This allows to fit more items on devices
    // with taller displays (such as 1040/1050)
    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_WIDTH * 0.25 ).toNumber();
    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_WIDTH * 0.35 ).toNumber();

    // If an icon is present, the amount of space defined below will be reserved,
    // to allow alignment of labels that have icons of different widths.
    public static const UI_MENU_ITEM_ICON_WIDTH as Number = 
        ( DefaultConstants.UI_SCREEN_WIDTH * 0.13 ).toNumber();

    // This offset in pixel is applied to the positioning of the menu item label
    // Positive means the label is shifted down, negative means up
    public static const UI_MENU_ITEM_LABEL_OFFSET as Number =
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.011 ).toNumber();

    // Also for the error view we add FONT_LARGE
    public static const UI_ERROR_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];
    public static const UI_PICKER_TITLE_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];
}
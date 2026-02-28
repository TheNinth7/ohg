import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Default values for all Edge devices.
* Config implementations vary between button-based and touch-based devices.
*/
class EdgeBaseConfig extends BaseConfig {
    protected function initialize() { BaseConfig.initialize(); }

    // Heights of menu elements
    public static const UI_MENU_TITLE_HEIGHT as Number = 
        ( BaseConfig.UI_SCREEN_WIDTH * 0.25 ).toNumber();
    public static const UI_MENU_FOOTER_HEIGHT as Number = UI_MENU_TITLE_HEIGHT;
    public static const UI_MENU_ITEM_HEIGHT as Number = UI_MENU_TITLE_HEIGHT;
    public static const UI_SETTINGS_ITEM_HEIGHT as Number = UI_MENU_ITEM_HEIGHT;

    // On the Edge devices no gap between title and menu items is
    // needed, therefore the title height is set to the full amount (defined above)
    public static const UI_MENU_TITLE_CLIP_FACTOR as Float = 1.0;

    // On Edge devices, the connection mode indicator is displayed below
    // the title text, so the title text is positioned higher
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.29;

    // Edge devices need larger fonts
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_MEDIUM;  
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY];

    // Less padding but more spacing
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.01;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.02;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.05;

    // If an icon is present, the amount of space defined below will be reserved,
    // to allow alignment of labels that have icons of different widths.
    public static const UI_MENU_ITEM_ICON_WIDTH as Number = 
        ( BaseConfig.UI_SCREEN_WIDTH * 0.11 ).toNumber();

    // This offset in pixel is applied to the positioning of the menu item label
    // Positive means the label is shifted down, negative means up
    public static const UI_MENU_ITEM_LABEL_OFFSET as Number =
        ( BaseConfig.UI_SCREEN_WIDTH * 0.015 ).toNumber();

    // This offset in pixel is applied to the positioning of the label
    // and sublabel in the SettingsMenuTextItem.
    // Positive means the label is shifted down, negative means up
    public static const UI_MENU_SETTINGS_TEXT_ITEM_LABEL_OFFSET as Number =
        ( BaseConfig.UI_SCREEN_WIDTH * 0.01 ).toNumber();

    // Height and width of the toggle switch relative to the menu item height
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT as Number = ( UI_MENU_ITEM_HEIGHT * 0.65 ).toNumber();
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH as Number = ( UI_MENU_ITEM_HEIGHT * 0.37 ).toNumber();

    // Also for the error view we add FONT_LARGE
    public static const UI_ERROR_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];
    public static const UI_PICKER_TITLE_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    // If true, anti-aliasing is used when drawing primitives (lines, circles, rectangulars)
    // This for example is used for the toggle switch and the input hints
    // Anti-aliasing on Edge devices seem to leave white artifacts and the results
    // look better without
    public static const UI_USE_ANTI_ALIASING as Boolean = false;

}
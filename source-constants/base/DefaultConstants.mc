import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Defines application constants and their default values.
 *
 * Access these values via the `Constants` class.
 * The base `Constants` implementation provides the defaults,
 * while device-specific subclasses can override particular values.
 */
class DefaultConstants {
    protected function initialize() {}

    // Timer in seconds after which a state is considered stale
    // The app repeatedly polls the sitemap. If no new sitemap has been
    // received from the state expiration time, it will either go into
    // Wifi mode or offline mode. Also the Wifi mode will go into offline
    // mode if for the same amount of time no successful Wifi connection
    // was possible
    public static const STATE_EXPIRATION_TIME as Number = 10;

    // Height of the screen, used in calculation of other constants
    public static const UI_SCREEN_HEIGHT as Number = System.getDeviceSettings().screenHeight;
    public static const UI_SCREEN_WIDTH as Number = System.getDeviceSettings().screenWidth;

    // MAIN COLOR DEFINITIONS
    
    // Active represents devices that are on/active
    public static const UI_COLOR_ACTIVE as ColorType = 0xE64E19; // openHAB orange
    
    // Inactive represents devices that are off/inactive,
    // as well as non-actionable states
    public static const UI_COLOR_INACTIVE as ColorType = Graphics.COLOR_LT_GRAY;
    
    // Actionable represents states that can be changed in the app
    public static const UI_COLOR_ACTIONABLE as ColorType = Graphics.COLOR_LT_GRAY; 
    // 0x6F88FF mid-level blue, our choice
    // 0x8FA0F0 less saturated blue
    // 0x1976d2 more saturated blue 

    // For confirming an action
    public static const UI_COLOR_POSITIVE as ColorType = 0x388E3C;
    
    // For cancelling an action
    public static const UI_COLOR_DESTRUCTIVE as ColorType = 0x9F1C1C;

    // For messages related to WiFi, a blue that fits with openHAB orange
    public static const UI_COLOR_WIFI as ColorType = 0x1F6AE1;

    // Foreground and background colors
    public static const UI_COLOR_TEXT as ColorType = Graphics.COLOR_WHITE;
    public static const UI_COLOR_BACKGROUND as ColorType = Graphics.COLOR_BLACK;

    // Positions of the keys, for drawing input hints
    // Corresponds to CustomView.InputHints enumeration
    // 0=ENTER
    // 1=BACK
    // 2=UP
    // 3=DOWN
    (:exclForScreenRectangular)
    public static const UI_INPUT_HINT_POSITIONS as Array<Number> = [30, 330, 180, 210];
    (:exclForScreenRound)
    // + positive position indicates y coordinate on the right side of the screen
    // - negative position indicates y coordinate on the left side of the screen
    public static const UI_INPUT_HINT_POSITIONS as Array<Number> = [
        ( UI_SCREEN_HEIGHT * 0.125 ).toNumber(), 
        ( UI_SCREEN_HEIGHT * 0.675 ).toNumber(), 
        -( UI_SCREEN_HEIGHT * 0.4 ).toNumber(), 
        -( UI_SCREEN_HEIGHT * 0.7 ).toNumber() 
    ];

    // Height of menu title and footer
    // If set to -1, the default height will be applied
    public static const UI_MENU_TITLE_HEIGHT as Number = -1;
    public static const UI_MENU_FOOTER_HEIGHT as Number = -1;

    /*
    * Factor determining the height of the background-painted region 
    * in the title's drawing context (`Dc`). By default, 80% of the 
    * available title area is filled, leaving 20% as spacing above 
    * the menu items.
    */
    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 0.8;

    // Font to be used in the menu title
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_SMALL;  

    // Background color of the menu titles
    public static const UI_MENU_TITLE_BACKGROUND_COLOR as Number = 0x212021;
    
    // Item height can be set individually for sitemap menu and settings menu
    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.2 ).toNumber();
    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.3 ).toNumber();


    // List of fonts available for menu item labels and state text.
    // An appropriate font size is chosen based on available space and text length.
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    /*
    * These factors determine the spacing of menu item components 
    * based on the total width of the item's `Dc`.
    *
    * Note: On some devices, the `Dc` width differs between the simulator 
    * and actual hardware, where it often appears wider.
    *
    * Below is an example of how the spacings (represented with underscores) 
    * are applied around the elements (in angle brackets):
    *
    * _PL_ [ <icon> _SP_ ] <label> [ [ _SP_ [ <stateString> ] [ _SSP_ ] [ <stateDrawable> ] [ _SP_ ] [ <actionBitmap> ] _PR_
    *
    * _PL_ / Padding Left:           Space applied to the left edge of the menu item.
    * _PR_ / Padding Right:          Space applied to the right edge of the menu item.
    * _SP_ / Spacing:                Space between primary elements (icon, label, state).
    * _SSP_ / State Spacing:         Space between state elements (text, drawable, action icon).
    */
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.015; // _PL_
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.06; // _PR_
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.06; // _SP_
    public static const UI_MENU_ITEM_STATE_SPACING_FACTOR as Float = 0.03; // _SSP_


    // If an icon is present, the amount of space defined below will be reserved,
    // to allow alignment of labels that have icons of different widths.
    public static const UI_MENU_ITEM_ICON_WIDTH as Number = 
        ( UI_SCREEN_WIDTH * 0.09 ).toNumber();

    // This offset in pixel is applied to the positioning of the menu item icon
    // Positive means the icon is shifted down, negative means up
    public static const UI_MENU_ITEM_ICON_OFFSET as Number = 0;

    // This offset in pixel is applied to the positioning of the menu item label
    // Positive means the label is shifted down, negative means up
    public static const UI_MENU_ITEM_LABEL_OFFSET as Number = 0;

    /*
    * Background color of menu items. Some newer devices, such as the Fenix 8 series,
    * provide a colored background for the focused item. Therefore, the menu item
    * background color is set to transparent to allow the focus background to show through.
    */
    public static const UI_MENU_ITEM_BG_COLOR as ColorType = Graphics.COLOR_TRANSPARENT;
    
    /*
    * Allows specifying a distinct background color for focused menu items.
    * This is useful on devices like the Edge 540 and 840, which in the simulator
    * do not provide a built-in focus indicator (see ../edge/widget/button-x40/Constants.mc).
    * Setting this to transparent disables the custom focus background.
    */
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = Graphics.COLOR_TRANSPARENT;

    // Height and width of the toggle switch relative to the menu item height
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT as Number = ( UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH as Number = ( UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();

    // List of fonts to be used by the error view
    public static const UI_ERROR_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    // List of fonts to be used by the picker for the title
    public static const UI_PICKER_TITLE_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];
}
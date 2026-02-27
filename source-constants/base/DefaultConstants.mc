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

    /******* SITEMAP REQUEST *******/ 

    // Timer in seconds after which a state is considered stale
    // The app repeatedly polls the sitemap. If no new sitemap has been
    // received from the state expiration time, it will either go into
    // Wifi mode or offline mode. Also the Wifi mode will go into offline
    // mode if for the same amount of time no successful Wifi connection
    // was possible
    public static const STATE_EXPIRATION_TIME as Number = 10;


    /******* SCREEN INFO *******/ 

    // These constants store information on the screen,
    // for quick access everywhere in our code.

    // Screen dimensions, used in calculation of other constants
    public static const UI_SCREEN_HEIGHT as Number = System.getDeviceSettings().screenHeight;
    public static const UI_SCREEN_WIDTH as Number = System.getDeviceSettings().screenWidth;
    
    // Screen shape, rectangular or round
    public static const UI_SCREEN_SHAPE = System.getDeviceSettings().screenShape;

    
    /******* INPUT HINTS *******/ 

    // Positions of the device buttons, for drawing input hints
    // Corresponds to BaseControlView.InputHints enumeration
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


    /******* RENDERING *******/ 

    // If true, anti-aliasing is used when drawing primitives (lines, circles, rectangulars)
    // This for example is used for the toggle switch and the input hints
    public static const UI_USE_ANTI_ALIASING as Boolean = true;


    /******* MENU *******/ 

    // These constants control different parameters of the
    // menu implementation

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
    public static const UI_MENU_TITLE_CLIP_FACTOR as Float = 0.8;

    /*
    * Position of the title text.
    * The value is relative to the height of the clip area.
    * For example, 0.5 means the title text will be vertically
    * centered within the clip area.
    */
    public static const UI_MENU_TITLE_TEXT_POSITION as Float = 0.625;

    // Font to be used in the menu title
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_SMALL;  

    // Item height can be set individually for sitemap menu and settings menu
    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.2 ).toNumber();
    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.3 ).toNumber();

    // List of fonts available for menu item labels and state text.
    // An appropriate font size is chosen based on available space and text length.
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    // If set to true, a divider will be rendered at the bottom of each 
    // menu item. The color of the divider is set in Theme.menuItemDividerColor
    public static const UI_MENU_ITEM_SHOW_DIVIDER as Boolean = false;

    // UI_MENU_FOCUS_EDGEX50_SHOW_ALTERNATE_FOCUS_INDICATOR
    // If true, a vertical strip is rendered on the left side of the focused
    // menu item.
    //
    // UI_MENU_FOCUS_EDGEX50_SUPPRESS_FOCUS_INDICATOR
    // If true, the standard focus indicator theme is suppressed and the
    // focused menu item is rendered like a regular, unfocused item.
    //
    // These options provide a workaround for a firmware bug on the
    // Edge 550 and 850.
    //
    // See the following files for implementation details:
    // ../device-edge/widget/device-x50-button/device-550/Constants.mc
    // ../device-edge/widget/device-x50-button/device-850/Constants.mc
    public static const UI_MENU_FOCUS_EDGEX50_SHOW_ALTERNATE_FOCUS_INDICATOR as Boolean = false;
    public static const UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR as Boolean = false;

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

    // Height and width of the toggle switch relative to the menu item height
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT as Number = ( UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    public static const UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH as Number = ( UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();

    // This offset in pixel is applied to the positioning of the label
    // and sublabel in the SettingsMenuTextItem.
    // Positive means the label is shifted down, negative means up
    public static const UI_MENU_SETTINGS_TEXT_ITEM_LABEL_OFFSET as Number = 0;


    /******* CONTROL VIEWS *******/ 

    // List of fonts to be used by the picker for the title
    public static const UI_PICKER_TITLE_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];


    /******* ERROR VIEW *******/ 

    // List of fonts to be used by the error view
    public static const UI_ERROR_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

}
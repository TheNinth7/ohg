import Toybox.Lang;
import Toybox.Graphics;

/*
 * Themes define the color schemes used in the app and can
 * change dynamically at runtime. This also includes icons
 * whose colors must be adapted to the active theme.
 *
 * The Theme interface must be implemented by all themes and
 * defines the complete set of member variables that each
 * theme has to provide.
 */
typedef Theme as interface {
    
    // Text color
    var textColor as ColorType;

    // Color for states
    var stateColor as ColorType;

    // Color for on/active states
    var onColor as ColorType;

    // Color for displaying errors
    var errorColor as ColorType;

    // General background color
    var backgroundColor as ColorType;

    // Background color of the menu titles
    var menuTitleBackgroundColor as ColorType;

    // Background color of menu items. Some newer devices, such as the Fenix 8 series,
    // provide a colored background for the focused item. Therefore, the menu item
    // background color is set to transparent to allow the focus background to show through.
    var menuItemBackgroundColor as ColorType;

    // The icon shown on the loading screen
    var iconHourglass as ResourceId;

    // Play/pause icons
    var iconPlayButton as ResourceId;
    var iconPauseButton as ResourceId;
    var iconPlayMenuItem as ResourceId;
    var iconPauseMenuItem as ResourceId;

    // Next/previous icons
    var iconNextHint as ResourceId;
    var iconPreviousHint as ResourceId;
    var iconNext as ResourceId;
    var iconPrevious as ResourceId;

    // The bitmaps for displaying a ON/OFF toggle switch
    var onOffBitmaps as OnOffStateBitmaps;
    var smallOnOffBitmaps as SmallOnOffStateBitmaps; 
};
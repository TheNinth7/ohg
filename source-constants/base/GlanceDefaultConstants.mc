import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Defines glance-related constants and their default values.
 *
 * Access these values via the `GlanceConstants` class.
 * The base implementation provides the defaults, while device-specific
 * subclasses can override individual constants as needed.
 */
(:glance)
class GlanceDefaultConstants {
    protected function initialize() {}
    
    // The fonts available for the glance
    public static const UI_GLANCE_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE];

    public static const UI_FONT_COLOR = Graphics.COLOR_WHITE;
    
    // For night mode
    public static const UI_FONT_COLOR_NIGHT = Graphics.COLOR_WHITE;

    public static const UI_SCREEN_WIDTH as Number = System.getDeviceSettings().screenWidth;

    // This offset in pixel is applied to the positioning of glance text
    // Vertical: positive means the label is shifted down, negative means up
    public static const UI_GLANCE_TEXT_VERTICAL_OFFSET as Number =
        ( -1 * UI_SCREEN_WIDTH * 0.01 ).toNumber();

    // Horizontal: positive means the label is shifted right
    public static const UI_GLANCE_TEXT_HORIZONTAL_OFFSET as Number = 0;

}
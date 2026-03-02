import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* `GlanceConfig` uses a single implementation for all Edge devices.
*/
(:glance)
class GlanceConfig extends BaseGlanceConfig {
    protected function initialize() { BaseGlanceConfig.initialize(); }
    
    // Edge devices need larger fonts
    public static const UI_GLANCE_FONTS as Array<FontDefinition> = [Graphics.FONT_GLANCE];

    // The Edge devices use a white background for glances, so the font needs to be black
    public static const UI_FONT_COLOR = Graphics.COLOR_BLACK;

    // For night mode, the background is black and the font needs to be white
    public static const UI_FONT_COLOR_NIGHT = Graphics.COLOR_WHITE;

    // This offset in pixel is applied to the positioning of glance text
    // Vertical: positive means the label is shifted down, negative means up
    public static const UI_GLANCE_TEXT_VERTICAL_OFFSET as Number = 0;
    // Horizontal: positive means the label is shifted right
    public static const UI_GLANCE_TEXT_HORIZONTAL_OFFSET as Number = 
        ( System.getDeviceSettings().screenWidth * 0.03 ).toNumber();
        
}
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* `GlanceConstants` uses a single implementation for all Edge devices.
*/
(:glance)
class EdgeGlanceDefaultConstants extends GlanceDefaultConstants {
    protected function initialize() { GlanceDefaultConstants.initialize(); }
    
    // Edge devices need larger fonts
    public static const UI_GLANCE_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL];

    // This offset in pixel is applied to the positioning of glance text
    // Positive means the label is shifted down, negative means up
    public static const UI_GLANCE_TEXT_OFFSET as Number = 
        ( System.getDeviceSettings().screenHeight * 0.011 ).toNumber();
}
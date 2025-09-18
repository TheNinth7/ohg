import Toybox.Lang;
import Toybox.Graphics;

/*
* `GlanceConstants` uses a single implementation for all Edge devices.
*/
(:glance)
class EdgeGlanceDefaultConstants extends GlanceDefaultConstants {
    protected function initialize() { GlanceDefaultConstants.initialize(); }
    
    // Edge devices need larger fonts
    public static const UI_GLANCE_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL];
}
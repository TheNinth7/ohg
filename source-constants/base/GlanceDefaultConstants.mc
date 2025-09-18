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
}
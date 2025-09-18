import Toybox.Lang;
import Toybox.Graphics;

/*
* `GlanceConstants` uses a single implementation for all Edge devices.
*/
(:glance)
class GlanceConstants extends EdgeGlanceDefaultConstants {
    protected function initialize() { EdgeGlanceDefaultConstants.initialize(); }

    // The Edge MTB uses a white background for glances, so the font needs to be black
    public static const UI_FONT_COLOR = Graphics.COLOR_BLACK;
}
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Custom Text Drawable, extending the standard Text.
 *
 * This extension allows locX and locY to be specified as a
 * percentage of the view's width and height. Any float value ≤ 1.0
 * is interpreted as a percentage, and locX/locY will be adjusted accordingly.
 */
class RelativeText extends Text {
    typedef Options as { 
        :text as Lang.String or Lang.ResourceId, 
        :color as Graphics.ColorType, 
        :backgroundColor as Graphics.ColorType, 
        :font as Graphics.FontType, 
        :justification as Graphics.TextJustification or Lang.Number, 
        :identifier as Lang.Object, 
        :locX as Lang.Numeric, 
        :locY as Lang.Numeric, 
        :width as Lang.Numeric, 
        :height as Lang.Numeric, 
        :visible as Lang.Boolean 
    };

    public function initialize( options as Options ) {
        Text.initialize( options );
    }

    // locX and locY are adjusted only when
    // drawing, since they may be changed
    // anytime. Also they are public, so intercepting
    // setLocation is not sufficient to catch any
    // changes
    public function draw( dc as Dc ) as Void {
        if( locX instanceof Float && locX <= 1.0 ) {
            locX = dc.getWidth()*locX;
        }
        if( locY instanceof Float && locY <= 1.0 ) {
            locY = dc.getHeight()*locY;
        }
        Text.draw( dc );
    }
}
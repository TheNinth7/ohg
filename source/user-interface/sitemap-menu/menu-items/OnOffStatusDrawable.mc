import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for rendering an on/off switch.
 *
 * This class creates a `BufferedBitmap` to obtain a `Dc` for drawing the switch 
 * using primitive shapes (circles and rectangles). The resulting `BufferedBitmap` 
 * is then wrapped in a `Bitmap` to produce a `Drawable` that can be used as 
 * the status icon in `BaseMenuItem`.
 */
/*
class OnOffStatusDrawable extends Bitmap {
    
    private var _bufferedBitmap as BufferedBitmap;

    // Height and width of the switch is defined relative to the menu item height
    private const HEIGHT = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    private const WIDTH = ( Constants.UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();
    // The circles are again defines as a factor the the WIDTH defined above
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.75;

    // Constructor
    public function initialize( isEnabled as Boolean ) {
        // Initialize the options for the BufferedBitmap
        var options = {
            :width => WIDTH,
            :height => HEIGHT,
        };

        // Instantiate the `BufferedBitmap`. Devices with CIQ 4.0.0+ use `Graphics.createBufferedBitmap()`.
        // Older devices use `createOnOffBufferedBitmap()` to create a legacy-compatible wrapper.
        if( Graphics has :createBufferedBitmap ) {
            _bufferedBitmap = Graphics.createBufferedBitmap( options ).get() as BufferedBitmap;
        } else {
            _bufferedBitmap = createOnOffBufferedBitmap( options );
        }
        
        Bitmap.initialize( {
            :bitmap => _bufferedBitmap
            //:bitmap => "Hello, Hello" as BufferedBitmap // _bufferedBitmap
        } );

        // Draws the switch
        setEnabled( isEnabled );
    }

    // For CIQ < 4.0.0, this function creates a wrapper around `BufferedBitmap`
    // that adds the necessary functions to use it with a `BitmapDrawable`.
    // On newer devices, this function should not be used and will throw an exception.
    (:exclForCiq400Plus)
    private function createOnOffBufferedBitmap( options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) as OnOffBufferedBitmap {
        return new OnOffBufferedBitmap( options );
    }
    (:exclForCiqPre400)
    private function createOnOffBufferedBitmap( options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) as OnOffBufferedBitmap {
        throw new GeneralException( "Device is CiqPre400, but has no Graphics.createBufferedBitmap" );
    }

    // Draws the switch UI element.
    // The outline is composed of two circles and a rectangle:
    // - Colored in openHAB orange when "on"
    // - Colored in light grey when "off"
    // A smaller black circle indicates the current on/off position.
    public function setEnabled( isEnabled as Boolean ) as Void {
        var dc = _bufferedBitmap.getDc();
        dc.clear();

        // Define the color of the switch
        if( isEnabled ) {
            dc.setColor( 0xe64a19, Constants.UI_MENU_ITEM_BG_COLOR );
        } else {
            dc.setColor( Graphics.COLOR_LT_GRAY, Constants.UI_MENU_ITEM_BG_COLOR );
        }
        
        // Spacing defines the gap between the outer edge of the `Drawable` and the switch.
        // This is necessary because anti-aliasing can cause drawing primitives to slightly 
        // exceed their intended boundaries.
        var spacing = ( dc.getWidth() * (1-OUTER_CIRCLE_FACTOR) / 2 ).toNumber();
        // Radius of the upper and lower circles of the switch outline
        var radius = (dc.getWidth()/2).toNumber() - spacing;
        var xCenter = spacing + radius; // Horizontal center of the switch
        var upperYCenter = xCenter; // Center of the upper circle
        var lowerYCenter = dc.getHeight() - spacing - radius; // Center of the lower circle
        dc.setPenWidth( 1 );
        dc.setAntiAlias( true );
        dc.fillCircle( xCenter, upperYCenter, radius );
        dc.fillCircle( xCenter, lowerYCenter, radius );
        // Correction values -1 and + 3 have been determined by
        // trial and error and tested on different devices
        dc.fillRectangle( xCenter-radius-1, upperYCenter, radius*2 + 3, lowerYCenter - upperYCenter );

        // draw the inner circle showing the switch state
        dc.setColor( Graphics.COLOR_BLACK, Constants.UI_MENU_ITEM_BG_COLOR );
        var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
        dc.fillCircle( xCenter, toggleCenter, radius * INNER_CIRCLE_FACTOR );
    }
}
*/
// Simpler version showing ON and OFF as text
class OnOffStatusDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStatusText( isEnabled ),
            :color => Graphics.COLOR_DK_GRAY,
            :font => Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setText( getStatusText( isEnabled ) );
    }
    private function getStatusText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
}
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * Prior to CIQ 4.0.0, `BufferedBitmap` lacked `getHeight()` and `getWidth()` methods.
 * This wrapper adds those methods and can be used as input for our
 * `BufferedBitmapDrawable` implementation.
 */

// Options accepted by this class and passed on to the BufferedBitmap
typedef BufferedBitmapOptions as { 
    :width as Lang.Number, 
    :height as Lang.Number, 
    :palette as Lang.Array<Graphics.ColorType>, 
    :colorDepth as Lang.Number, 
    :bitmapResource as WatchUi.BitmapResource, 
    :alphaBlending as Graphics.AlphaBlending 
};

(:exclForCiq400Plus)
class LegacyBufferedBitmap extends BufferedBitmap {
    
    // The wrapper stores height and width and provides accessors
    private var _height as Number;
    private var _width as Number;
    
    public function initialize( options as BufferedBitmapOptions ) {
        BufferedBitmap.initialize( options );
        _height = options[:height] as Number;
        _width = options[:width] as Number;
    }
    
    public function getHeight() as Number {
        return _height;        
    }
    
    public function getWidth() as Number {
        return _width;
    }
}
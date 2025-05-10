import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * Before CIQ 4.0, `BufferedBitmap` lacked `getHeight()` and `getWidth()` methods,
 * preventing it from being used in a `Bitmap` Drawable.
 *
 * This wrapper class adds those methods to enable compatibility with older devices,
 * allowing `OnOffStatusDrawable` to function correctly.
 */
 /*
(:exclForCiq400Plus)
class OnOffBufferedBitmap extends BufferedBitmap {
    private var _height as Number;
    private var _width as Number;
    public function initialize( options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) {
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
*/
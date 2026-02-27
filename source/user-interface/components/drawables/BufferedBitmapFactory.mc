import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * Factory class for creating either a BufferedBitmap or a LegacyBufferedBitmap instance.
 *
 * In CIQ versions prior to 4.0.0, the BufferedBitmap class did not include the
 * getWidth() and getHeight() methods. This made it unsuitable for use as a Drawable
 * when positioning elements relative to its dimensions (e.g., centering vertically or horizontally).
 *
 * To support these older versions, this factory returns a LegacyBufferedBitmap, which adds
 * width and height support for compatibility with positioning logic.
 */

// On older devices we use our own LegacyBufferedBitmap ...
(:exclForCiq400Plus)
typedef BufferedBitmapType as LegacyBufferedBitmap;
// ... and on newer ones the standard BufferedBitmap
(:exclForCiqPre400)
typedef BufferedBitmapType as BufferedBitmap;

class BufferedBitmapFactory {

    // For CIQ < 4.0.0, this function creates a wrapper around `BufferedBitmap`
    // that adds the necessary functions to use it with a `BufferedBitmapDrawable`.
    (:exclForCiq400Plus)
    public static function createBufferedBitmap( options as BufferedBitmapOptions ) as BufferedBitmapType {
        return new LegacyBufferedBitmap( options );
    }
    // For CIQ 4.0.0+, the BufferedBitmap provided by the SDK can be used
    // directly with the `BufferedBitmapDrawable`
    (:exclForCiqPre400)
    public static function createBufferedBitmap( options as BufferedBitmapOptions ) as BufferedBitmapType {
        return Graphics.createBufferedBitmap( options ).get() as BufferedBitmap;
    }
}
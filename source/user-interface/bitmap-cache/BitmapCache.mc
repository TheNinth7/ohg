import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This class enables the reuse of Bitmap objects (icons) across multiple
 * menu items. It holds weak references to the Bitmaps, which do not affect
 * the reference count. As a result, any Bitmap that is no longer used by
 * a menu item (or any other class) will be automatically eligible for
 * garbage collection and removed from memory.
 */
class BitmapCache {

    // The type of the dictionary used for caching
    typedef CacheDictionary as Dictionary<ResourceId, WeakReference>;

    // The cache
    private static var _cache as CacheDictionary = {} as CacheDictionary;

    // Get a Bitmap for a given ResourceId.
    // Either retrieves it from the cache, or creates a new object.
    public static function get( rezId as ResourceId ) as Bitmap {
        var weakBitmap = _cache[ rezId ];
        if( weakBitmap == null || weakBitmap.get() == null ) {
            var bitmap = new Bitmap( { :rezId => rezId } );
            _cache.put( rezId, bitmap.weak() );
            return bitmap;
        } else {
            return weakBitmap.get() as Bitmap;
        }
    }
}
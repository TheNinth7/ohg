import Toybox.Lang;

/*
 * Exception thrown if there is not enough memory for an operation.
 */
 (:glance)
class OutOfMemoryException extends GeneralException {
    function initialize() {
        GeneralException.initialize( "Out of memory. Attempting recovery. If the issue persists, try reducing the sitemap size." );
    }
}

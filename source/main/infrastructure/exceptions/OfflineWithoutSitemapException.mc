import Toybox.Lang;

/*
 * Exception thrown if the app is started with no sitemap in storage
 * and no connectivity.
 */
class OfflineWithoutSitemapException extends GeneralException {
    function initialize() {
        GeneralException.initialize( "Offline and no sitemap is cached. Move into phone or Wi-Fi range." );
    }
}
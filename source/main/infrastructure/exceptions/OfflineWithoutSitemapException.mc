import Toybox.Lang;

/*
 * Exception thrown if the app is started with no sitemap in storage
 * and no connectivity.
 */
class OfflineWithoutSitemapException extends GeneralException {
    function initialize() {
        GeneralException.initialize( "Offline and no sitemap is cached. Connect your phone or Wi-Fi." );
    }
}
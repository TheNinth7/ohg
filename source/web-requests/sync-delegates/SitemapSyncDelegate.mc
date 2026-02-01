import Toybox.Lang;
import Toybox.Communications;
import Toybox.WatchUi;


class SitemapSyncDelegate extends BaseSyncDelegate {

    /******* STATIC *******/ 

    // Singleton instance and accessor
    private static var _instance as SitemapSyncDelegate?;

    public static function get() as SitemapSyncDelegate {
        if( _instance == null ) {
            _instance = new SitemapSyncDelegate();
        }
        return _instance as SitemapSyncDelegate;
    }

    /******* INSTANCE *******/ 

    // Constructor
    private function initialize() {
        BaseSyncDelegate.initialize();
    }

    // Overrides a method from the parent class to clean up the sitemap request.
    // Must not be called from outside. The method is public only due to
    // a Monkey C limitation that prevents overriding protected or
    // private methods.
    public function beforeSyncEnds() as Void {
        Logger.debug( "SitemapSyncDelegate: beforeSyncEnds" );
        BaseSyncDelegate.beforeSyncEnds();
        SitemapRequest.resetSyncInstance();
    }

    // Called by the app to request an update of the sitemap in sync mode
    public function requestSitemapUpdate() as Void {
        startSync( "Updating sitemap over Wi-Fi ..." );
    }

    // Called by the base class to perform the actual sync tasks.
    // Must not be called from outside. The method is public only due to
    // a Monkey C limitation that prevents overriding protected or
    // private methods.
    public function performSync() as Void {
        Logger.debug( "SitemapSyncDelegate: performSync" );

        // Note: get() returns the sync instance of the sitemap request
        SitemapRequest.get().makeSingleRequest();
    }
}
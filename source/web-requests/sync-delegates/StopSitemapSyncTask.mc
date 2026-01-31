import Toybox.Lang;

/*
 * Asynchronous task to stop sync mode after processing of the sitemap update was completed.
 */
 class StopSitemapSyncTask extends BaseSitemapProcessorTask {

    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }

    public function invoke() as Void {
        Logger.debug( "StopSitemapSyncTask: stopping sync mode" );
        SitemapSyncDelegate.get().stopSync();
    }
}

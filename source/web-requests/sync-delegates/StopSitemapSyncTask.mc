import Toybox.Lang;

/*
 * Asynchronous task to restart the sitemap request after the sync mode has been closed.
 */
 class StopSitemapSyncTask {

    public function invoke() as Void {
        Logger.debug( "StopSitemapSyncTask: stopping sync mode" );
        SitemapSyncDelegate.get().stopSync();
    }

    public function handleException( ex as Exception ) as Void{
        ExceptionHandler.handleBackgroundException( ex );
    }
}

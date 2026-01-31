import Toybox.Lang;

/*
 * Asynchronous task to restart the sitemap request after the sync mode has been closed.
 */
 class RestartSitemapRequestTask extends BaseSitemapProcessorTask {

    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }

    public function invoke() as Void {
        Logger.debug( "RestartSitemapRequestTask: restarting sitemap request" );
        SitemapRequest.get().start();
    }
}

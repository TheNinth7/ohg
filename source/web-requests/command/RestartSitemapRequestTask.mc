import Toybox.Lang;

/*
 * Asynchronous task to restart the sitemap request after the sync mode has been closed.
 */
 class RestartSitemapRequestTask {

    public function invoke() as Void {
        Logger.debug( "RestartSitemapRequestTask: restarting sitemap request" );
        SitemapRequest.get().start();
    }

    public function handleException( ex as Exception ) as Void{
        ExceptionHandler.handleException( ex );
    }
}

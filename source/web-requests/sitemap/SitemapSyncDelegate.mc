import Toybox.Lang;
import Toybox.Communications;
import Toybox.WatchUi;

/*
 * This sync delegate implements Wi-Fi–based command sending using Connect IQ's
 * sync mode. When on a Wi-Fi connection, BaseCommandRequest.sendCommand() starts
 * sync mode. OHApp.getSyncDelegate() then returns a delegate that requires sync,
 * causing the API to establish Wi-Fi connectivity and invoke onStartSync() in
 * this class.
 *
 * See the following link for API documentation:
 * https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/connect-iq-3-1-connects-you-to-the-world
 *
 * This delegate also implements the CommandRequestDelegate interface and can
 * therefore be passed to the command request as a kind of dummy menu item. The
 * command request is then executed in sync mode (see BaseCommandRequest for
 * details).
 *
 * After the web request is initiated in onStartSync(), onCommandCompletion() is
 * called if the request completes successfully and notifies the API that sync
 * mode is finished. If an error occurs while processing the web request,
 * onException() is invoked, and onStopSync() is called if the user interrupts
 * the sync.
 */
class SitemapSyncDelegate extends SyncDelegate {

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

    // Set if a sitemap request should be executed
    private var _isSyncNeeded as Boolean = false;
    
    // Constructor
    private function initialize() {
        SyncDelegate.initialize();
    }

    // Helper functions used by all functions that are stopping the sync
    // It resets the command, and adds the task that restarts the sitemap
    // request. Note that the sitemap request should not be started in the
    // sync delegate itself, since then it may still run on the Wifi connection,
    // which then is likely closed before the request completes.
    private function beforeSyncEnds() as Void {
        _isSyncNeeded = false;
        AsyncTaskQueue.get().add( new RestartSitemapRequestTask() );
    }

    // Set the command to be send
    public function requestSync() as Void {
        _isSyncNeeded = true;
    }

    /*
    // Is called when the command request is successful and terminates
    // the sync mode
    // Part of the CommandRequestDelegate interface
    public function onCommandComplete( syncMode as Boolean ) as Void {
        Logger.debug( "SitemapSyncDelegate: onCommandComplete start" );
        beforeSyncEnds();
        Communications.notifySyncComplete( null );
        Logger.debug( "SitemapSyncDelegate: onCommandComplete end" );
        //WatchUi.switchToView( ViewHandler.getCurrentViewSafe()[0] as View, ViewHandler.getCurrentViewSafe()[1], WatchUi.SLIDE_BLINK );
    }

    // Is called when the command request runs into an error and
    // terminates the sync mode with the error message
    // Part of the CommandRequestDelegate interface
    function onException( ex as Exception ) as Void {
        Logger.debug( "SitemapSyncDelegate: onException start" );
        beforeSyncEnds();
        Communications.notifySyncComplete( ex.getErrorMessage() );
        Logger.debug( "SitemapSyncDelegate: onException end" );
    }
    */

    // This is called by the API to check if a sync is needed.
    // Therefore needs to return true if a command is waiting to be sent
    public function isSyncNeeded() as Boolean {
        Logger.debug( "SitemapSyncDelegate: isSyncNeeded=" + _isSyncNeeded );
        return _isSyncNeeded;
    }

    // This is called by the API to start sync.
    public function onStartSync() as Void {
        Logger.debug( "SitemapSyncDelegate: onStartSync start" );
        try {
            // Start with 20% progress
            Communications.notifySyncProgress( 20 );
            
            /*
            // Create the command request with self as dummy-item and 
            // true indicating that it should be in sync mode
            var commandRequest = BaseCommandRequest.get( self, true );
            
            // Send the command
            if( commandRequest != null ) {
                commandRequest.sendCommand( ensureCommand()[1] );
            } else {
                onException( new GeneralException( "SitemapSyncDelegate: neither REST API nor Webhook are available" ) );
            }
            */
        } catch( ex ) {
            //onException( ex );
        }
        Logger.debug( "SitemapSyncDelegate: onStartSync end" );
    }

    // This is called by the API if the user interrupts sync
    // Cancels all open requests and stops the sync mode
    public function onStopSync() as Void {
        Logger.debug( "SitemapSyncDelegate: onStopSync start" );
        BaseRequest.cancelAllRequests();
        beforeSyncEnds();
        Communications.notifySyncComplete( null );
        Logger.debug( "SitemapSyncDelegate: onStopSync stop" );
    }
}
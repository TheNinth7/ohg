import Toybox.Lang;
import Toybox.Communications;
import Toybox.WatchUi;

/* Base class for sync delegates.
 *
 * In the CIQ API, sync delegates perform tasks that require a Wi-Fi
 * connection. Due to battery constraints on Garmin devices, Wi-Fi is
 * only available on demand and for a limited time. An app can request
 * a Wi-Fi–based sync via Communications.startSync(), which is wrapped
 * by this class.
 *
 * Lifecycle overview:
 *
 * - startSync()
 *   Called by the app to request entering sync mode.
 *
 * - onStartSync()
 *   Invoked by the CIQ API once a Wi-Fi connection has been established.
 *   This method performs common setup and then calls performSync().
 *
 * - performSync()
 *   Abstract method to be implemented by subclasses. Contains the
 *   actual sync logic.
 *
 * - finishSync()
 *   Must be called by subclasses when the sync completes successfully.
 *   Exits sync mode.
 *
 * - onException()
 *   Should be called by subclasses if an error occurs during syncing.
 *   Exits sync mode and displays an error message to the user.
 *
 * - onStopSync()
 *   Called by the CIQ API if the user interrupts the sync.
 *
 * See the following link for API documentation:
 * https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/connect-iq-3-1-connects-you-to-the-world
 *
 */
class BaseSyncDelegate extends SyncDelegate {

    // The sync result tuple indicates in its first field whether a sync was performed
    // (true) or not (false), regardless of success. The second field is null if the
    // request was successful; otherwise, it contains the exception describing the error.
    typedef WifiSyncResult as [Boolean,Exception?];
    private const RESET_SYNC_STATE = [false, null];

    // Set to true while the sync is in progress
    private var _isSyncInProgress as Boolean = false;

    // Set to true if a sync was requested, indicating
    // to OHApp.getSyncDelegate which of the two delegates
    // requires a sync
    private var _isSyncNeeded as Boolean = false;
    
    // Holds the result of the last sync
    private var _lastSyncState as WifiSyncResult = RESET_SYNC_STATE;

    // Constructor
    public function initialize() {
        SyncDelegate.initialize();
    }

    // Helper function used by all code paths that stop the sync.
    // Resets internal state and schedules the task that restarts the
    // sitemap request.
    //
    // Note: The sitemap request must not be started directly from the
    // sync delegate. At that point it may still run on the Wi-Fi
    // connection, which is likely to be closed before the request
    // completes.
    public function beforeSyncEnds() as Void {
        // Logger.debug( "BaseSyncDelegate: beforeSyncEnds" );
        _isSyncNeeded = false;
        _isSyncInProgress = false;
        _lastSyncState[0] = true;
        AsyncTaskQueue.get().add( new PostSyncTask() );
    }

    // Returns the result of the last sync and resets the stored result
    public function consumeLastSyncResult() as WifiSyncResult {
        var lastSyncState = _lastSyncState;
        _lastSyncState = RESET_SYNC_STATE;
        return lastSyncState;
    }

    // Exits sync mode. Subclasses must call this method when their sync
    // operation has completed successfully.
    public function finishSync() as Void {
        // Logger.debug( "BaseSyncDelegate: finishSync" );
        beforeSyncEnds();
        Communications.notifySyncComplete( null );
        // Logger.debug( "BaseSyncDelegate: finishSync end" );
    }

    // Can be used by other classes to adjust their behavior depending on
    // whether the application is currently in sync mode. For example,
    // exception handling differs, and sitemap responses must not trigger
    // any screen updates while sync mode is active.
    public function isSyncInProgress() as Boolean {
        // Logger.debug( "BaseSyncDelegate: isSyncInProgress=" + _isSyncInProgress );
        return _isSyncInProgress;
    }

    // Called by the API to determine whether a sync is required.
    // Must return true if a sync should be initiated.
    public function isSyncNeeded() as Boolean {
        // Logger.debug( "BaseSyncDelegate: isSyncNeeded=" + _isSyncNeeded );
        return _isSyncNeeded;
    }

    // Subclasses must call this method when their sync operation fails.
    // It exits sync mode and displays an error message to the user.
    public function onException( ex as Exception ) as Void {
        // Logger.debug( "BaseSyncDelegate: onException" );
        
        // Not needed here, since notifySyncComplete with an error message
        // also triggers onStopSync(), which in turn calls beforeSyncEnds().
        // beforeSyncEnds();
        
        _lastSyncState[1] = ex;
        Communications.notifySyncComplete( ex.getErrorMessage() );
        // Logger.debug( "BaseSyncDelegate: onException end" );
    }

    // Called by the API to start the sync.
    // Reports initial progress and then calls performSync(), where
    // subclasses implement the actual sync logic. Exception handling
    // is handled here, so performSync implementation may throw 
    // exceptions and expect them to be handled.
    public function onStartSync() as Void {
        // Logger.debug( "BaseSyncDelegate: onStartSync" );
        try {
            ConnectivityHandler.get().debugConnectionInfo();

            _isSyncInProgress = true;

            // Start with 20% progress
            Communications.notifySyncProgress( 20 );

            performSync();
            
        } catch( ex ) {
            onException( ex );
        }
        // Logger.debug( "BaseSyncDelegate: onStartSync end" );
    }

    // Called by the API when the user interrupts the sync
    // or when the sync is ended by calling Communications.notifySyncComplete
    // with an error message.
    // Cancels all pending requests and exits sync mode.
    public function onStopSync() as Void {
        // Logger.debug( "BaseSyncDelegate: onStopSync" );
        BaseRequest.cancelAllRequests();
        beforeSyncEnds();
        // Logger.debug( "BaseSyncDelegate: onStopSync end" );
    }

    // To be implemented by subclasses to perform the actual sync logic.
    // Implementations may throw exceptions, which are handled by onStartSync(),
    // the method that invokes this function.
    public function performSync() as Void {
        throw new AbstractMethodException( "BaseSyncDelegate.performSync" );
    }

    // Starts a sync request and displays the provided message to the user.
    // Marks this instance as needing a sync, stops the sitemap request timer,
    // and requests sync mode from the CIQ API.
    public function startSync( msg as String ) as Void {
        // Logger.debug( "BaseSyncDelegate: startSync" );
        try {
            ConnectivityHandler.get().debugConnectionInfo();
            _isSyncNeeded = true;
            SitemapRequest.get().stop();
            // Newer API versions support displaying a custom message in the sync view
            if( Communications has :startSync2 ) {
                Communications.startSync2( { :message => msg } );
            } else {
                Communications.startSync();
            }
        } catch( ex ) {
            _isSyncNeeded = false;
            SitemapRequest.get().start();
            throw ex;
        }
    }
}
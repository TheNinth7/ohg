import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Time;

/*
 * This singleton class keeps track of the current connectivity state.
 *
 * Connectivity is driven by sitemap requests. On startup, the
 * ConnectivityHandler assumes that a phone connection is available
 * (PHONE_CONNECTION).
 *
 * If a sitemap request fails because the phone is not connected,
 * the SitemapRequest asks the ConnectivityHandler to check WiFi
 * availability. The connectivity state then transitions to
 * WIFI_CHECK_PENDING.
 *
 * If WiFi is available, the state moves to WIFI_CONNECTION.
 * Otherwise, it transitions to OFFLINE.
 *
 * The sitemap request continues to execute, and the connectivity
 * state is updated accordingly.
 */
 public class ConnectivityHandler {

    /******* STATIC *******/ 

    // Singleton instance and accessor
    private static var _instance as ConnectivityHandler?;

    public static function get() as ConnectivityHandler {
        if( _instance == null ) {
            _instance = new ConnectivityHandler();
        }
        return _instance as ConnectivityHandler;
    }

    /******* INSTANCE *******/ 

    // The four connectivity states
    public enum State {
        PHONE_CONNECTION,
        WIFI_CHECK_PENDING,
        WIFI_CONNECTION,
        OFFLINE
    }

    // The Dictionary type passed to the callback when checking
    // for WiFi connection
    typedef TryWifiResult as { 
        :wifiAvailable as Lang.Boolean, 
        :errorCode as Communications.WifiConnectionStatus 
    };

    // See processDeferredResult
    private var _deferredResult as TryWifiResult?;

    // The current state
    private var _state as State = PHONE_CONNECTION;

    // The timestamp of the last successful Wifi check
    private var _lastSuccessfullConnection as Moment?;
    
    // Only needed to be declared private to prevent other classes
    // from instantiating this singleton
    private function initialize() {}


    // This is called by `SitemapRequest` and indicates that phone
    // connection is currently available
    public function confirmPhoneConnection() as Void {
        setState( PHONE_CONNECTION );
        _lastSuccessfullConnection = Time.now();
    }

    // Called by `OhApp` during startup to determine whether
    // any special connectivity handling is required.
    // Returns a WifiCheckView if a WiFi check is pending,
    // and throws an OfflineException if there is no connectivity.
    // In all other cases, it returns null, indicating that `OhApp`
    // can assume full connectivity.
    public function ensureConnectivity() as WifiCheckView? {
        if( _state == WIFI_CHECK_PENDING ) {
            return new WifiCheckView();
        } else if (_state == OFFLINE ) {
            throw new OfflineException();
        } else {
            return null;
        }
    }

    // Returns the state
    public function getState() as State {
        return _state;
    }

    // Returns a textual description of the current state
    public function getStateDescription() as String {
        switch( _state ) {
            case PHONE_CONNECTION: return "Phone";
            case WIFI_CHECK_PENDING: return "Checking WiFi availablity ...";
            case WIFI_CONNECTION: return "WiFi";
            case OFFLINE: return "Offline";
            default: return "Invalid";
        }
    }

    // True if no connection is available
    public function isOffline() as Boolean {
        return _state == OFFLINE;
    }

    // True if phone connection is available
    public function isOnPhoneConnection() as Boolean {
        return _state == PHONE_CONNECTION;
    }

    // True if no phone connection is available
    // but WiFi is
    public function isOnWiFiConnection() as Boolean {
        return _state == WIFI_CONNECTION;
    }

    // Returns true if last Wifi check happened within the
    // state expiry time. While states are not acutally shown
    // in Wifi mode, we still want to use the same timeframe
    // to go into offline mode if Wifi connection is lost.
    public function hadSuccessfulConnectionWithinLimit() as Boolean {
        return 
            _lastSuccessfullConnection != null
            && Time.now().compare( _lastSuccessfullConnection ) < Constants.STATE_EXPIRATION_TIME;
    }

    // If on startup there is no phone connection, the WiFi check
    // result may be returned before the first view is fully loaded.
    // In this case, the result is stored here and processing is
    // deferred to `WifiCheckTimer`, which will repeatedly check
    // and call processDeferredResult when the view has been fully
    // loaded.
    public function processDeferredResult() as Void {
        if( _deferredResult != null ) {
            tryWifiConnectionCallback( _deferredResult );
            _deferredResult = null;
        }
    }

    // Internal functions used to update the connectivity state.
    // In addition to storing the new state, they trigger a UI update
    // if the settings menu is currently displayed, since that menu
    // shows the current connectivity mode.
    private function setState( state as State ) as Void {
        _state = state;
        if( SettingsMenuHandler.isShowingSettings() ) {
            WatchUi.requestUpdate();
        }
    }

    // This is called by `SitemapRequest`, indicates that no phone 
    // connection is available and triggers a check of WiFi availability.
    public function tryWifiConnection() as Void {
        if( _state == PHONE_CONNECTION ) {
            setState( WIFI_CHECK_PENDING );
        }
        Communications.checkWifiConnection( method( :tryWifiConnectionCallback ) );
    }

    // Processes the result of the WiFi availability check.
    // Depending on the outcome, the displayed view is updated
    // and sitemap states are invalidated if necessary.
    public function tryWifiConnectionCallback( result as TryWifiResult ) as Void {
        
        if( ViewHandler.getCurrentViewSafe()[0] == null ) {
            // If there is no view, we defer the processing of the result
            // The processing of the deferred result is triggered by `WifiCheckTimer`,
            // which is triggered in `WifiCheckView.onUpdate`, because only after that
            // the initial view is loaded (starting it here could lead to unncessary executions
            // before the initial view was loaded)
            _deferredResult = result;
        } else {
            try {
                // If since the request was made the state has been changed
                // back to PHONE_CONNECTION, we ignore the result
                if( _state != PHONE_CONNECTION && result[:wifiAvailable] == true ) {
                    // If WiFi is available ...

                    _lastSuccessfullConnection = Time.now();
                    
                    // ... and that was previously unknown ...
                    if( _state != WIFI_CONNECTION ) {

                        // ... we update the state.
                        setState( WIFI_CONNECTION );

                        // Only if a HomepageMenu is available ...
                        if( HomepageMenu.exists() ) {
                            var menu = HomepageMenu.get();
                            // ... we invalidate the values ...
                            if( SitemapStore.isSitemapFresh() ) {
                                var sitemap = SitemapStore.getSitemapFromMemoryForWifiMode();
                                if( sitemap != null ) {
                                    menu.update( sitemap );
                                    // The update runs asynchronously, so we add a task that
                                    // switches to the menu or triggers an UI refresh if it
                                    // is already shown
                                    AsyncTaskQueue.get().add( new WifiCheckRefreshUiTask() );
                                } else {
                                    throw new GeneralException( "ConnectivityHandler: failed to invalidate menu states because no sitemap is loaded in memory." );
                                }
                            } else if( ! HomepageMenu.isSitemapShowing() ) {
                                // If the sitemap is not fresh, and the menu is currently not shown, we
                                // switch to it immediately.
                                ViewHandler.popToBottomAndSwitch( HomepageMenu.get(), HomepageMenuDelegate.get() );
                            }
                        } else {
                            // Currently we only throw an exception if there is no sitemap
                            // data available. This will be changed to do a WiFi sitemap request
                            throw new GeneralException( "No sitemap in storage, sync via phone first." );
                        }
                    }
                } else {
                    // If the state changed to OFFLINE ...
                    if( _state != OFFLINE ) {
                        setState( OFFLINE );
                    }
                    throw new OfflineException();
                }
            } catch( ex ) {
                ExceptionHandler.handleException( ex );
            }
        }
    }
}